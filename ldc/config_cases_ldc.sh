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
    cp "./auto_config/$caselist_file_name" "$caselist_dir/"
    echo "Copied $caselist_file_name to $caselist_dir"

    # Change list in testbench
    sed -i "s|test_m.f|$caselist_file_name|g" "$folder/vmodel/sim/tb_test.v"
    ((caselist_count++))

    # Perform replacement and count occurrences for height
    sed -i "s|Global_FrameHeight:200|Global_FrameHeight:$height|g" "$folder/Cmodel/run/config/config.txt"
    sed -i "s|Sta_win_height:200|Sta_win_height:$height|g" "$folder/Cmodel/run/config/config.txt"
    sed -i "s|Sta_region_h:200|Sta_region_h:$height|g" "$folder/Cmodel/run/config/config.txt"
    replace_count=$(grep -o "$height" "$folder/Cmodel/run/config/config.txt" | wc -l)
    ((modify_height_count+=replace_count))
    echo "Modified height $replace_count times in $folder"

    # Perform replacement and count occurrences for width
    sed -i "s|Global_FrameWidth:200|Global_FrameWidth:$width|g" "$folder/Cmodel/run/config/config.txt"
    sed -i "s|Sta_win_width:200|Sta_win_width:$width|g" "$folder/Cmodel/run/config/config.txt"
    sed -i "s|Sta_region_w:200|Sta_region_w:$width|g" "$folder/Cmodel/run/config/config.txt"
    replace_count=$(grep -o "$width" "$folder/Cmodel/run/config/config.txt" | wc -l)
    ((modify_width_count+=replace_count))
    echo "Modified width $replace_count times in $folder"
}

localparam_change(){
    local param=$1
    
    # Change local parameter
    sed -i "/^LDC/s|.*|$param|" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_parameter_count++))
        echo "Modified local param in $folder"
    else
        echo "Failed to modify local param in $folder"
    fi
}

localparam_with_resolution_change(){
    local cx=$1
    local cy=$2
    
    # Change local parameter cx cy
    sed -i "/^LDC/s|cx:.*|cx:$cx.cy:$cy,|" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_parameter_count++))
        echo "Modified local param with resolution in $folder"
    else
        echo "Failed to modify local param with resolution in $folder"
    fi
}

# Find all folders starting with "ldc" in the current directory
folders=$(find . -maxdepth 1 -type d -name "ldc*")

# Process each folder
for folder in $folders; do
    # Remove files in Cmodel/run/caselist directory
    caselist_dir="$folder/Cmodel/run/caselist"
    if [ -d "$caselist_dir" ]; then
        echo "Removing files in $caselist_dir"
        rm -f "$caselist_dir"/*
        ((remove_count++))
    fi

    if [[ "$folder" == *"bypass"* ]]; then
        localparam_change "LDC__LITE:0.en:0.strength:16384.k1:-5926.k2:3057.fx:1038.fy:1038.cx:100.cy:100,"
    fi

    if [[ "$folder" == *"para1"* ]]; then
        localparam_change "LDC__LITE:0.en:1.strength:16384.k1:-5926.k2:3057.fx:1038.fy:1038.cx:176.cy:144,"
    fi

    if [[ "$folder" == *"para2"* ]]; then
        localparam_change "LDC__LITE:0.en:1.strength:12288.k1:-4796.k2:1855.fx:535.fy:535.cx:176.cy:144," 
    fi

    if [[ "$folder" == *"para3"* ]]; then
        localparam_change "LDC__LITE:0.en:1.strength:10923.k1:-5903.k2:1789.fx:1118.fy:1118.cx:176.cy:144," 
    fi

    if [[ "$folder" == *"paramax"* ]]; then
        localparam_change "LDC__LITE:0.en:1.strength:16384.k1:32767.k2:32767.fx:4095.fy:4095.cx:2047.cy:2047," 
    fi

    if [[ "$folder" == *"paramin"* ]]; then
        localparam_change "LDC__LITE:0.en:1.strength:0.k1:-32768.k2:-32768.fx:256.fy:256.cx:0.cy:0," 
    fi

    if [[ "$folder" == *"360p"* || "$folder" == *bypass ]]; then
        resolution_change "list_360p_352x288_16b.f" 288 352
        localparam_with_resolution_change 176 144
    fi

    if [[ "$folder" == *"480p"* ]]; then
        resolution_change "list_480p_640x480_16b.f" 480 640
        localparam_with_resolution_change 320 240
    fi

    if [[ "$folder" == *"720p"* ]]; then
        resolution_change "list_720p_1280x720_16b.f" 720 1280
        localparam_with_resolution_change 640 360
    fi

    if [[ "$folder" == *"1080p"* ]]; then
        resolution_change "list_1080p_1920x1080_16b.f" 1080 1920
        localparam_with_resolution_change 960 540
    fi

    if [[ "$folder" == *"2048x1536"* ]]; then
        resolution_change "list_2k_2048x1536_16b.f" 1536 2048
        localparam_with_resolution_change  1024 768
    fi


done

echo "Total files removed: $remove_count"
echo "Total caselists updated: $caselist_count"
echo "Total heights modified: $modify_height_count"
echo "Total widths modified: $modify_width_count"
echo "Total parameters modified: $modify_parameter_count"