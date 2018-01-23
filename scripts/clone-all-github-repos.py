#!/usr/bin/env python3
import argparse
import logging
import pathlib
import subprocess

import consumers
import requests


def get_repo_names(user):
    url = f'https://api.github.com/users/{user}/repos'

    response = requests.get(url)
    response.raise_for_status()

    return sorted({repo['name'] for repo in response.json()})


class RepoDownloader(consumers.Consumer):
    def process(self, repo, user, user_path):
        self.logger.info('Downloading %s', repo)
        repo_path = pathlib.Path(user_path, repo)

        if repo_path.exists():
            self.logger.info('Pulling %s', repo)
            self.git_command(repo_path, 'pull')
        else:
            self.logger.info('Cloning %s', repo)
            repo_path.mkdir()
            self.git_command(user_path, 'clone',
                             'https://github.com/{user}/{repo}')

        self.logger.info('Complete %s', repo)

    def git_command(self, path, *args):
        try:
            subprocess.run(['git', '-C', path, *args],
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, check=True)
        except subprocess.CalledProcessError as e:
            self.logger.error('Error running command %s %s', path, args)
            self.logger.exception(e)


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

    existing_dirs = set([d.name for d in path.iterdir() if d.is_dir()])
    repos = set()
    with consumers.Queue(RepoDownloader) as q:
        for repo in get_repo_names(args.user):
            repos.add(repo)
            q.put(repo, args.user, path)

    for d in existing_dirs.difference(repos):
        logging.warning('Orphan %s', d)


if __name__ == '__main__':
    main()
