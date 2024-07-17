#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Define color codes for highlighting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Function to print messages with colors
print_message() {
    local color="$1"
    shift
    echo -e "${color}$@${RESET}"
}

# Create a temporary directory if it doesn't exist
if [ ! -d temp ]; then
    mkdir temp || { print_message "$RED" "Failed to create temp directory."; exit 1; }
    print_message "$GREEN" "Temporary directory created: temp"
else
    print_message "$YELLOW" "Temporary directory already exists: temp"
fi

# Extract themes and icons
print_message "$BLUE" "Extracting Desert-Dark theme..."
tar -xf theme/Desert-Dark.tar -C temp || { print_message "$RED" "Failed to extract Desert-Dark theme."; exit 1; }

print_message "$BLUE" "Extracting Newaita-Dark icons..."
tar -xzf icons/Newaita-Dark.tar.gz -C temp || { print_message "$RED" "Failed to extract Newaita-Dark icons."; exit 1; }

# Copy the theme and icons to the appropriate directories
print_message "$BLUE" "Copying Desert-Dark theme..."
cp -r temp/Desert-Dark ~/.local/share/themes/Desert-Dark || { print_message "$RED" "Failed to copy Desert-Dark theme."; exit 1; }

print_message "$BLUE" "Copying Newaita-Dark icons..."
cp -r temp/Newaita-Dark ~/.local/share/icons/Newaita-Dark || { print_message "$RED" "Failed to copy Newaita-Dark icons."; exit 1; }

print_message "$BLUE" "Copying xfce4 configuration..."
cp -rf xfce4-config/** ~/.config/xfce4 || { print_message "$RED" "Failed to copy xfce4 config."; exit 1; }

# Change GTK theme
print_message "$BLUE" "Changing GTK theme to Desert-Dark..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Desert-Dark" || { print_message "$RED" "Failed to set GTK theme."; exit 1; }

# Change Window Manager theme
print_message "$BLUE" "Changing Window Manager theme to Desert-Dark..."
xfconf-query -c xfwm4 -p /theme -n -t string -s "Desert-Dark" || { print_message "$RED" "Failed to set Window Manager theme."; exit 1; }

# Change Icon theme
print_message "$BLUE" "Changing Icon theme to Newaita-Dark..."
xfconf-query -c xsettings -p /Net/IconThemeName -s "Newaita-Dark" || { print_message "$RED" "Failed to set Icon theme."; exit 1; }

# Restart the session to apply changes
print_message "$BLUE" "Restarting window manager to apply changes..."
xfwm4 --replace &

print_message "$GREEN" "Themes and icons have been successfully installed and applied."

rm -rf temp || { print_message "$RED" "Failed remove temp folder"; exit 1; }

exit 0