#!/usr/bin/env bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <workspace_name> <target_directory>"
    echo "Example: $0 ggj ~/Projects/ggj"
    exit 1
fi

WORKSPACE_NAME=$1
TARGET_DIR=$2
DOTFILES_AI_DIR="/Users/huynh/Personal/.dotfiles/huynh-ai"
WORKSPACE_CONFIG_DIR="$DOTFILES_AI_DIR/workspaces/$WORKSPACE_NAME"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Check if workspace config exists in dotfiles
if [ ! -d "$WORKSPACE_CONFIG_DIR" ]; then
    echo "Warning: No specific workspace config found at $WORKSPACE_CONFIG_DIR. Falling back to global templates."
    # Copy global templates if no workspace specific config is found
    cp "$DOTFILES_AI_DIR/cursor/.cursorrules" "$TARGET_DIR/.cursorrules"
    cp "$DOTFILES_AI_DIR/claude/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    echo "✅ Global templates copied to $TARGET_DIR"
    exit 0
fi

echo "Installing AI configs for workspace '$WORKSPACE_NAME' to '$TARGET_DIR'..."

# 1. Setup Antigravity (.agents folder)
if [ -d "$WORKSPACE_CONFIG_DIR/antigravity" ]; then
    echo "-> Setting up Antigravity (.agents)..."
    if [ -d "$TARGET_DIR/.agents" ] && [ ! -L "$TARGET_DIR/.agents" ]; then
        echo "Backing up existing .agents folder in target..."
        mv "$TARGET_DIR/.agents" "$TARGET_DIR/.agents_backup"
    fi
    # Use symlink or copy. For dotfiles, symlink is often better to keep them synced.
    rm -rf "$TARGET_DIR/.agents"
    ln -s "$WORKSPACE_CONFIG_DIR/antigravity" "$TARGET_DIR/.agents"
    echo "✅ Symlinked .agents"
fi

# 2. Setup Cursor
if [ -f "$WORKSPACE_CONFIG_DIR/.cursorrules" ]; then
    echo "-> Setting up Cursor..."
    ln -sf "$WORKSPACE_CONFIG_DIR/.cursorrules" "$TARGET_DIR/.cursorrules"
    echo "✅ Symlinked .cursorrules"
fi

# 3. Setup Claude
if [ -f "$WORKSPACE_CONFIG_DIR/CLAUDE.md" ]; then
    echo "-> Setting up Claude..."
    ln -sf "$WORKSPACE_CONFIG_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    echo "✅ Symlinked CLAUDE.md"
fi

echo "Installation complete."
