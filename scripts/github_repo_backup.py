#!/usr/bin/env python3
import argparse
import itertools
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
    url = f'https://api.github.com/users/{user}/repos'

    repos = []

    while url:
        response = requests.get(url, auth=requests.auth.HTTPBasicAuth(USERNAME,
                                                                      TOKEN))
        response.raise_for_status()
        for item in response.json():
            repos.append(GitHubRepo(item))

        link = response.headers.get('Link')
        url = None
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

    with consumers.Pool(download_repos) as pool:
        for user in args.users:
            for github_repo in get_repo_names(user):
                local_path = pathlib.Path(args.directory,
                                          github_repo.username,
                                          github_repo.reponame)
                pool.put(local_path, github_repo.url)

    for error in itertools.chain(*pool.results):
        logging.error(error)

    logging.info('Done')


if __name__ == '__main__':
    main()
