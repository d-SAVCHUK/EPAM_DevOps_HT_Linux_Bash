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

