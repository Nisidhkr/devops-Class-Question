#!/bin/bash

addusers() {
  file="$1"
  if [[ ! -f "$file" ]]; then
    echo "File not found"
    exit 1
  fi

  while read -r user; do
    if id "$user" &>/dev/null; then
      echo "User $user already exists"
    else
      useradd -m "$user"
      echo "User $user created"
    fi
  done < "$file"
}

setupprojects() {
  username="$1"
  num="$2"
  user_home="/home/$username"

  proj_dir="$user_home/projects"
  if [[ ! -d "$user_home" ]]; then
    echo "User home not found"
    exit 1
  fi

  mkdir -p "$proj_dir"
  for ((i=1;i<=num;i++)); do
    mkdir -p "$proj_dir/project$i"
    echo "Project $i created by $username on $(date)" > "$proj_dir/project$i/README.txt"
    chmod 755 "$proj_dir/project$i"
    chmod 640 "$proj_dir/project$i/README.txt"
    chown "$username":"$username" "$proj_dir/project$i"
    chown "$username":"$username" "$proj_dir/project$i/README.txt"
  done

  echo "Created $num projects in $proj_dir"
}

sysreport() {
  output="$1"

  echo "Disk Usage" > "$output"
  df -h >> "$output"
  echo "" >> "$output"

  echo "Memory Info" >> "$output"
  free -h >> "$output"
  echo "" >> "$output"

  echo "CPU Info" >> "$output"
  lscpu | grep "Model name" >> "$output"
  echo "" >> "$output"

  echo "Top 5 Memory Processes" >> "$output"
  ps aux | awk 'NR==1; NR>1 {print $0 | "sort -k4 -rn"}' | head -6 >> "$output"
  echo "" >> "$output"

  echo "Top 5 CPU Processes" >> "$output"
  ps aux | awk 'NR==1; NR>1 {print $0 | "sort -k3 -rn"}' | head -6 >> "$output"

  echo "System report saved to $output"
}

processmanage() {
  username="$1"
  action="$2"
  case "$action" in
    list_zombies)
      ps aux | grep "^$username" | grep " Z "
      ;;
    list_stopped)
      ps aux | grep "^$username" | grep " T "
      ;;
    kill_zombies)
      echo "cannot kill directly"
      ;;
    kill_stopped)
      ps aux | grep "^$username" | grep " T " > /tmp/stopped_procs.txt
      while read line; do
        pid=$(echo $line | awk '{print $2}')
        if [ ! -z "$pid" ]; then
          kill $pid
        fi
      done < /tmp/stopped_procs.txt
      rm /tmp/stopped_procs.txt
      echo "Stopped processes killed"
      ;;
    *)
      echo "Invalid action"
      ;;
  esac
}

PermissionOwnershipManager(){
  path="$1"
  perm="$2"
  owner="$3"
  group="$4"

  if [ ! -d "$path" ] && [ ! -f "$path" ]; then
    echo "Path not found"
    exit 1
  fi

  if [ -f "$path" ]; then
    chmod "$perm" "$path"
    chown "$owner":"$group" "$path"
    echo "Permissions and ownership updated for $path"
  else
    ls -1 "$path" > /tmp/items_list.txt

    chmod "$perm" "$path"
    chown "$owner":"$group" "$path"

    while read item; do
      fullpath="$path/$item"

      if [ -f "$fullpath" ]; then
        chmod "$perm" "$fullpath"
        chown "$owner":"$group" "$fullpath"
      elif [ -d "$fullpath" ]; then
        chmod "$perm" "$fullpath"
        chown "$owner":"$group" "$fullpath"

        ls -1 "$fullpath" > /tmp/subitems_list.txt
        while read subitem; do
          subfullpath="$fullpath/$subitem"
          chmod "$perm" "$subfullpath"
          chown "$owner":"$group" "$subfullpath"
        done < /tmp/subitems_list.txt
        rm /tmp/subitems_list.txt
      fi
    done < /tmp/items_list.txt
    rm /tmp/items_list.txt
    echo "Permissions and ownership updated for $path"
  fi
}

helpmenu() {
  echo "How to use this script:"
  echo "1) Add users from a file"
  echo "2) Create project folders for a user"
  echo "3) Save system information to a file"
  echo "4) Manage user processes (list or kill)"
  echo "5) Change permissions and owner/group of files or folders"
  echo "6) Exit"
}

# ===== Interactive Menu =====
while true; do
  echo ""
  helpmenu
  read -p "Enter your choice (1-6): " choice

  case "$choice" in
    1)
      read -p "Enter the filename with user list: " file
      addusers "$file"
      ;;
    2)
      read -p "Enter the username: " uname
      read -p "Enter the number of projects: " num
      setupprojects "$uname" "$num"
      ;;
    3)
      read -p "Enter the output file path: " outfile
      sysreport "$outfile"
      ;;
    4)
      read -p "Enter username: " uname
      echo "Actions: list_zombies, list_stopped, kill_zombies, kill_stopped"
      read -p "Enter action: " action
      processmanage "$uname" "$action"
      ;;
    5)
      read -p "Enter path: " path
      read -p "Enter permissions (e.g., 755): " perm
      read -p "Enter owner: " owner
      read -p "Enter group: " group
      PermissionOwnershipManager "$path" "$perm" "$owner" "$group"
      ;;
    6)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid choice, please try again."
      ;;
  esac
done
