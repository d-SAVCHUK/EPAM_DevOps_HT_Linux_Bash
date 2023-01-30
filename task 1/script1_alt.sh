#!/bin/bash

#Its not work on my laptop

Help()
{
   # Display Help
   echo "Script for cheking IPs in subnet and open ports"
   echo
   echo "Syntax: scriptTemplate [--all|--help|--target]"
   echo "options:"
   echo "-a, --all                         Displays the IP addresses and symbolic names of all hosts in the current subnet."
   echo "-t, --target                      Displays a list of open system TCP ports."
   echo "-h, --help                        Show help"
   echo
}

AllFunc()
{
    myIp=$(ip -o -f inet addr show eth0 | awk '/scope global/ {print $4}')
    echo "My IP with subnetmask is: " $myIp

    echo "IPs and symbolic names: "
    nmap -sn -PA $myIp -oG  - | awk '/Up$/{print $2 $3}'
}

OpenPorts()
{
    echo "Open TCP ports on current machine are: "
    netstat -tulpn | grep LISTEN
}

while [ True ]; do
if [ "$1" = "--all" -o "$1" = "-a" ]; then
    
    AllFunc
    break

elif [ "$1" = "--target" -o "$1" = "-t" ]; then
    
    OpenPorts
    break

elif [ "$1" = "--help" -o "$1" = "-h" ]; then
    Help
    break
else
    Help
    break
fi
done