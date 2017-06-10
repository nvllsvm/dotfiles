#!/usr/bin/env python
import argparse


def read_file(path):
    hashes = {}
    with open(path) as f:
        for line in f:
            file_hash, file_path = line.strip().split(maxsplit=1)
            if file_path in hashes:
                raise Exception('Duplicate hash')

            hashes[file_path] = file_hash

    return hashes


def main():
    parser = argparse.ArgumentParser(
            description='find . -type f -exec sha256sum {} \;')
    parser.add_argument('file_a')
    parser.add_argument('file_b')
    args = parser.parse_args()

    hashes_a = read_file(args.file_a)
    hashes_b = read_file(args.file_b)

    if hashes_a.keys() != hashes_b.keys():
        raise Exception('Keys mismatch')

    for path, hash_a in hashes_a.items():
        if hash_a != hashes_b[path]:
            print('Mismatch: {}'.format(path))


if __name__ == '__main__':
    main()
