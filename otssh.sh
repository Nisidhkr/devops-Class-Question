#!/bin/bash

CONFIG_FILE="$HOME/.otssh_config"
[ ! -f "$CONFIG_FILE" ] && touch "$CONFIG_FILE"

add_connection() {
    name=""; host=""; user=""; port=22; identity=""
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n) name="$2"; shift ;;
            -h) host="$2"; shift ;;
            -u) user="$2"; shift ;;
            -p) port="$2"; shift ;;
            -i) identity="$2"; shift ;;
        esac
        shift
    done

    if [[ -z "$name" || -z "$host" || -z "$user" ]]; then
        echo "Error: Missing -n, -h, or -u"
        exit 1
    fi

    grep -v "^$name:" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"
    mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

    echo "$name:$user@$host:$port:$identity" >> "$CONFIG_FILE"
    echo "Added $name"
}

list_connections() {
    if [[ "$1" == "-d" ]]; then
        while IFS=":" read -r name userhost port identity; do
            [[ -z "$name" ]] && continue
            if [[ -n "$identity" ]]; then
                echo "$name: ssh -i $identity -p $port $userhost"
            else
                echo "$name: ssh -p $port $userhost"
            fi
        done < "$CONFIG_FILE"
    else
        cut -d ":" -f 1 "$CONFIG_FILE"
    fi
}

update_connection() {
    add_connection "$@"
}

remove_connection() {
    name="$1"
    if grep -q "^$name:" "$CONFIG_FILE"; then
        grep -v "^$name:" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"
        mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
        echo "Removed $name"
    else
        echo "Error: $name not found"
    fi
}

connect_server() {
    name="$1"
    line=$(grep "^$name:" "$CONFIG_FILE")
    if [[ -z "$line" ]]; then
        echo "Error: Server not found, add it first"
        exit 1
    fi

    IFS=":" read -r _ userhost port identity <<< "$line"
    echo "Connecting to $name..."
    if [[ -n "$identity" ]]; then
        ssh -i "$identity" -p "$port" "$userhost"
    else
        ssh -p "$port" "$userhost"
    fi
}

case "$1" in
    -a) shift; add_connection "$@" ;;
    -u) shift; update_connection "$@" ;;
    rm) shift; remove_connection "$1" ;;
    ls) shift; list_connections "$@" ;;
    *) connect_server "$1" ;;
esac
