#!/usr/bin/env python3
import argparse
import logging
import os
import pathlib
import subprocess

import consumers
import requests
import requests.auth
import requests.utils

USERNAME = os.environ['GITHUB_USERNAME']
TOKEN = os.environ['GITHUB_TOKEN']


def get_repo_names(user):
    url = f'https://api.github.com/users/{user}/repos'

    repos = []

    while url:
        response = requests.get(url, auth=requests.auth.HTTPBasicAuth(USERNAME,
                                                                      TOKEN))
        response.raise_for_status()
        repos.extend(repo['name'] for repo in response.json())

        link = response.headers.get('Link')
        url = None
        for v in requests.utils.parse_header_links(link):
            if v['rel'] == 'next':
                url = v['url']

    return sorted(repos)


class RepoDownloader(consumers.Consumer):
    def initialize(self, errors):
        self.errors = errors

    def process(self, repo, user, user_path):
        self.logger.info('Processing %s', repo)
        repo_path = pathlib.Path(user_path, repo)
        if repo_path.exists():
            self.logger.info('Pulling %s', repo)
            self.git_command(repo_path, 'pull')
        else:
            self.logger.info('Cloning %s', repo)
            repo_path.mkdir()
            self.git_command(user_path, 'clone',
                             f'https://github.com/{user}/{repo}')

        self.logger.info('Complete %s', repo)

    def git_command(self, path, *args):
        try:
            subprocess.run(['git', '-C', path, *args],
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, check=True)
        except subprocess.CalledProcessError as e:
            self.logger.error('Error running command %s %s', path, args)
            self.logger.exception(e)
            self.errors.put(path)


class ErrorConsumer(consumers.Consumer):
    def initialize(self):
        self.errors = []

    def process(self, error):
        self.errors.append(error)

    def shutdown(self):
        for error in self.errors:
            self.logger.error(error)


def main():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)s %(processName)s %(message)s')

    parser = argparse.ArgumentParser(
            description='Clone all the repos belonging to a user.')
    parser.add_argument('user')
    parser.add_argument('path')
    args = parser.parse_args()

    user_path = pathlib.Path(args.path, args.user)
    user_path.mkdir(parents=True, exist_ok=True)

    errors = consumers.Queue(ErrorConsumer, quantity=1)
    downloader = consumers.Queue(RepoDownloader(errors))

    existing_dirs = set([d.name for d in user_path.iterdir() if d.is_dir()])
    repos = set()
    with errors, downloader:
        for repo in get_repo_names(args.user):
            repos.add(repo)
            downloader.put(repo, args.user, user_path)

    for d in existing_dirs.difference(repos):
        logging.warning('Orphan %s', d)


if __name__ == '__main__':
    main()
