# huynh-ai Configs

This directory contains global and workspace-specific configurations for AI tools like Antigravity (Gemini), Cursor, and Claude.

## Structure

- `antigravity/`: Global Antigravity customizations (skills, rules, plugins, agents). Symlinked to `~/.gemini/config`.
- `cursor/`: Global template for `.cursorrules`.
- `claude/`: Global template for `CLAUDE.md`.
- `workspaces/`: Workspace-specific configs. Each subdirectory (e.g., `ggj`) can contain its own `antigravity` (for `.agents`), `.cursorrules`, etc.
- `scripts/`: Helper scripts to install these configurations.

## Installation

### Global Configurations

Run the following script to set up global symlinks (like Antigravity global configs):

```bash
./scripts/install-global.sh
```

### Workspace Configurations

Run the following script to install workspace-specific configs to a project directory:

```bash
# Example: Install 'ggj' configs to ~/Projects/ggj
./scripts/install-workspace.sh ggj ~/Projects/ggj
```
