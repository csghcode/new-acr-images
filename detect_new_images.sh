#!/bin/bash

# Function to print messages in cyan
print_message() {
    echo -e "\e[36m$1\e[0m"
}

# Azure ACR name
ACR_NAME="wizio.azurecr.io"

# File to store the previous list of images
PREVIOUS_IMAGES_FILE="previous_images.txt"
CURRENT_IMAGES_FILE="current_images.txt"
NEW_IMAGES_FILE="new_images.txt"

# Function to fetch the list of images from Azure ACR
fetch_acr_images() {
    print_message "Fetching images from Azure ACR..."
    az acr repository list --name "$ACR_NAME" --output tsv > "$CURRENT_IMAGES_FILE"
}

# Ensure Azure CLI is logged in
print_message "Checking Azure CLI login..."
if ! az account show &>/dev/null; then
    print_message "You are not logged in to Azure. Please log in using 'az login'."
    exit 1
fi

# Fetch the current list of images
fetch_acr_images

# Check if the previous list exists
if [ ! -f "$PREVIOUS_IMAGES_FILE" ]; then
    print_message "No previous record found. Saving the current list of images..."
    cp "$CURRENT_IMAGES_FILE" "$PREVIOUS_IMAGES_FILE"
    print_message "Initial setup complete. Run the script again to detect new images."
    exit 0
fi

# Compare current images with previous images
print_message "Comparing current images with the previous record..."
comm -13 <(sort "$PREVIOUS_IMAGES_FILE") <(sort "$CURRENT_IMAGES_FILE") > "$NEW_IMAGES_FILE"

# Check for new images
if [ -s "$NEW_IMAGES_FILE" ]; then
    print_message "New images detected:"
    cat "$NEW_IMAGES_FILE"
    print_message "Updating the record of images..."
    cp "$CURRENT_IMAGES_FILE" "$PREVIOUS_IMAGES_FILE"
else
    print_message "No new images detected."
fi

# Clean up temporary files
rm -f "$CURRENT_IMAGES_FILE" "$NEW_IMAGES_FILE"

print_message "Script execution completed."
