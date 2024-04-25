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
    sed -i "/^YUVDNS/s|.*|$param|" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_parameter_count++))
        echo "Modified local param in $folder"
    else
        echo "Failed to modify local param in $folder"
    fi
}

# Find all folders starting with "yuvdns" in the current directory
folders=$(find . -maxdepth 1 -type d -name "yuvdns*")

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
        localparam_change "YUVDNS__BASE:0.en:0.a_y:12.b_y:10.sigma_y:100.a_c:13.b_c:11.sigma_c:30,"
    fi

    if [[ "$folder" == *"para1"* ]]; then
        localparam_change "YUVDNS__BASE:0.en:1.a_y:12.b_y:10.sigma_y:100.a_c:13.b_c:11.sigma_c:30,"
    fi

    if [[ "$folder" == *"para2"* ]]; then
        localparam_change "YUVDNS__BASE:0.en:1.a_y:13.b_y:11.sigma_y:30.a_c:12.b_c:10.sigma_c:100," 
    fi

    if [[ "$folder" == *"para3"* ]]; then
        localparam_change "YUVDNS__BASE:0.en:1.a_y:14.b_y:12.sigma_y:60.a_c:12.b_c:8.sigma_c:60," 
    fi

    if [[ "$folder" == *"paramax"* ]]; then
        localparam_change "YUVDNS__BASE:0.en:1.a_y:15.b_y:15.sigma_y:255.a_c:15.b_c:15.sigma_c:255," 
    fi

    if [[ "$folder" == *"paramin"* ]]; then
        localparam_change "YUVDNS__BASE:0.en:1.a_y:1.b_y:1.sigma_y:0.a_c:1.b_c:1.sigma_c:0," 
    fi
done

echo "Total files removed: $remove_count"
echo "Total caselists updated: $caselist_count"
echo "Total heights modified: $modify_height_count"
echo "Total widths modified: $modify_width_count"
echo "Total parameters modified: $modify_parameter_count"