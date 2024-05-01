#!/bin/bash

# Check for correct number of arguments

if [ $# -ne 2 ]; then
    echo "Usage: $0 <directory> <number_of_files>"
  exit 1
fi


# Get directory path and number of files
directory="$1"
num_files="$2"

# Validate directory existence
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' does not exist."
  exit 1
fi

# Use `find` and `sort` to get the heaviest files
#  -L: follow symbolic links
#  -type f: only consider files
#  -exec du -sh {} \;: get size for each file
#  | sort -nr: sort by size in reverse order (largest first)
#  | head -n "$num_files": get the first n lines (n heaviest files)
 heaviest_files=$(find "$directory" -type f -exec du -sh {} \; | sort -nr | head -n "$num_files")

# Print the results
echo "The $num_files heaviest files in '$directory':"
echo "$heaviest_files"

echo "exit code is: $?"
