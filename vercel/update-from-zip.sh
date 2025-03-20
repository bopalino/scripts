#!/bin/bash
# Copyright (c) 2025 bopalino
# 
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# Script to copy content from an extracted folder to a git-managed target directory
# Ensures the staging branch in the target directory is clean before proceeding

set -e  # Exit on any error

# Function to check if a branch exists in the specified git directory
branch_exists() {
  local target_dir="$1"
  local branch_name="$2"
  (cd "$target_dir" && git show-ref --verify --quiet "refs/heads/$branch_name")
  return $?
}

# Function to check if working directory is clean
is_git_clean() {
  local target_dir="$1"
  # Check if there are staged or unstaged changes
  if [[ -n $(cd "$target_dir" && git status --porcelain) ]]; then
    return 1
  else
    return 0
  fi
}

# Function to display error and exit
error_exit() {
  echo "ERROR: $1" >&2
  exit 1
}

# Check if required parameters are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  error_exit "Usage: $0 <source_folder> <target_folder>"
fi

SOURCE_FOLDER="$1"
TARGET_FOLDER="$2"

# Resolve to absolute paths if relative paths are provided
if [[ ! "$SOURCE_FOLDER" = /* ]]; then
  SOURCE_FOLDER="$(pwd)/$SOURCE_FOLDER"
fi

if [[ ! "$TARGET_FOLDER" = /* ]]; then
  TARGET_FOLDER="$(pwd)/$TARGET_FOLDER"
fi

# Verify source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
  error_exit "Source folder '$SOURCE_FOLDER' does not exist."
fi

# Verify target folder exists
if [ ! -d "$TARGET_FOLDER" ]; then
  error_exit "Target folder '$TARGET_FOLDER' does not exist."
fi

# Verify target folder is a git repository
if ! (cd "$TARGET_FOLDER" && git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
  error_exit "Target directory is not a git repository."
fi

# Check if staging branch exists in the target folder, create if it doesn't
if ! branch_exists "$TARGET_FOLDER" "staging"; then
  echo "Staging branch doesn't exist in target folder. Creating it now..."
  (cd "$TARGET_FOLDER" && git checkout -b staging)
else
  # Switch to staging branch
  (cd "$TARGET_FOLDER" && git checkout staging)
fi

# Check if the staging branch is clean
if ! is_git_clean "$TARGET_FOLDER"; then
  error_exit "Staging branch in the target folder has uncommitted changes. Please commit or stash them before proceeding."
fi

echo "Copying files from $SOURCE_FOLDER to $TARGET_FOLDER..."

# Copy the contents from the source folder to the target folder
# Use rsync to ensure only new/updated files are copied
rsync -av --progress "$SOURCE_FOLDER/" "$TARGET_FOLDER/" || error_exit "Failed to copy files."

echo "Success! Files have been updated."
echo "Don't forget to review changes, add files to git, commit, and push."

# Instructions for next steps
echo ""
echo "Suggested next steps (run these in the target folder):"
echo "1. cd $TARGET_FOLDER"
echo "2. git status              # Review changes"
echo "3. git add .               # Add all new files"
echo "4. git commit -m 'message' # Commit changes"
echo "5. git push origin staging # Push to remote"