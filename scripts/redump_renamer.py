#!/usr/bin/env python
import argparse
import asyncio
import contextvars
import hashlib
import io
import logging
import pathlib
import re
import tempfile
import xml.etree.ElementTree
import zipfile

import bs4  # beautifulsoup4
import httpx
import sqlitedict
import yarl
import zstandard

SUFFIXES = ('.bin', '.iso', '.mdf')

NAME = 'redump-renamer'

LOGGER = logging.getLogger(NAME)

_LOG_CONTEXT = {}


def disk_cache(path):
    return sqlitedict.SqliteDict(
        path,
        decode=lambda obj: sqlitedict.decode(zstandard.decompress(obj)),
        encode=lambda obj: zstandard.compress(bytes(sqlitedict.encode(obj))),
        encode_key=sqlitedict.encode_key,
        decode_key=sqlitedict.decode_key,
        autocommit=True)


def log_context(key, value):
    global _LOG_CONTEXT

    if key not in _LOG_CONTEXT:
        _LOG_CONTEXT[key] = contextvars.ContextVar(key, default=None)

    _LOG_CONTEXT[key].set(value)


class _LogFormatter(logging.Formatter):
    def format(self, record):
        parts = [super().format(record)]

        for key, cvar in _LOG_CONTEXT.items():
            value = cvar.get()
            if value:
                parts.append(f'[{key} {value}]')

        return ' '.join(parts)


def setup_logging(name, level=logging.INFO):
    logger = logging.getLogger()
    logger.setLevel(level)

    fmt = _LogFormatter('%(levelname)-8s %(name)s %(message)s')

    sh = logging.StreamHandler()
    sh.setLevel(level)
    sh.setFormatter(fmt)
    logger.addHandler(sh)


class Redump:
    _DISC_PATH_PATTERN = re.compile(r'/disc/(\d+)/')
    _PAGE_PATH_PATTERN = re.compile(r'.*\?page=(\d+)')

    _DEFAULT_SHA1_PATH = '/storage/Cache/redump/sha1'
    _DEFAULT_DAT_PATH = '/storage/Cache/redump/dat'

    def __init__(self):
        # im guessing a redump ID's hashes should never change so
        # this should be permanently cachable
        pathlib.Path(self._DEFAULT_SHA1_PATH).parent.mkdir(
            parents=True, exist_ok=True)
        self.sha1_cache = disk_cache(self._DEFAULT_SHA1_PATH)

        # temporary cache to allow for updates
        self.dat_cache = disk_cache(self._DEFAULT_DAT_PATH)
        pathlib.Path(self._DEFAULT_DAT_PATH).parent.mkdir(
            parents=True, exist_ok=True)

        self.client = httpx.AsyncClient()
        self.url = yarl.URL('http://redump.org')

    async def download_datfiles(self):
        """
        Download the redump PC datfile.

        Note: the response does not contain an etag
        """
        LOGGER.info('Updating .dat files')
        systems = [
            'dc',   # dreamcast
            'gc',   # gamecube
            'mac',  # macintosh
            'mcd',  # SEGA Mega CD
            'palm', # palm os
            'pc',   # PC
            'ps2',  # playstation 2
            'ps3',  # playstation 3
            'psp',  # playstation portable
            'psx',  # playstation
            'ss',   # SEGA Saturn
            'wii',  # wii
            'xbox', # xbox
        ]
        data = {}
        for system in systems:
            LOGGER.debug('Downloading dat for %s', system)
            response = await self.client.get(
                str(self.url / 'datfile' / system))
            response.raise_for_status()
            archive = zipfile.ZipFile(io.BytesIO(response.content))
            if len(archive.namelist()) != 1:
                raise RuntimeError('expected archive to contain one file')
            dat_file = io.BytesIO()
            dat_file.write(archive.read(archive.namelist()[0]))
            dat_file.seek(0)
            self.dat_cache[system] = xml.etree.ElementTree.parse(dat_file)

    async def scrape_redump(self, name, system):
        part = name.split()[0]
        url = self.url / 'discs' / 'system' / system / 'quicksearch' / part

        current_page = 1
        max_pages = 1
        while current_page <= max_pages:
            response = await self.client.get(
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

    async def download_sha1(self, redump_id):
        redump_id = str(redump_id)
        if redump_id not in self.sha1_cache:
            response = await self.client.get(
                str(self.url / 'disc' / redump_id / 'sha1'))
            response.raise_for_status()
            self.sha1_cache[redump_id] = response.text
        return self._parse_sha1_response(self.sha1_cache[redump_id])

    @staticmethod
    def _parse_sha1_response(data):
        hashes = {}
        for line in data.splitlines():
            sha1_hash, name = line.split(maxsplit=1)
            if not name.lower().endswith(SUFFIXES):
                continue
            hashes[name] = sha1_hash
        return {
            key: hashes[key]
            for key in sorted(hashes)
        }

    def lookup_by_hash(self, hashes):
        hashes = tuple(hashes)
        for redump_id, text in self.sha1_cache.items():
            response = self._parse_sha1_response(text)
            if hashes == tuple(response.values()):
                return redump_id


def find_dump_hashes(root):
    iterator = root.iterdir() if root.is_dir() else [root]

    paths = [
        path
        for path in iterator
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

    hashes = {path: sha1sum(path) for path in sorted(paths)}
    LOGGER.debug('sha1 hashes %s', hashes)
    return hashes


def sha1sum(path):
    hasher = hashlib.sha1()
    with open(path, 'rb') as handle:
        while data := handle.read(65536):
            hasher.update(data)
    return hasher.hexdigest()


async def extract(path, dest_dir):
    proc = await asyncio.create_subprocess_exec(
        'extract', '--quiet', '-p', str(dest_dir), '--', str(path))
    await proc.wait()
    if proc.returncode:
        raise RuntimeError(proc.returncode)


async def get_name(path, redump):
    arg_hashes = find_dump_hashes(path)
    expected = tuple(arg_hashes.values())

    hashes = {}
    for system, x in redump.dat_cache.items():
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
        LOGGER.warning('No redump match found')
        return None, path.name

    # fix for games like 'Fury^3'
    name = name.replace('^', '')

    if redump_id := redump.lookup_by_hash(expected):
        LOGGER.info('Found redump match %s "%s"', redump_id, name)
        return redump_id, name.replace('/', '')

    async for redump_id in redump.scrape_redump(name, system):
        sha1 = await redump.download_sha1(redump_id)
        if expected == tuple(sha1.values()):
            LOGGER.info('Found redump match %s "%s"', redump_id, name)
            return redump_id, name.replace('/', '')

    raise RuntimeError('wtf')


REDUMP_ID_PATH_PATTERN = re.compile(r'^redump_(?P<redump_id>\d+) ')


async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--no-rename', action='store_true')
    parser.add_argument('--update', action='store_true')
    parser.add_argument('--verbose', action='store_true')
    parser.add_argument('path', type=pathlib.Path, nargs='+')
    args = parser.parse_args()

    setup_logging(NAME,
                  level=logging.DEBUG if args.verbose else logging.INFO)

    redump = Redump()
    if args.update or not redump.dat_cache:
        await redump.download_datfiles()

    for path in args.path:
        log_context('path', path)
        LOGGER.info('PROCESSING')
        if path.is_file():
            if path.suffix == '.iso':
                suffix = '.iso'
                redump_id, name = await get_name(path, redump)
            elif path.suffixes[-2:] == ['.tar', '.zst']:
                suffix = '.tar.zst'
                parent = pathlib.Path('~').expanduser()
                with tempfile.TemporaryDirectory(dir=parent) as tmp:
                    dest = pathlib.Path(tmp) / path.name
                    await extract(path, dest)
                    redump_id, name = await get_name(dest, redump)
            else:
                raise RuntimeError()
        else:
            suffix = ''
            redump_id, name = await get_name(path, redump)

        if redump_id:
            target = path.with_name(f'redump_{redump_id} {name}{suffix}')

            if path == target:
                LOGGER.info('✅ VALIDATED')
                continue

            current_redump_id = REDUMP_ID_PATH_PATTERN.match(path.name)\
                .groupdict().get('redump_id')

            if current_redump_id != redump_id:
                LOGGER.error('🚫 ERROR: CURRENT PATH REDUMP ID IS INCORRECT %s', target)
            elif not args.no_rename:
                LOGGER.info('ℹ️  RENAMING %s', target)
                if target.exists():
                    raise RuntimeError(f'target exists {target}')
                path.rename(target)
            else:
                LOGGER.info('ℹ️  REDUMP ID CORRECT, BUT NAME DIFFERS %s', target)
        else:
            LOGGER.error('⚠  ERROR: unknown')
            if not path.name.startswith('unknown '):
                target = path.with_name(f'unknown {path.name}')
                while target.exists():
                    target = target.with_name(f'{target.name}_')
                if not args.no_rename:
                    path.rename(target)


if __name__ == '__main__':
    asyncio.run(main())
