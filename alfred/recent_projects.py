#!/usr/bin/env python3

import json
import os
import sys
from xml.etree import ElementTree

BREAK_CHARACTERS = ["_", "-"]


class AlfredItem:
    def __init__(self, title, subtitle, arg, type="file"):
        self.title = title
        self.subtitle = subtitle
        self.arg = arg
        self.type = type


class AlfredOutput:
    def __init__(self, items):
        self.items = items

class CustomEncoder(json.JSONEncoder):
    def default(self, obj):
        return obj.__dict__


def create_json(projects):
    return CustomEncoder().encode(
        AlfredOutput([AlfredItem(project.name, project.path, project.path) for project in projects]))


class Project:
    def __init__(self, path):
        self.path = os.path.expanduser(path)
        name_file = self.path + "/.idea/.name"

        if os.path.isfile(name_file):
            self.name = open(name_file).read()
        else:
            self.name = path.split('/')[-1]
        self.abbreviation = self.abbreviate()

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.name == other.name and self.path == other.path and self.abbreviation == other.abbreviation
        return False

    def abbreviate(self):
        previous_was_break = False
        abbreviation = self.name[0]
        for char in self.name[1: len(self.name)]:
            if char in BREAK_CHARACTERS:
                previous_was_break = True
            else:
                if previous_was_break:
                    abbreviation += char
                    previous_was_break = False
        return abbreviation

    def matches_query(self, query):
        return query in self.path.lower() or query in self.abbreviation.lower() or query in self.name.lower()

    def sort_on_match_type(self, query):
        if query == self.abbreviation:
            return 0
        elif query in self.name:
            return 1
        return 2


def find_app_data(app):
    try:
        with open('products.json', 'r') as outfile:
            data = json.load(outfile)
            return data[app]
    except IOError:
        print("Can't open products file")
    except KeyError:
        print("App '{}' is not found in the products.json".format(app))
    exit(1)


def find_recentprojects_file(application):
    preferences_path = os.path.expanduser(preferences_path_or_default(application))
    most_recent_preferences = max(find_preferences_folders(preferences_path, application))
    return "{}{}/options/{}.xml".format(preferences_path, most_recent_preferences, "recentProjects")


def preferences_path_or_default(application):
    return application["preferences-path"] if "preferences-path" in application \
        else "~/Library/Application Support/JetBrains/"


def find_preferences_folders(preferences_path, application):
    return [folder_name for folder_name in next(os.walk(preferences_path))[1] if
            application["folder-name"] in folder_name and not should_ignore_folder(folder_name)]


def should_ignore_folder(folder_name):
    return "backup" in folder_name


def read_projects_from_file(most_recent_projects_file):
    tree = ElementTree.parse(most_recent_projects_file)
    projects = [t.attrib['key'].replace('$USER_HOME$', "~") for t
                in tree.findall(".//component[@name='RecentProjectsManager']/option[@name='additionalInfo']/map/entry")]
    return reversed(projects)


def filter_and_sort_projects(query, projects):
    if len(query) < 1:
        return projects
    results = [p for p in projects if p.matches_query(query)]
    results.sort(key=lambda p: p.sort_on_match_type(query))
    return results


def main():  # pragma: nocover
    try:
        app_data = find_app_data(sys.argv[1])
        recent_projects_file = find_recentprojects_file(app_data)

        query = sys.argv[2].strip().lower()

        projects = list(map(Project, read_projects_from_file(recent_projects_file)))
        projects = filter_and_sort_projects(query, projects)

        print(create_json(projects))
    except IndexError:
        print("No app specified, exiting")
        exit(1)
    except ValueError:
        print("Can't find any preferences for", sys.argv[1])
        exit(1)


if __name__ == "__main__":  # pragma: nocover
    main()
