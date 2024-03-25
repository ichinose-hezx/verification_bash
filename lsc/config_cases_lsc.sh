#!/bin/bash

remove_count=0
caselist_count=0
modify_height_count=0
modify_width_count=0
modify_parameter_count=0

# Define the resolution_change and localparam_change function
resolution_change() {
    local caselist_file_name=$1
    local height=$2
    local width=$3

    # Copy list to Cmodel/run/caselist directory
    cp "./auto_lsc_config/$caselist_file_name" "$caselist_dir/"
    echo "Copied $caselist_file_name to $caselist_dir"

    # Change list in testbench
    sed -i "s|10bit_360p.f|$caselist_file_name|g" "$folder/vmodel/sim/tb_test.v"
    ((caselist_count++))

    # Perform replacement and count occurrences for height
    sed -i "s|:288.|:$height.|g" "$folder/Cmodel/run/config/config.txt"
    replace_count=$(grep -o "$height" "$folder/Cmodel/run/config/config.txt" | wc -l)
    ((modify_height_count+=replace_count))
    echo "Modified height $replace_count times in $folder"

    # Perform replacement and count occurrences for width
    sed -i "s|:352.|:$width.|g" "$folder/Cmodel/run/config/config.txt"
    replace_count=$(grep -o "$width" "$folder/Cmodel/run/config/config.txt" | wc -l)
    ((modify_width_count+=replace_count))
    echo "Modified width $replace_count times in $folder"
}

localparam_change(){
    local param=$1

    # Change local parameter
    sed -i "/^LSC/s|.*|$param|" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_parameter_count++))
        echo "Modified local param in $folder"
    else
        echo "Failed to modify local param in $folder"
    fi
}

# Find all folders starting with "lsc" in the current directory
folders=$(find . -maxdepth 1 -type d -name "lsc*")

# Process each folder
for folder in $folders; do
    # Remove files in Cmodel/run/caselist directory
    caselist_dir="$folder/Cmodel/run/caselist"
    if [ -d "$caselist_dir" ]; then
        echo "Removing files in $caselist_dir"
        rm -f "$caselist_dir"/*
        ((remove_count++))
    fi

    if [[ "$folder" == *"360p"* || "$folder" == *bypass ]]; then
        resolution_change "list_360p_352x288_16b.f" 288 352
    fi

    if [[ "$folder" == *"480p"* ]]; then
        resolution_change "list_480p_640x480_16b.f" 480 640
    fi

    if [[ "$folder" == *"720p"* ]]; then
        resolution_change "list_720p_1280x720_16b.f" 720 1280
    fi

    if [[ "$folder" == *"1080p"* ]]; then
        resolution_change "list_1080p_1920x1080_16b.f" 1080 1920
    fi

    if [[ "$folder" == *"2048x1536"* ]]; then
        resolution_change "list_2k_2048x1536_16b.f" 1536 2048
    fi

    if [[ "$folder" == *"bypass"* ]]; then
        localparam_change "LSC__GRID:0.en:0.strength:113,"
    fi

    if [[ "$folder" == *"para1"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:113,"
    fi

    if [[ "$folder" == *"para2"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:49," 
    fi

    if [[ "$folder" == *"para3"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:8," 
    fi

    if [[ "$folder" == *"paramax"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:128," 
    fi

    if [[ "$folder" == *"paramin"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:0," 
    fi
done

echo "Total files removed: $remove_count"
echo "Total caselists updated: $caselist_count"
echo "Total heights modified: $modify_height_count"
echo "Total widths modified: $modify_width_count"
echo "Total parameters modified: $modify_parameter_count"