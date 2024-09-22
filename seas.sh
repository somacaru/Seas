#!/bin/bash

# This script is a simple automation script for subdomain enumeration, virtual hosts, crawling, web application fingerprinting, and piping output from amass to aquatone and nikto.

# Display an ASCII art banner at the beginning of the script.
echo "Subdomain Enumeration Automation Script"
echo "By: stack0ver10rd"

printf '\n%s\n' "**************************************************" 


# Display a menu for the user to select the option they want to use.
echo "1. Subdomain Enumeration"
echo "2. Virtual Hosts"
echo "3. Crawling"
echo "4. Web Application Fingerprinting"
echo "5. Piping output from amass to aquatone and nikto..."
echo "6. Exit"

# Read the user's choice.
read -p "Enter your choice: " choice


# Call the functions when the user selects the option.
case $choice in
    1) subdomain_enum ;;
    2) virtual_hosts ;;
    3) crawling ;;
    4) web_app_fingerprinting ;;
    5) piping_output ;;
    6) exit ;;
    *) echo "Invalid choice. Use brain module." ;;
esac

# Functions for the options in the menu.
# Subdomain Enumeration
subdomain_enum() {
    echo "Subdomain Enumeration"
    echo "Enter the target domain: "
    read target
    amass enum -d $target -o amass.txt
    subfinder -d $target -o subfinder.txt
    assetfinder -subs-only $target | tee assetfinder.txt
    findomain -t $target -o findomain.txt
    sublist3r -d $target -o sublist3r.txt
    knockpy $target
    subjack -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t 100 -v -c /usr/share/seclists/Discovery/DNS/sorted_knock_dnsrecon_fierce_recon-ng.txt -ssl -a -m -n -o subjack.txt -d $target
    }

# Virtual Hosts
virtual_hosts() {
    echo "Virtual Hosts"
    echo "Enter the target IP address: "
    read ip
    echo "Enter the path to the vhosts file: "
    read vhosts
    ffuf -w $vhosts -u http://$ip -H "HOST: FUZZ.target.domain"
    }

# Crawling
crawling() {
    echo "Crawling"
    echo "Enter the target IP address: "
    read ip
    ffuf -recursion -recursion-depth 1 -u http://$ip/FUZZ -w /opt/useful/SecLists/Discovery/Web-Content/raft-small-directories-lowercase.txt
    ffuf -w ./folders.txt:FOLDERS,./wordlist.txt:WORDLIST,./extensions.txt:EXTENSIONS -u http://www.target.domain/FOLDERS/WORDLISTEXTENSIONS
    }

# Web Application Fingerprinting
web_app_fingerprinting() {
    echo "Web Application Fingerprinting"
    echo "Enter the target domain: "
    read target
    whatweb -a https://$target -v
    wafw00f -v https://$target
    Aquatone -d $target
    nikto -h http://$target
    }

# Piping output from amass to aquatone and nikto...
piping_output() {
    echo "Piping output from amass to aquatone and nikto..."
    echo "Enter the target domain: "
    read target
    amass enum -d $target -o amass.txt | aquatone -d $target | nikto -h http://$target
    }

# Exit the script
exit() {
    echo "Exiting the script..."
    exit
    }
