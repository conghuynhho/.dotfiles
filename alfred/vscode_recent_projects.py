#!/usr/bin/env python3

import os
import subprocess
import json
import sys

def find_workspaces():
    workspace_storage = os.path.expanduser('~/Library/Application Support/Code/User/workspaceStorage')
    workspace_storage2 = os.path.expanduser('~/Library/Application Support/Code - Insiders/User/workspaceStorage')
    workspace_storage3 = os.path.expanduser('~/Library/Application Support/Cursor/User/workspaceStorage')

    workspaces = []

    # check if workspaceStorage exists
    if os.path.exists(workspace_storage):
        for root, dirs, files in os.walk(workspace_storage):
            for file in files:
                if file == 'workspace.json':
                    workspace_file = os.path.join(root, file)
                    with open(workspace_file, 'r') as f:
                        workspace_data = json.load(f)
                        workspace_folder = workspace_data.get('folder')
                        if workspace_folder:
                            workspace_folder = workspace_folder.replace('file://', '')
                            workspaces.append(workspace_folder)
    if os.path.exists(workspace_storage2):
        for root, dirs, files in os.walk(workspace_storage2):
            for file in files:
                if file == 'workspace.json':
                    workspace_file = os.path.join(root, file)
                    with open(workspace_file, 'r') as f:
                        workspace_data = json.load(f)
                        workspace_folder = workspace_data.get('folder')
                        if workspace_folder:
                            workspace_folder = workspace_folder.replace('file://', '')
                            workspaces.append(workspace_folder)
    if os.path.exists(workspace_storage3):
        for root, dirs, files in os.walk(workspace_storage3):
            for file in files:
                if file == 'workspace.json':
                    workspace_file = os.path.join(root, file)
                    with open(workspace_file, 'r') as f:
                        workspace_data = json.load(f)
                        workspace_folder = workspace_data.get('folder')
                        if workspace_folder:
                            workspace_folder = workspace_folder.replace('file://', '')
                            workspaces.append(workspace_folder)
    return workspaces

def filter_workspaces(workspaces, query):
    filtered_workspaces = []
    for workspace in workspaces:
        if query.lower() in workspace.lower():
            filtered_workspaces.append(workspace)
    return filtered_workspaces

def create_json(workspaces):
    items = []
    for workspace in workspaces:
        title = os.path.basename(workspace)
        subtitle = f'Open "{workspace}"'
        items.append({
            'title': title,
            'subtitle': subtitle,
            'arg': workspace,
            'type': 'file'
        })
    return json.dumps({'items': items})

def main():
    workspaces = find_workspaces()
    # remove duplicates
    workspaces = list(set(workspaces))
    query = sys.argv[1].strip().lower()
    filtered_workspaces = filter_workspaces(workspaces, query)
    json_output = create_json(filtered_workspaces)
    subprocess.run(['echo', json_output], check=True)

if __name__ == '__main__':
    main()
