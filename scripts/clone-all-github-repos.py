#!/usr/bin/env python3
import argparse
import logging
import pathlib
import shutil
import subprocess

import consumers
import requests


def get_repo_names(user):
    url = f'https://api.github.com/users/{user}/repos'

    response = requests.get(url)
    response.raise_for_status()

    return sorted({repo['name'] for repo in response.json()})


class RepoDownloader(consumers.Consumer):
    def process(self, repo, user, output_path):
        self.logger.info('Downloading %s', repo)
        repo_path = pathlib.Path(output_path, repo)
        shutil.rmtree(repo_path, ignore_errors=True)
        repo_path.mkdir()
        repo_url = f'https://github.com/{user}/{repo}.git'
        subprocess.run(['git', '-C', output_path, 'clone', repo_url],
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE, check=True)
        self.logger.info('Complete %s', repo)


def main():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)s %(processName)s %(message)s')

    parser = argparse.ArgumentParser(
            description='Clone all the repos belonging to a user.')
    parser.add_argument('user')
    parser.add_argument('path')
    args = parser.parse_args()

    path = pathlib.Path(args.path, args.user)
    path.mkdir(parents=True, exist_ok=True)

    with consumers.Queue(RepoDownloader) as q:
        for repo in get_repo_names(args.user):
            q.put(repo, args.user, path)


if __name__ == '__main__':
    main()
