## The home task for the topic "Linux + Bash"

# Task 1. Create a script that uses the following keys:

1. When starting without parameters, it will display a list of possible keys and their description.
2. The --all key displays the IP addresses and symbolic names of all hosts in the current subnet.
3. The --target key displays a list of open system TCP ports.

```bash
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
```
![screen](https://github.com/d-SAVCHUK/EPAM_DevOps_HT_Linux_Bash/blob/main/task%201/Screenshot.png)

# Task 2. Using Apache log example create a script to answer the following questions:

1. From which ip were the most requests?
2. What is the most requested page?
3. How many requests were there from each ip?
4. What non-existent pages were clients referred to? 
5. What time did site get the most requests?
6. What search bots have accessed the site? (UA + IP)

```bash
#!/bin/bash

#HT #2 Dmytro SAVCHUK

# Function to show all possible parameters
show_parameters() {
  echo "1. Show all possible parameters"
  echo "2. From which IP were the most requests?"
  echo "3. What is the most requested page?"
  echo "4. How many requests were there from each IP?"
  echo "5. What non-existent pages were clients referred to?"
  echo "6. What time did site get the most requests?"
  echo "7. What search bots have accessed the site? (UA + IP)"
}

# Check if no parameters were passed
if [ $# -eq 0 ]; then
  show_parameters
  exit 0
fi

# Perform the task specified by the parameter
case $1 in
  "1")
    show_parameters
    ;;
  "2")
    echo "From which IP were the most requests?"
    awk '{print $1}' apache_log_DS.txt | sort | uniq -c | sort -nr | head -1
    ;;
  "3")
    echo "What is the most requested page?"
    awk '{print $7}' apache_log_DS.txt | sort | uniq -c | sort -nr | head -1
    ;;
  "4")
    echo "How many requests were there from each IP?"
    awk '{print $1}' apache_log_DS.txt | sort | uniq -c | sort -nr
    ;;
  "5")
    echo "What non-existent pages were clients referred to?"
    grep "404" apache_log_DS.txt | awk '{print $7}' | sort | uniq -c | sort -nr
    ;;
  "6")
    echo "What time did site get the most requests?"
    awk '{print $4}' apache_log_DS.txt | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -1
    ;;
  "7")
    echo "What search bots have accessed the site? (UA + IP)" 
    awk '{print $1,$14}' apache_log_DS.txt | grep "bot" | sort | uniq -c | sort -nr
    ;;
  *)
    echo "Invalid parameter. Please choose a number between 1 and 7."
    exit 1
    ;;
esac
```
![screen2](https://github.com/d-SAVCHUK/EPAM_DevOps_HT_Linux_Bash/blob/main/task%202/Screenshot.png)

# Task 3. Create a data backup script that takes the following data as parameters:

1. Path to the syncing directory.
2. The path to the directory where the copies of the files will be stored.

```bash
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
```
![screen3](https://github.com/d-SAVCHUK/EPAM_DevOps_HT_Linux_Bash/blob/main/task%203/Screenshot.png)
