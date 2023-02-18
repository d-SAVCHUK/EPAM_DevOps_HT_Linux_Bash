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

# Task 2. Using Apache log example create a script to answer the following questions::

1. From which ip were the most requests?
2. What is the most requested page?
3. How many requests were there from each ip?
4. What non-existent pages were clients referred to? 
5. 5. What time did site get the most requests?
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
