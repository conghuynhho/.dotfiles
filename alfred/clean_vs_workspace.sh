#!/bin/bash
# go to ~/Library/Application Support/Code/User/workspaceStorage
#
# check all the subfolder inside workspaceStorage
# find until meet the workspace.json
# get the folder project name inside the workspace.json
#
# check if the folder project name is exist in the computer
# if not exist, delete the folder
#

# Define the path to the workspaceStorage directory
workspace_storage_dir="$HOME/Library/Application Support/Code/User/workspaceStorage"
workspace_storage_dir_2="$HOME/Library/Application Support/Cursor/User/workspaceStorage"
workspace_storage_dir_3="$HOME/Library/Application Support/Code - Insiders/User/workspaceStorage"

# Check if the workspaceStorage directory exists
if [ ! -d "$workspace_storage_dir" ]; then
  echo "Error: Workspace storage directory not found."
  exit 1
fi

# Loop through each subfolder in workspaceStorage
while IFS= read -r -d '' subfolder; do
  # Check if the subfolder contains a workspace.json file
  if [ -f "$subfolder/workspace.json" ]; then
    # Extract the project folder path from workspace.json
    project_folder_url=$(jq -r '.folder' "$subfolder/workspace.json")

    # Remove "file://" prefix and decode URL-encoded characters
    project_name=$(echo "$project_folder_url" | sed 's|^file://||' | sed 's/%20/ /g')

    # Check if the project folder exists
    if [ ! -d "$project_name" ]; then
      echo -e "$RED Project folder '$project_name' not found. Deleting... $NC"
      rm -rf "$subfolder"
      echo -e "$RED Deleted: $subfolder $NC"
    else
      echo "Project folder '$project_name' found."
    fi
  fi
done < <(find "$workspace_storage_dir" -mindepth 1 -maxdepth 1 -type d -print0)

while IFS= read -r -d '' subfolder; do
  # Check if the subfolder contains a workspace.json file
  if [ -f "$subfolder/workspace.json" ]; then
    # Extract the project folder path from workspace.json
    project_folder_url=$(jq -r '.folder' "$subfolder/workspace.json")

    # Remove "file://" prefix and decode URL-encoded characters
    project_name=$(echo "$project_folder_url" | sed 's|^file://||' | sed 's/%20/ /g')

    # Check if the project folder exists
    if [ ! -d "$project_name" ]; then
      echo -e "$RED Project folder '$project_name' not found. Deleting... $NC"
      rm -rf "$subfolder"
      echo -e "$RED Deleted: $subfolder $NC"
    else
      echo "Project folder '$project_name' found."
    fi
  fi
done < <(find "$workspace_storage_dir_2" -mindepth 1 -maxdepth 1 -type d -print0)

while IFS= read -r -d '' subfolder; do
  # Check if the subfolder contains a workspace.json file
  if [ -f "$subfolder/workspace.json" ]; then
    # Extract the project folder path from workspace.json
    project_folder_url=$(jq -r '.folder' "$subfolder/workspace.json")

    # Remove "file://" prefix and decode URL-encoded characters
    project_name=$(echo "$project_folder_url" | sed 's|^file://||' | sed 's/%20/ /g')

    # Check if the project folder exists
    if [ ! -d "$project_name" ]; then
      echo -e "$RED Project folder '$project_name' not found. Deleting... $NC"
      rm -rf "$subfolder"
      echo -e "$RED Deleted: $subfolder $NC"
    else
      echo "Project folder '$project_name' found."
    fi
  fi
done < <(find "$workspace_storage_dir_3" -mindepth 1 -maxdepth 1 -type d -print0)

echo "Process complete."
