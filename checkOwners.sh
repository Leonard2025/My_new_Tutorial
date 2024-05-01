#!/bin/bash

# Get the current user's name
current_user=$(whoami)

# Check for directory argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Get directory path
directory="$1"

# Validate directory existence
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' does not exist."
  exit 1
fi

# Loop through files in the directory
for file in "$directory/"*; do
  # Check if it's a file (not a directory or link)
  if [ -f "$file" ]; then
    # Get file owner using stat
    owner=$(stat -c "%U" "$file")
    
    # Compare owner with current user
    if [ "$owner" != "$current_user" ]; then
      echo "Error: File '$file' is owned by '$owner', not you ($current_user)."
    fi
  fi
done

  echo "The exit code is: $?"
# Script exits successfully if no errors found (no output)

