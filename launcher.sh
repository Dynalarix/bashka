#!/usr/bin/env bash

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

echo "$greeting"
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
    # Convert index to hexadecimal (0-based to 1-based for display)
    hex_index=$((i+1))
    printf "%x. %s\n" "$hex_index" "$(echo "${sites[$i]}" | sed -e 's|^https\?://||')"
done
echo ""
echo "0. Exit"
echo ""

# Main loop
while true; do
    read -p "Enter site number (hex): " choice
    
    # Convert hex to decimal
    choice_dec=$((16#$choice))
    
    # Handle exit
    if [[ "$choice" == "0" ]]; then
        exit 0
    fi
    
    # Validate input
    if [[ "$choice_dec" -ge 1 && "$choice_dec" -le "${#sites[@]}" ]]; then
        # Open in Firefox private window (0-based array)
        firefox --private-window "${sites[$((choice_dec-1))]}"
        clear
        
		echo ""
        # Redisplay menu
        for i in "${!sites[@]}"; do
            hex_index=$((i+1))
            printf "%x. %s\n" "$hex_index" "$(echo "${sites[$i]}" | sed -e 's|^https\?://||')"
        done
        echo ""
        echo "0. Exit"
        echo ""
    else
        echo "Invalid choice. Please enter a number between 1 and ${#sites[@]} (hex)"
    fi
done
