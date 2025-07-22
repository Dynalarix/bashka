#!/usr/bin/env bash

if ! command -v firefox &> /dev/null; then
    echo "Error: Firefox is not installed"
    exit 1
fi

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Clear screen
clear

# Time-based greeting
hour=$(date +%H)
if (( hour >= 5 && hour < 12 )); then
    greeting="		Good morning!"
elif (( hour >= 12 && hour < 18 )); then
    greeting="		Good afternoon!"
elif (( hour >= 18 && hour < 22 )); then
    greeting="		Good evening!"
else
    greeting="		Good night!"
fi

echo "${green}$greeting${reset}"
echo ""

# Check if sites file exists
if [[ ! -f "sites.txt" ]]; then
    echo "Error: sites.txt not found in current directory"
    exit 1
fi

# Read sites into array
mapfile -t sites < sites.txt

# Display menu
echo "Your favorite websites:"
echo ""
for i in "${!sites[@]}"; do
    printf "%d. %s\n" "$((i+1))" "${sites[$i]#*//}"
done
echo ""
echo "0. Exit"
echo ""

# Main loop
while true; do
    read -p "Enter site number :" choice
    
    # Handle exit
    if [[ "$choice" == "0" ]]; then
        exit 0
    fi
    
    # Validate input
    if [[ "$choice" -ge 1 && "$choice" -le "${#sites[@]}" ]]; then
        # Open in Firefox private window (0-based array)
        firefox --private-window "${sites[$((choice-1))]}"
        clear
        
		echo ""
			
        # Redisplay menu
		for i in "${!sites[@]}"; do
    		printf "%d. %s\n" "$((i+1))" "${sites[$i]#*//}"
		done
        echo ""
        echo "0. Exit"
        echo ""
    else
        echo "Invalid choice. Please enter a number between 1 and ${#sites[@]}"
    fi
done
