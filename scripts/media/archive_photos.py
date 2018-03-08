#!/usr/bin/env python3
import argparse
import os
import shutil


def parse_filename(filename, index, separated=False):
    if separated:
        year = filename[index:index+4]
        month = filename[index+5:index+7]
        day = filename[index+8:index+9]
    else:
        year = filename[index:index+4]
        month = filename[index+4:index+6]
        day = filename[index+6:index+8]

    return year, month, day


class MultimediaFile(object):
    def __init__(self, filename, source_directory, target_directory,
                 year, month, day, move_file=None):
        self.filename = filename
        self.source_directory = source_directory
        self.target_directory = target_directory

        self.year = year
        self.month = month
        self.day = day

        try:
            self.year = str(int(year))
            self.month = str(int(month)).zfill(2)
            self.day = str(int(day)).zfill(2)
        except ValueError as e:
            raise e

        self.move_file = move_file

    def archive(self):
        archive_path = os.path.join(self.target_directory,
                                    self.year,
                                    self.month,
                                    self.day)

        if self.move_file:
            if not os.path.isdir(archive_path):
                os.makedirs(archive_path)

        old_path = os.path.join(self.source_directory, self.filename)
        new_path = os.path.join(archive_path, self.filename)

        print(new_path)

        if not os.path.isfile(new_path):
            if self.move_file:
                shutil.move(old_path, new_path)
        else:
            print(f'Error: {new_path} already exists')


def process_dir(source_directory, target_directory,
                index, separated, move_file):
    source_directory = os.path.abspath(source_directory)

    for root, dirs, files in os.walk(source_directory):
        for f in files:
            year, month, day = parse_filename(f, index, separated)

            m = MultimediaFile(f, root, target_directory,
                               year, month, day, move_file)
            m.archive()


def get_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('source_directory')
    parser.add_argument('target_directory')
    parser.add_argument('-m', '--move-file', action='store_true',
                        help='not a dry run')
    parser.add_argument('index', type=int,
                        help='starting index of date')
    parser.add_argument('-s', '--separated', action='store_true',
                        help='date parts are separated (ex. 2016-01-01)')
    args = parser.parse_args()

    return args


def main():
    args = get_arguments()

    process_dir(args.source_directory, args.target_directory,
                args.index, args.separated, args.move_file)


if __name__ == '__main__':
    main()
