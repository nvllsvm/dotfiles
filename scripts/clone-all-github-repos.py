#!/usr/bin/env python3
import argparse
import os
import subprocess

import requests


def get_repo_names(user):
    url = f'https://api.github.com/users/{user}/repos'

    response = requests.get(url)
    response.raise_for_status()

    return sorted({repo['name'] for repo in response.json()})


def register_with_myrepos(user, root, repo, use_ssh):
    repo_path = os.path.join(root, repo)
    if not os.path.isdir(repo_path):
        if use_ssh:
            repo_url = f'git@github.com:{user}/{repo}.git'
        else:
            repo_url = f'https://github.com/{user}/{repo}.git'
        print(repo_url)
        subprocess.run(['git', '-C', root, 'clone', repo_url])


def main():
    parser = argparse.ArgumentParser(
            description='Clone all the repos belonging to a user.')
    parser.add_argument('-s', '--ssh', action='store_true', dest='use_ssh')
    parser.add_argument('user')
    parser.add_argument('path')
    args = parser.parse_args()

    os.makedirs(os.path.join(args.path, args.user))

    for repo in get_repo_names(args.user):
        register_with_myrepos(args.user, args.path, repo, args.use_ssh)


if __name__ == '__main__':
    main()
