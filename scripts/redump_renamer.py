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

_CLIENT = httpx.Client()

# temporary cache to allow for updates
REDUMP_DAT_FILE = pathlib.Path('/tmp/redump.pickle')

_DISC_PATH_PATTERN = re.compile(r'/disc/(\d+)/')
_PAGE_PATH_PATTERN = re.compile(r'.*\?page=(\d+)')

# im guessing a redump ID's hashes should never change so
# this should be permanently cachable
SHA1_CACHE_FILE = pathlib.Path('/storage/Cache/redump/sha1.pickle')
SHA1_CACHE = None

SUFFIXES = ('.bin', '.iso', '.mdf')


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


def scrape_redump(name, system):
    part = name.split()[0]
    url = yarl.URL(
        f'http://redump.org/discs/system/{system}/quicksearch') / part

    current_page = 1
    max_pages = 1
    while current_page <= max_pages:
        response = _CLIENT.get(
            str(url.with_query({'page': str(current_page)})),
            follow_redirects=True)
        response.raise_for_status()

        # handle redirect to specific item when only single match.
        # ex. searching 'Cryptic' for 'Cryptic Passage for Blood'
        if match := _DISC_PATH_PATTERN.findall(
                yarl.URL(str(response.url)).path):
            yield int(match[0])
            return

        soup = bs4.BeautifulSoup(response.text, 'lxml')

        for link in soup.find_all('a'):
            if path := link.get('href'):
                if found := _PAGE_PATH_PATTERN.findall(path):
                    max_pages = max(max_pages, int(found[0]))
                elif found := _DISC_PATH_PATTERN.findall(path):
                    redump_id = int(found[0])
                    yield redump_id
        current_page += 1


def download_datfiles():
    """
    Download the redump PC datfile.

    Note: the response does not contain an etag
    """
    if REDUMP_DAT_FILE.exists():
        data = pickle.loads(REDUMP_DAT_FILE.read_bytes())
    else:
        systems = [
            'dc',   # dreamcast
            'gc',   # gamecube
            'mac',  # macintosh
            'pc',   # PC
            'ps2',  # playstation 2
            'psx',  # playstation
            'wii',  # wii
        ]
        data = {}
        for system in systems:
            response = _CLIENT.get(f'http://redump.org/datfile/{system}/')
            response.raise_for_status()
            archive = zipfile.ZipFile(io.BytesIO(response.content))
            if len(archive.namelist()) != 1:
                raise RuntimeError('expected archive to contain one file')
            dat_file = archive.read(archive.namelist()[0])
            REDUMP_DAT_FILE.write_bytes(dat_file)
            data[system] = xml.etree.ElementTree.parse(REDUMP_DAT_FILE)
        safe_write_bytes(REDUMP_DAT_FILE, pickle.dumps(data))
    return data


@functools.lru_cache()
def download_sha1(redump_id):
    global SHA1_CACHE

    if SHA1_CACHE is None:
        if SHA1_CACHE_FILE.exists():
            SHA1_CACHE = pickle.loads(SHA1_CACHE_FILE.read_bytes())
        else:
            SHA1_CACHE = {}

    redump_id = str(redump_id)
    if redump_id not in SHA1_CACHE:
        response = _CLIENT.get(f'http://redump.org/disc/{redump_id}/sha1/')
        response.raise_for_status()
        SHA1_CACHE[redump_id] = response.text
        safe_write_bytes(SHA1_CACHE_FILE, pickle.dumps(SHA1_CACHE))

    hashes = {}
    for line in SHA1_CACHE[redump_id].splitlines():
        sha1_hash, name = line.split(maxsplit=1)
        if not name.lower().endswith(SUFFIXES):
            continue
        hashes[name] = sha1_hash
    return {
        key: hashes[key]
        for key in sorted(hashes)
    }


def find_dump_hashes(root):
    paths = [
        path
        for path in root.iterdir()
        if path.is_file() and path.suffix in SUFFIXES
    ]
    if len(paths) > 1:
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


def get_name(path):
    arg_hashes = find_dump_hashes(path)
    expected = tuple(arg_hashes.values())

    hashes = {}
    for system, x in download_datfiles().items():
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

    for redump_id in scrape_redump(name, system):
        sha1 = download_sha1(redump_id)
        if expected == tuple(sha1.values()):
            return redump_id, name.replace('/', '')

    raise RuntimeError('wtf')


def process_path(path):
    print('PROCESSING', path)
    if path.is_file():
        if path.suffixes[-2:] != ['.tar', '.zst']:
            raise RuntimeError()

        suffix = '.tar.zst'
        parent = pathlib.Path('~').expanduser()
        with tempfile.TemporaryDirectory(dir=parent) as tmp:
            dest = pathlib.Path(tmp) / path.name
            extract(path, dest)
            redump_id, name = get_name(dest)
    else:
        suffix = ''
        redump_id, name = get_name(path)

    if redump_id:
        rename_path(path, path.with_name(f'redump_{redump_id} {name}{suffix}'))
    else:
        if not path.name.startswith('unknown '):
            target = path.with_name(f'unknown {path.name}')
            while target.exists():
                target = target.with_name(f'{target.name}_')
            path.rename(target)


def rename_path(path, target):
    if path == target:
        print('VALIDATED', target)
        return
    if target.exists():
        raise RuntimeError(f'target exists {target}')
    print('RENAMING', path, target)
    path.rename(target)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('path', type=pathlib.Path, nargs='+')
    args = parser.parse_args()

    for path in args.path:
        process_path(path)


if __name__ == '__main__':
    main()
    _CLIENT.close()
