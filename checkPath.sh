#!/bin/bash

# Function to check file/directory access
check_access() {
  local path="$1"
  local user="$2"
  local group="$3"
  local permission="$4"  # "r" - read, "w" - write, "x" - execute

  # Use stat to get file permissions
  file_stat=$(stat -c "%a" "$path")

  # Extract permission bits
  owner_perm="${file_stat:0:1}"
  group_perm="${file_stat:1:1}"
  other_perm="${file_stat:2:1}"

  # Check permission based on user/group
  case "$1" in
    "$user") access_flag=($owner_perm) ;;
    "$group") access_flag=($group_perm) ;;
    *) access_flag=($other_perm) ;;
  esac

  # Check if permission flag matches desired permission
  if [[ "$access_flag" =~ "$permission" ]]; then
    echo "true"
  else
    echo "false"
  fi
}

# Get arguments
if [ $# -ne 2 ]; then
  echo "Usage: $0 <path> <user/group>"
  exit 1
fi

path="$1"
user_group="$2"

# Check if path exists
if [ ! -e "$path" ]; then
  echo "Error: Path '$path' does not exist."
  exit 1
fi

# Get current user and group (for comparison with user/group argument)
current_user=$(whoami)
current_group=$(id -gn)

# Check access for owner, group, and others (read, write, and execute)
read_access_owner=$(check_access "$path" "$current_user" "$current_group" "r")
write_access_owner=$(check_access "$path" "$current_user" "$current_group" "w")
execute_access_owner=$(check_access "$path" "$current_user" "$current_group" "x")

read_access_group=$(check_access "$path" "$user_group" "-" "r")
write_access_group=$(check_access "$path" "$user_group" "-" "w")
execute_access_group=$(check_access "$path" "$user_group" "-" "-" "x")  # Group can't execute directories

read_access_others=$(check_access "$path" "-" "-" "r")
write_access_others=$(check_access "$path" "-" "-" "w")
execute_access_others=$(check_access "$path" "-" "-" "x")

# Print results
echo "Owner permissions:"
echo "  Read: $read_access_owner"
echo "  Write: $write_access_owner"
echo "  Execute: $execute_access_owner"

echo "Group permissions (for '$user_group'):"
echo "  Read: $read_access_group"
echo "  Write: $write_access_group"
echo "  Execute: $execute_access_group"

echo "Others permissions:"
echo "  Read: $read_access_others"
echo "  Write: $write_access_others"
echo "  Execute: $execute_access_others"

echo "exit code is: $?"
