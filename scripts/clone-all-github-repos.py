#!/usr/bin/env python3
import argparse
import os
import subprocess

import requests


def get_repo_names(user):
    url = f'https://api.github.com/users/{user}/repos'

    response = requests.get(url)

    repos = []

    for repo in response.json():
        repos.append(repo['name'])

    return sorted(repos)


def register_with_myrepos(user, root, repos, use_ssh):
    for repo in repos:
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

    repos = get_repo_names(args.user)
    register_with_myrepos(args.user, args.path, repos, args.use_ssh)


if __name__ == '__main__':
    main()
