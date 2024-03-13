#!/bin/bash

# Get a list of all folders in the current directory ending with "lutran"
folders=$(find . -maxdepth 1 -type d -name "*lutran")

# Iterate over each folder
for folder in $folders; do
    # Skip the current directory and parent directory
    if [ "$folder" != "." ] && [ "$folder" != ".." ]; then
        # Define the path to vmodel/sim directory
        sim_path="$folder/vmodel/sim"

        # Check if the vmodel/sim directory exists
        if [ -d "$sim_path" ]; then
            # Open a new terminal in the vmodel/sim directory and execute pwd
            gnome-terminal --working-directory="$sim_path" -- bash -c 'pwd; exec bash'
        fi
    fi
done