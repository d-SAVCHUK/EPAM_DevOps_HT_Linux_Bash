#!/bin/bash

#HT #1 Dmytro SAVCHUK

# function to display list of possible keys and their descriptions
display_help() {
    echo "List of possible keys:"
    echo "--all : Displays the IP addresses and symbolic names of all hosts in the current subnet"
    echo "--target : Displays a list of open system TCP ports"
}

# function to display IP addresses and symbolic names of all hosts in current subnet
display_all() {
    arp -a
}

# function to display a list of open system TCP ports
display_target() {
    netstat –at   # t - TCP ports
}

# check if no arguments were provided
if [ $# -eq 0 ]; then
    display_help
    exit 1
fi

# process the provided keys
while [ $# -gt 0 ]; do
    key="$1"
    case $key in
        --all)
            display_all
            shift
            ;;
        --target)
            display_target
            shift
            ;;
        *)
            echo "Invalid key: $key"
            display_help
            exit 1
            ;;
    esac
done