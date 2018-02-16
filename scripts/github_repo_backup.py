#!/usr/bin/env python3
import argparse
import collections
import itertools
import logging
import os
import pathlib
import subprocess
import urllib3

import consumers
import pid.decorator
import requests
import requests.auth
import requests.utils

USERNAME = os.environ['GITHUB_USERNAME']
TOKEN = os.environ['GITHUB_TOKEN']
GITHUB_URL = os.environ.get('GITHUB_URL',
                            'https://api.github.com/users/{}/repos')
SSL_VERIFY = False if os.environ.get('GITHUB_SSL_VERIFY') == 'N' else True
if not SSL_VERIFY:
    urllib3.disable_warnings()

PID_DIR = os.environ.get('PID_DIR')


class GitHubRepo:
    def __init__(self, item):
        self.username = item['owner']['login']
        self.reponame = item['name']
        self.url = item['clone_url']

        self.name = f'{self.username}/{self.reponame}'

    def __str__(self):
        return self.name


class RepoError(Exception):
    pass


class LocalRepo:
    def __init__(self, path, url):
        self.path = path
        self.url = url
        self.logger = logging.getLogger()

    def backup_from_origin(self):
        if self.path.exists():
            self.pull()
            self.prune()
        else:
            self.clone()

    def pull(self):
        self.git_command(self.path, 'pull')

    def prune(self):
        self.git_command(self.path, 'remote', 'prune', 'origin')

    def clone(self):
        parent_path = self.path.parent
        parent_path.mkdir(parents=True, exist_ok=True)

        self.git_command(parent_path, 'clone', self.url)

    def git_command(self, path, *args):
        try:
            subprocess.run(['git', '-C', path, *args],
                           stdout=subprocess.PIPE,
                           stderr=subprocess.PIPE, check=True)
        except subprocess.CalledProcessError as e:
            self.logger.exception(e)
            raise RepoError


def get_repo_names(user):
    repos = []

    url = GITHUB_URL.format(user)
    while url:
        response = requests.get(
            url,
            auth=requests.auth.HTTPBasicAuth(USERNAME, TOKEN),
            verify=SSL_VERIFY)

        response.raise_for_status()
        for item in response.json():
            repos.append(GitHubRepo(item))

        url = None
        link = response.headers.get('Link')
        if link is not None:
            for v in requests.utils.parse_header_links(link):
                if v['rel'] == 'next':
                    url = v['url']

    return repos


def download_repos(repos):
    errors = []
    logger = logging.getLogger()

    for local_path, url in repos:
        repo = LocalRepo(local_path, url)
        repo.logger = logger
        logger.info('Backing up %s', repo.path)
        try:
            repo.backup_from_origin()
        except RepoError as e:
            logger.exception(e)
            errors.append(repo.path)

    return errors


@pid.decorator.pidfile(piddir=PID_DIR)
def main():
    logging.basicConfig(
        level=logging.INFO,
        format='%(levelname)s %(processName)s %(message)s')

    logging.info('Begin')

    parser = argparse.ArgumentParser(
            description='Clone all the repos belonging to a user.')
    parser.add_argument('-d', '--directory')
    parser.add_argument('users', nargs='+')
    args = parser.parse_args()

    repos = collections.defaultdict(set)
    with consumers.Pool(download_repos) as pool:
        for user in args.users:
            for github_repo in get_repo_names(user):
                user_path = pathlib.Path(args.directory, github_repo.username)
                repos[user_path].add(github_repo.reponame)
                local_path = pathlib.Path(user_path, github_repo.reponame)
                pool.put(local_path, github_repo.url)

    for user_path, repos in repos.items():
        for orphan_repo in set(os.listdir(user_path)).difference(repos):
            logging.warning('Orphan found %s', pathlib.Path(user_path,
                                                            orphan_repo))

    for error in itertools.chain(*pool.results):
        logging.error(error)

    logging.info('Done')


if __name__ == '__main__':
    main()
