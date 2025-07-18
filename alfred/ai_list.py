#!/usr/bin/env python3

import os
import json
import sys

# AI tools URL list
ai_tools = [
    {
        'title': 'Vercel AI 0',
        'subtitle': 'Vercel AI 0',
        'arg': 'https://v0.dev/chat',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'v0.png',
            'type': 'default'
        }
    },
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
        'title': 'Gemini',
        'subtitle': 'Gemini Google AI',
        'arg': 'https://gemini.google.com/app',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'gemini.webp',
            'type': 'default'
        }
    },
    {
        'title': 'Microsoft Copilot',
        'subtitle': 'Open Microsoft Copilot in Edge',
        'arg': 'https://copilot.microsoft.com/chats',
        'type': 'file',
        'browser': 'Microsoft Edge',
        'icon': {
            'path': 'Microsoft-Copilot-Logo.png',
            'type': 'default'
        }
    },
    {
        'title': 'Blackbox AI',
        'subtitle': 'Blackbox AI',
        'arg': 'https://www.blackbox.ai/',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'blackbox.png',
            'type': 'default'
        }
    },
    {
        'title': 'Deepseek',
        'subtitle': 'Deepseek AI',
        'arg': 'https://chat.deepseek.com/',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'deepseek.png',
            'type': 'default'
        }
    },
    {
        'title': 'Claude',
        'subtitle': 'Claude AI',
        'arg': 'https://claude.ai/',
        'type': 'file',
        'browser': 'default',
        'icon': {
            'path': 'claude-ai-icon.webp',
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
