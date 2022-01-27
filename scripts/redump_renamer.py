#!/usr/bin/env python
import argparse
import functools
import hashlib
import io
import pathlib
import pickle
import re
import subprocess
import tempfile
import xml.etree.ElementTree
import zipfile

import bs4
import httpx
import yarl

SUFFIXES = ('.bin', '.iso', '.mdf')


class Redump:
    # im guessing a redump ID's hashes should never change so
    # this should be permanently cachable
    SHA1_CACHE_FILE = pathlib.Path('/storage/Cache/redump/sha1.pickle')

    # temporary cache to allow for updates
    REDUMP_DAT_FILE = pathlib.Path('/tmp/redump.pickle')

    _DISC_PATH_PATTERN = re.compile(r'/disc/(\d+)/')
    _PAGE_PATH_PATTERN = re.compile(r'.*\?page=(\d+)')

    def __init__(self):
        self.client = httpx.Client()
        self.url = yarl.URL('http://redump.org')
        self.datfiles = self.download_datfiles()
        self.sha1_cache = None

    def download_datfiles(self):
        """
        Download the redump PC datfile.

        Note: the response does not contain an etag
        """
        if self.REDUMP_DAT_FILE.exists():
            data = pickle.loads(self.REDUMP_DAT_FILE.read_bytes())
        else:
            systems = [
                'dc',   # dreamcast
                'gc',   # gamecube
                'mac',  # macintosh
                'mcd',  # SEGA Mega CD
                'pc',   # PC
                'ps2',  # playstation 2
                'ps3',  # playstation 3
                'psp',  # playstation portable
                'psx',  # playstation
                'wii',  # wii
            ]
            data = {}
            for system in systems:
                response = self.client.get(
                    str(self.url / 'datfile' / system))
                response.raise_for_status()
                archive = zipfile.ZipFile(io.BytesIO(response.content))
                if len(archive.namelist()) != 1:
                    raise RuntimeError('expected archive to contain one file')
                dat_file = archive.read(archive.namelist()[0])
                self.REDUMP_DAT_FILE.write_bytes(dat_file)
                data[system] = xml.etree.ElementTree.parse(
                    self.REDUMP_DAT_FILE)
            safe_write_bytes(self.REDUMP_DAT_FILE, pickle.dumps(data))
        return data

    def scrape_redump(self, name, system):
        part = name.split()[0]
        url = self.url / 'discs' / 'system' / system / 'quicksearch' / part

        current_page = 1
        max_pages = 1
        while current_page <= max_pages:
            response = self.client.get(
                str(url.with_query({'page': str(current_page)})),
                follow_redirects=True)
            response.raise_for_status()

            # handle redirect to specific item when only single match.
            # ex. searching 'Cryptic' for 'Cryptic Passage for Blood'
            if match := self._DISC_PATH_PATTERN.findall(
                    yarl.URL(str(response.url)).path):
                yield int(match[0])
                return

            soup = bs4.BeautifulSoup(response.text, 'lxml')

            for link in soup.find_all('a'):
                if path := link.get('href'):
                    if found := self._PAGE_PATH_PATTERN.findall(path):
                        max_pages = max(max_pages, int(found[0]))
                    elif found := self._DISC_PATH_PATTERN.findall(path):
                        redump_id = int(found[0])
                        yield redump_id
            current_page += 1

    @functools.lru_cache()
    def download_sha1(self, redump_id):
        if self.sha1_cache is None:
            if self.SHA1_CACHE_FILE.exists():
                self.sha1_cache = pickle.loads(
                    self.SHA1_CACHE_FILE.read_bytes())
            else:
                self.sha1_cache = {}

        redump_id = str(redump_id)
        if redump_id not in self.sha1_cache:
            response = self.client.get(
                str(self.url / 'disc' / redump_id / 'sha1'))
            response.raise_for_status()
            self.sha1_cache[redump_id] = response.text
            safe_write_bytes(
                self.SHA1_CACHE_FILE, pickle.dumps(self.sha1_cache))

        hashes = {}
        for line in self.sha1_cache[redump_id].splitlines():
            sha1_hash, name = line.split(maxsplit=1)
            if not name.lower().endswith(SUFFIXES):
                continue
            hashes[name] = sha1_hash
        return {
            key: hashes[key]
            for key in sorted(hashes)
        }


def safe_write_bytes(path, data):
    path = pathlib.Path(path)
    with tempfile.NamedTemporaryFile(delete=False, dir=path.parent) as handle:
        try:
            temp_path = pathlib.Path(handle.name)
            temp_path.write_bytes(data)
            temp_path.rename(path)
        finally:
            try:
                temp_path.unlink()
            except FileNotFoundError:
                pass


def find_dump_hashes(root):
    paths = [
        path
        for path in root.iterdir()
        if path.is_file() and path.suffix in SUFFIXES
    ]

    if len(paths) > 1:
        iso_paths = [path for path in paths if path.suffix == '.iso']
        if len(iso_paths) == 1:
            paths = iso_paths
        else:
            for path in paths:
                if path.suffix != '.bin':
                    raise RuntimeError('unexpected files')

    return {path: sha1sum(path) for path in sorted(paths)}


def sha1sum(path):
    hasher = hashlib.sha1()
    with open(path, 'rb') as handle:
        while data := handle.read(65536):
            hasher.update(data)
    return hasher.hexdigest()


def extract(path, dest_dir):
    subprocess.run(
        ['extract', '--quiet', '-p', str(dest_dir), '--', str(path)],
        check=True)


def get_name(path, redump):
    arg_hashes = find_dump_hashes(path)
    expected = tuple(arg_hashes.values())

    hashes = {}
    for system, x in redump.datfiles.items():
        for thing in x.getroot():
            if thing.tag != 'game':
                continue
            hashes_by_name = {}
            for item in thing:
                if item.tag != 'rom':
                    continue
                if not item.attrib['name'].lower().endswith(SUFFIXES):
                    continue
                hashes_by_name[item.attrib['name']] = item.attrib['sha1']
            thing_hashes = tuple(
                hashes_by_name[name]
                for name in sorted(hashes_by_name)
            )
            hashes[thing_hashes] = system, thing.attrib['name']

    try:
        system, name = hashes[tuple(arg_hashes.values())]
    except KeyError:
        return None, path.name

    # fix for games like 'Fury^3'
    name = name.replace('^', '')

    for redump_id in redump.scrape_redump(name, system):
        sha1 = redump.download_sha1(redump_id)
        if expected == tuple(sha1.values()):
            return redump_id, name.replace('/', '')

    raise RuntimeError('wtf')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--no-rename', action='store_true')
    parser.add_argument('path', type=pathlib.Path, nargs='+')
    args = parser.parse_args()

    redump = Redump()

    for path in args.path:
        print('PROCESSING', path)
        if path.is_file():
            if path.suffixes[-2:] != ['.tar', '.zst']:
                raise RuntimeError()

            suffix = '.tar.zst'
            parent = pathlib.Path('~').expanduser()
            with tempfile.TemporaryDirectory(dir=parent) as tmp:
                dest = pathlib.Path(tmp) / path.name
                extract(path, dest)
                redump_id, name = get_name(dest, redump)
        else:
            suffix = ''
            redump_id, name = get_name(path, redump)

        if redump_id:
            target = path.with_name(f'redump_{redump_id} {name}{suffix}')

            if path == target:
                print('✅ VALIDATED', target)
                return
            if target.exists():
                raise RuntimeError(f'target exists {target}')
            print('✅ RENAMING', path, target)

            if not args.no_rename:
                path.rename(target)

        else:
            print('⚠  ERROR: unknown', path.name)
            if not path.name.startswith('unknown '):
                target = path.with_name(f'unknown {path.name}')
                while target.exists():
                    target = target.with_name(f'{target.name}_')
                if not args.no_rename:
                    path.rename(target)


if __name__ == '__main__':
    main()
