#!/usr/bin/python3
# -*- coding: utf-8 -*-
import codecs
import json
import os
import sys
from plistlib import load
from typing import Union
import webbrowser

# Bookmark file path relative to HOME

BOOKMARS_MAP = {
    "chrome": 'Library/Application Support/Google/Chrome/Default/Bookmarks',
}

# Show favicon in results or default wf icon
# show_favicon = Tools.getEnvBool("show_favicon")
show_favicon = False

BOOKMARKS = list()
# Get Browser Histories to load based on user configuration
for k in BOOKMARS_MAP.keys():
    BOOKMARKS.append(BOOKMARS_MAP.get(k))


def removeDuplicates(li: list) -> list:
    """
    Removes Duplicates from bookmark file

    Args:
        li(list): list of bookmark entries

    Returns:
        list: filtered bookmark entries
    """
    visited = set()
    output = []
    for a, b in li:
        if a not in visited:
            visited.add(a)
            output.append((a, b))
    return output


def paths_to_bookmarks() -> list:
    """
    Get all valid bookmarks pahts from BOOKMARKS

    Returns:
        list: valid bookmark paths
    """

    user_dir = os.path.expanduser('~')
    bms = [os.path.join(user_dir, b) for b in BOOKMARKS]
    valid_bms = list()
    for b in bms:
        if os.path.isfile(b):
            valid_bms.append(b)

    return valid_bms


def get_json_from_file(file: str) -> json:
    """
    Get Bookmark JSON

    Args:
        file(str): File path to valid bookmark file

    Returns:
        str: JSON of Bookmarks
    """
    return json.load(codecs.open(file, 'r', 'utf-8-sig'))['roots']


def get_safari_bookmarks_json(file: str) -> list:
    with open(file, "rb") as fp:
        plist = load(fp)
    children = plist.get("Children")
    ret_list = list()
    for item in children:  # TODO: implement
        name = item.get("URIDictionary").get("title")
        url = item.get("URLString")
        ret_list.append((name, url))
    return ret_list


path_need_to_open = 'Daily'

def get_all_url_in_folder(the_json: str, folder_name: str) -> list:
    """
    Extract all URLs and title from Bookmark files in folder

    Args:
        the_json (str): All Bookmarks read from file
        folder_name (str): Name of the folder to extract URLs from

    Returns:
        list(tuple): List of tuples with Bookmark URL and title
    """

    def extract_data(data: dict, folder_name: str, append: bool = False):
        if isinstance(data, dict) and data.get('type') == 'url' and append:
            urls.append({'name': data.get('name'), 'url': data.get('url')})
        if isinstance(data, dict) and data.get('type') == 'folder':
            the_children = data.get('children')
            isFound = append or data.get('name') == folder_name
            get_container(the_children, folder_name, isFound)

    def get_container(o: Union[list, dict], folder_name: str, append: bool = False):
        if isinstance(o, list):
            for i in o:
                extract_data(i, folder_name, append)
        if isinstance(o, dict):
            for k, i in o.items():
                extract_data(i, folder_name, append)

    urls = list()
    get_container(the_json, folder_name)
    s_list_dict = sorted(urls, key=lambda k: k['name'], reverse=False)
    ret_list = [(l.get('name'), l.get('url')) for l in s_list_dict]
    return ret_list



def main():
    bms = paths_to_bookmarks()

    if len(bms) > 0:
        # Generate list of bookmars matches the search
        for bookmarks_file in bms:
            if "Safari" in bookmarks_file:
                #bookmarks = get_safari_bookmarks_json(bookmarks_file)
                pass
            else:
                bm_json = get_json_from_file(bookmarks_file)
                bookmarks2 = get_all_url_in_folder(bm_json, path_need_to_open)

                # open in browser
                for name, url in bookmarks2:
                  webbrowser.open(url)


if __name__ == "__main__":
    main()