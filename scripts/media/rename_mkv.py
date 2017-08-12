#!/usr/bin/env python
import argparse
import logging
import os
import re
import shutil

logging.basicConfig(level=logging.INFO)


titles_name = 'source'


def get_titles(path):
    titles = {}

    number = 1
    with open(path) as f:
        for line in f:
            titles[number] = line.strip().replace('/', '-')
            number += 1

    return titles


class Renamable(object):
    def __init__(self, root, name, pattern):
        self.root = root
        self.name = name
        self.pattern = pattern

    @property
    def is_renamable(self):
        if self.name.endswith('.mkv'):
            return True
        else:
            return False

    def rename(self, titles, move_file=False):
        number = self.match_number()
        new_title = '{:02d} - {}.mkv'.format(number, titles[number])
        logging.info('Renaming {}  ->  {}'.format(self.name, new_title))
        old_path = os.path.join(self.root, self.name)
        new_path = os.path.join(self.root, new_title)
        if os.path.isfile(new_path):
            logging.error('File already exists: {}'.format(new_path))
            raise Exception()
        if move_file:
            shutil.move(old_path, new_path)

    def match_number(self):
        matches = self.pattern.match(self.name)
        return int(matches.group(1))


def process(path, regex):
    pattern = re.compile(regex)
    for root, dirs, files in os.walk(path):
        if titles_name in files:
            logging.info('Processing {}'.format(root))
            titles = get_titles(os.path.join(root, titles_name))
            for f in sorted(files):
                renamable = Renamable(root, f, pattern)
                if renamable.is_renamable:
                    renamable.rename(titles)
            should_rename = input('Should rename? (y/n)  ')
            if should_rename.lower() == 'y':
                for f in sorted(files):
                    renamable = Renamable(root, f, pattern)
                    if renamable.is_renamable:
                        renamable.rename(titles, True)


def main():
    parser = argparse.ArgumentParser(
            description='./rename_mkv.py -r \'.*S\d*E(\d*).*.mkv\' test')
    parser.add_argument('regex')
    parser.add_argument('directory')
    args = parser.parse_args()

    pattern = '^{}$'.format(args.regex)
    process(args.directory, pattern)


if __name__ == '__main__':
    main()
