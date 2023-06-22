#!/usr/bin/env python3

import os
import json
import sys

# AI tools URL list
ai_tools = [
    {
        'title': 'ChatGPT',
        'subtitle': 'Chat GPT OpenAI',
        'arg': 'https://chat.openai.com/',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'chatgpt.png',
            'type': 'default'
        }
    },
    {
        'title': 'Bard AI',
        'subtitle': 'Bard Google AI',
        'arg': 'https://bard.google.com/',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'bard.png',
            'type': 'default'
        }
    },
    {
        'title': 'Bing AI',
        'subtitle': 'Open Bing AI in Edge',
        'arg': 'https://www.bing.com/search?q=Bing+AI&showconv=1&FORM=hpcodx',
        'type': 'file',
        'browser': 'Microsoft Edge',
        'icon': {
            'path': 'bing.webp',
            'type': 'default'
        }
    },
    {
        'title': 'Blackbox AI',
        'subtitle': 'Blackbox AI',
        'arg': 'https://www.useblackbox.io/chat',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'blackbox.png',
            'type': 'default'
        }
    }

]

def filter_ai_tools(ai_tools, query):
    # Filter the list of AI tools using the query
    # Filter base on title and subtitle and arg
    filtered_ai_tools = []
    for ai_tool in ai_tools:
        if query.lower() in ai_tool['title'].lower() or query.lower() in ai_tool['subtitle'].lower() or query.lower() in ai_tool['arg'].lower():
            filtered_ai_tools.append(ai_tool)
    return filtered_ai_tools


def main():
    query = sys.argv[1].strip().lower()
    filtered_ai_tools = filter_ai_tools(ai_tools, query)
    print(json.dumps({'items': filtered_ai_tools}))
    
if __name__ == '__main__':
    main()
