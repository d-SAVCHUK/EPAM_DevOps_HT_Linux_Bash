#!/bin/bash

#HT #3 Dmytro SAVCHUK

# Display a message indicating that the script is checking the internet status
echo "Checking internet status..."

# Use the 'ping' command to check if a website is reachable
if ping -c 1 google.com; then
    echo "Internet is up"
    # Create the "Current" directory if it does not exist
    if [ ! -d "Current" ]; then
        mkdir "Current"
    fi
    # Save the internet status to a text file in the Current folder with a timestamp in the filename
    echo "UP" > Current/status_$(date +"%Y-%m-%d_%T").txt
else
    echo "Internet is down"
    # Create the "Current" directory if it does not exist
    if [ ! -d "Current" ]; then
        mkdir "Current"
    fi
    # Save the internet status to a text file in the Current folder with a timestamp in the filename
    echo "DOWN" > Current/status_$(date +"%Y-%m-%d_%T").txt
fi

# Create the "BackUp Folder" directory if it does not exist
if [ ! -d "BackUp" ]; then
    mkdir "BackUp"
fi

# Store the current date and time in a variable
now=$(date +"%Y-%m-%d %T")

# Set the path to the syncing directory as "Current"
syncing_dir="Current"

# Set the path to the backup directory as "BackUp Folder"
backup_dir="BackUp"

# Copy all files from the syncing directory to the backup directory
rsync -av --ignore-existing $syncing_dir $backup_dir

# Find any new files in the syncing directory and add them to the log file
for file in $(find $syncing_dir -type f); do
    if ! [ -e "$backup_dir/$file" ]; then
        echo "$now, ADDED, $file" >> log.txt
    fi
done

# Find any deleted files in the backup directory and add them to the log file
for file in $(find $backup_dir -type f); do
    if ! [ -e "$syncing_dir/$file" ]; then
        echo "$now, DELETED, $file" >> log.txt
    fi
done

# Display instructions on how to activate crontab
echo "To run this script every minute add the following command to your crontab:"
echo "* * * * * /path/to/script3.sh"
echo "example: * * * * * /Desktop/script3.sh"
# [NB] Crontab is not work properly on my laptop
