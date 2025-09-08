#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 [command] [directory] [dirname(optional)]"
    exit 1
fi

cmd=$1
dir=$2
name=$3

if [ "$cmd" = "addDir" ]; then
    mkdir -p "$dir/$name"
    echo "Directory created: $dir/$name"
elif [ "$cmd" = "deleteDir" ]; then
    rm -rf "$dir/$name"
    echo "Directory deleted: $dir/$name"
elif [ "$cmd" = "listFiles" ]; then
    find "$dir" -maxdepth 1 -type f
elif [ "$cmd" = "listDirs" ]; then
    find "$dir" -maxdepth 1 -type d ! -path "$dir"
elif [ "$cmd" = "listAll" ]; then
    ls -l "$dir"
else
    echo "Invalid command"
fi

