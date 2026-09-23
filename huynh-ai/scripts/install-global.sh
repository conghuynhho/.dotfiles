#!/usr/bin/env bash

set -e

# Define directories
DOTFILES_AI_DIR="/Users/huynh/Personal/.dotfiles/huynh-ai"
GEMINI_CONFIG_DIR="$HOME/.gemini/config"

echo "Installing global AI configs..."

# 1. Antigravity Global Setup
echo "-> Setting up Antigravity..."
if [ -L "$GEMINI_CONFIG_DIR" ]; then
    echo "Symlink already exists for $GEMINI_CONFIG_DIR. Replacing..."
    rm "$GEMINI_CONFIG_DIR"
elif [ -d "$GEMINI_CONFIG_DIR" ]; then
    echo "Found existing directory at $GEMINI_CONFIG_DIR. Backing up..."
    mv "$GEMINI_CONFIG_DIR" "${GEMINI_CONFIG_DIR}_backup_$(date +%Y%m%d%H%M%S)"
fi

ln -s "$DOTFILES_AI_DIR/antigravity" "$GEMINI_CONFIG_DIR"
echo "✅ Antigravity setup complete."

echo "All global installations completed."
