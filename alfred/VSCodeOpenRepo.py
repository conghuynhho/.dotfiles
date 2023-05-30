#!/usr/bin/env python3

import os
import json
import sys

WORKDIR = os.environ.get('WORKDIR', '~/GGJ')
PERSONAL_DIR = os.environ.get('PERSONAL_DIR', '~/Personal')

def find_repos():
    # print('finding repos')
    # print('WORKDIR: ' + WORKDIR)
    # print('PERSONAL_DIR: ' + PERSONAL_DIR)
    repos = []
    for root, dirs, files in os.walk(os.path.expanduser(WORKDIR)):
        if '.git' in dirs:
            repo_path = os.path.join(root, '.git')
            repos.append(repo_path)
            # stop from going into subdirectories
            dirs[:] = []
        # ignore node_modules
        if 'node_modules' in dirs:
            dirs.remove('node_modules')

    for root, dirs, files in os.walk(os.path.expanduser(PERSONAL_DIR)):
        if '.git' in dirs:
            repo_path = os.path.join(root, '.git')
            repos.append(repo_path)
            # stop from going into subdirectories
            dirs[:] = []
        # ignore node_modules
        if 'node_modules' in dirs:
            dirs.remove('node_modules')
    # print('end finding repos')
    return repos

def filter_repo(repos, query):
    filtered_repos = []
    for repo in repos:
        if query.lower() in repo.lower():
            filtered_repos.append(repo)
    return filtered_repos

def create_json(repos):
    items = []
    for repo in repos:
        path = os.path.dirname(repo)
        title = os.path.basename(path)
        subtitle = path
        items.append({
            'title': title,
            'subtitle': subtitle,
            'arg': path,
            'type': 'file'
        })
    return json.dumps({'items': items})

def main():
    query = sys.argv[1].strip().lower()
    # print(query)
    repos = find_repos()
    filtered_repos = filter_repo(repos, query)
    print(create_json(filtered_repos))
    
if __name__ == '__main__':
    main()
