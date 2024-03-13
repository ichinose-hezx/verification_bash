#!/bin/bash

# Source folder path
source_folder="/net/dellr940d/export/ybfan2/hezx/RTL_Verification/sim_0306/lsc/lsc_frame_360p_raw16_parayyy_lut1"

# Read folder names from file and process line by line
echo "Copying folders:"
while IFS= read -r folder_name; do
    # Skip empty lines
    if [[ -z "$folder_name" ]]; then
        continue
    fi
    
    # Stop reading if line starts with '//'
    if [[ "$folder_name" == "//"* ]]; then
        break
    fi
    
    # Check if target folder already exists
    if [ -d "$folder_name" ]; then
        echo "Folder '$folder_name' already exists, skipping..."
        continue
    fi
    
    # Copy source folder and rename
    cp -r "$source_folder" "$folder_name"
    echo "Source folder copied and renamed to '$folder_name'"
done < cases_name.txt