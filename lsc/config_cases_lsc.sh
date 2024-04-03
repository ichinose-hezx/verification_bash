#!/bin/bash

remove_count=0

caselist_count=0
modify_height_count=0
modify_width_count=0

modify_parameter_count=0

modify_datin_bits_count=0

modify_blc_count=0

copylut_count=0
modify_vlut_count=0
modify_clut_count=0

# Define the resolution_change and localparam_change function
resolution_change() {
    local caselist_file_name=$1
    local height=$2
    local width=$3

    # Copy list to Cmodel/run/caselist directory
    cp "./auto_config/$caselist_file_name" "$caselist_dir/"
    echo "Copied $caselist_file_name to $caselist_dir"

    # Change list in testbench
    sed -i "s|test_l.f|$caselist_file_name|g" "$folder/vmodel/sim/tb_test.v"
    sed -i "s|test_m.f|$caselist_file_name|g" "$folder/vmodel/sim/tb_test.v"
    sed -i "s|test_s.f|$caselist_file_name|g" "$folder/vmodel/sim/tb_test.v"
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
    sed -i "/^LSC/s|.*|$param|" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_parameter_count++))
        echo "Modified local param in $folder"
    else
        echo "Failed to modify local param in $folder"
    fi
}

lut_change(){
    local lutname=$1
    local lutnum=$2

    # Delete lut1
    if [ -f "$folder/Cmodel/run/config/lsc858_12fracbit_tb.txt" ]; then
        rm "$folder/Cmodel/run/config/lsc858_12fracbit_tb.txt"
        echo "Deleted lsc858_12fracbit_tb.txt in $folder/Cmodel/run/config for folder $folder"
    fi

    # Copy lut
    cp "./auto_config/$lutname" "$folder/Cmodel/run/config/"
    echo "Copied $lutname to $folder/Cmodel/run/config/ for folder $folder"
    ((copylut_count++))

    # Change vlut
    sed -i "s|lsc858_12fracbit_tb|$lutname|g" "$folder/vmodel/sim/tb_test.v"
    if [ $? -eq 0 ]; then
        echo "Modified tb_test.v in $folder for $lutnum"
        ((modify_vlut_count++))
    else
        echo "Failed to modify tb_test.v in $folder for $lutnum"
    fi

    # Change clut
    sed -i "s|lsc858_12fracbit_tb.txt|$lutname|g" "$folder/Cmodel/run/xkisp_HDR.sh"
    if [ $? -eq 0 ]; then
        echo "Modified xkisp_HDR.sh in $folder for $lutnum"
        ((modify_clut_count++))
    else
        echo "Failed to modify xkisp_HDR.sh in $folder for $lutnum"
    fi
}

datainbits_change(){
    local param=$1

    # Change datainbits parameter
    sed -i "s|isp_datin_bits:16|isp_datin_bits:$param|g" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_datin_bits_count++))
        echo "Modified datainbits in $folder"
    else
        echo "Failed to modify datainbits in $folder"
    fi
}

blc_change(){
    local blcR=$1
    local blcGr=$2
    local blcGb=$3
    local blcB=$4

    # Change blc parameter
    sed -i "s|Global_blc_R:0.Global_blc_Gr:0.Global_blc_Gb:0.Global_blc_B:0.|Global_blc_R:$blcR.Global_blc_Gr:$blcGr.Global_blc_Gb:$blcGb.Global_blc_B:$blcB.|g" "$folder/Cmodel/run/config/config.txt"
    if [ $? -eq 0 ]; then
        ((modify_blc_count++))
        echo "Modified blcparam in $folder"
    else
        echo "Failed to modify blcparam in $folder"
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

    if [[ "$folder" == *"bypass"* ]]; then
        resolution_change "list_360p_352x288_16b.f" 288 352
        localparam_change "LSC__GRID:0.en:0.strength:113.isp_datin_bits:16,"
    fi

    if [[ "$folder" == *"para1"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:113.isp_datin_bits:16,"
    fi

    if [[ "$folder" == *"para2"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:49.isp_datin_bits:16," 
    fi

    if [[ "$folder" == *"para3"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:8.isp_datin_bits:16," 
    fi

    if [[ "$folder" == *"paramax"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:128.isp_datin_bits:16," 
    fi

    if [[ "$folder" == *"paramin"* ]]; then
        localparam_change "LSC__GRID:0.en:1.strength:0.isp_datin_bits:16," 
    fi


    if [[ "$folder" == *"raw16"* ]]; then
        datainbits_change 16
        if [[ "$folder" == *"blccom"* ]]; then
            blc_change 6400 5120 3840 3072  
        elif [[ "$folder" == *"blcmax"* ]]; then
            blc_change 65535 65535 65535 65535  
        elif [[ "$folder" == *"blcmin"* ]]; then
            blc_change 0 0 0 0 
        elif [[ "$folder" == *"blcran"* ]]; then
            blc_change $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) 
        fi

        if [[ "$folder" == *"360p"* ]]; then
            resolution_change "list_360p_352x288_16b.f" 288 352
        elif [[ "$folder" == *"480p"* ]]; then
            resolution_change "list_480p_640x480_16b.f" 480 640
        elif [[ "$folder" == *"720p"* ]]; then
            resolution_change "list_720p_1280x720_16b.f" 720 1280
        elif [[ "$folder" == *"1080p"* ]]; then
            resolution_change "list_1080p_1920x1080_16b.f" 1080 1920
        elif [[ "$folder" == *"2048x1536"* ]]; then
            resolution_change "list_2k_2048x1536_16b.f" 1536 2048
        fi
    fi

    if [[ "$folder" == *"raw14"* ]]; then
        datainbits_change 14
        if [[ "$folder" == *"blccom"* ]]; then
            blc_change 1600 1280 960 768  
        elif [[ "$folder" == *"blcmax"* ]]; then
            blc_change 65535 65535 65535 65535  
        elif [[ "$folder" == *"blcmin"* ]]; then
            blc_change 0 0 0 0 
        elif [[ "$folder" == *"blcran"* ]]; then
            blc_change $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) 
        fi

        if [[ "$folder" == *"360p"* ]]; then
            resolution_change "list_360p_352x288_14b.f" 288 352
        elif [[ "$folder" == *"480p"* ]]; then
            resolution_change "list_480p_640x480_14b.f" 480 640
        elif [[ "$folder" == *"720p"* ]]; then
            resolution_change "list_720p_1280x720_14b.f" 720 1280
        elif [[ "$folder" == *"1080p"* ]]; then
            resolution_change "list_1080p_1920x1080_14b.f" 1080 1920
        elif [[ "$folder" == *"2048x1536"* ]]; then
            resolution_change "list_2k_2048x1536_14b.f" 1536 2048
        fi
    fi

    if [[ "$folder" == *"raw12"* ]]; then
        datainbits_change 12
        if [[ "$folder" == *"blccom"* ]]; then
            blc_change 400 320 240 192  
        elif [[ "$folder" == *"blcmax"* ]]; then
            blc_change 65535 65535 65535 65535  
        elif [[ "$folder" == *"blcmin"* ]]; then
            blc_change 0 0 0 0 
        elif [[ "$folder" == *"blcran"* ]]; then
            blc_change $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) 
        fi

        if [[ "$folder" == *"360p"* ]]; then
            resolution_change "list_360p_352x288_12b.f" 288 352
        elif [[ "$folder" == *"480p"* ]]; then
            resolution_change "list_480p_640x480_12b.f" 480 640
        elif [[ "$folder" == *"720p"* ]]; then
            resolution_change "list_720p_1280x720_12b.f" 720 1280
        elif [[ "$folder" == *"1080p"* ]]; then
            resolution_change "list_1080p_1920x1080_12b.f" 1080 1920
        elif [[ "$folder" == *"2048x1536"* ]]; then
            resolution_change "list_2k_2048x1536_12b.f" 1536 2048
        fi
    fi

    if [[ "$folder" == *"raw10"* ]]; then
        datainbits_change 10
        if [[ "$folder" == *"blccom"* ]]; then
            blc_change 100 80 60 48  
        elif [[ "$folder" == *"blcmax"* ]]; then
            blc_change 65535 65535 65535 65535  
        elif [[ "$folder" == *"blcmin"* ]]; then
            blc_change 0 0 0 0 
        elif [[ "$folder" == *"blcran"* ]]; then
            blc_change $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) 
        fi

        if [[ "$folder" == *"360p"* ]]; then
            resolution_change "list_360p_352x288_10b.f" 288 352
        elif [[ "$folder" == *"480p"* ]]; then
            resolution_change "list_480p_640x480_10b.f" 480 640
        elif [[ "$folder" == *"720p"* ]]; then
            resolution_change "list_720p_1280x720_10b.f" 720 1280
        elif [[ "$folder" == *"1080p"* ]]; then
            resolution_change "list_1080p_1920x1080_10b.f" 1080 1920
        elif [[ "$folder" == *"2048x1536"* ]]; then
            resolution_change "list_2k_2048x1536_10b.f" 1536 2048
        fi
    fi

    if [[ "$folder" == *"raw8"* ]]; then
        datainbits_change 8
        if [[ "$folder" == *"blccom"* ]]; then
            blc_change 25 20 15 12  
        elif [[ "$folder" == *"blcmax"* ]]; then
            blc_change 65535 65535 65535 65535  
        elif [[ "$folder" == *"blcmin"* ]]; then
            blc_change 0 0 0 0 
        elif [[ "$folder" == *"blcran"* ]]; then
            blc_change $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) $(shuf -i 0-65535 -n 1) 
        fi

        if [[ "$folder" == *"360p"* ]]; then
            resolution_change "list_360p_352x288_8b.f" 288 352
        elif [[ "$folder" == *"480p"* ]]; then
            resolution_change "list_480p_640x480_8b.f" 480 640
        elif [[ "$folder" == *"720p"* ]]; then
            resolution_change "list_720p_1280x720_8b.f" 720 1280
        elif [[ "$folder" == *"1080p"* ]]; then
            resolution_change "list_1080p_1920x1080_8b.f" 1080 1920
        elif [[ "$folder" == *"2048x1536"* ]]; then
            resolution_change "list_2k_2048x1536_8b.f" 1536 2048
        fi
    fi

    if [[ "$folder" == *"lut2"* ]]; then
        lut_change "lsc651_12fracbit_tb.txt" "lut2"  
    fi

    if [[ "$folder" == *"lut3"* ]]; then
        lut_change "lsc383_12fracbit_tb.txt" "lut3" 
    fi

    if [[ "$folder" == *"lutmax"* ]]; then
        lut_change "lscmax_tb.txt" "lutmax" 
    fi

    if [[ "$folder" == *"lutmin"* ]]; then
        lut_change "lscmin_tb.txt" "lutmin" 
    fi

    if [[ "$folder" == *"lutran"* ]]; then
        lut_change "lscran_tb.txt" "lutran" 
    fi
done

echo "Total files removed: $remove_count"
echo "Total caselists updated: $caselist_count"
echo "Total heights modified: $modify_height_count"
echo "Total widths modified: $modify_width_count"
echo "Total parameters modified: $modify_parameter_count"
echo "Total datin_bits modified: $modify_datin_bits_count"
echo "Total blc modified: $modify_blc_count"
echo "Total lut files copied: $copylut_count"
echo "Total vlut modified: $modify_vlut_count"
echo "Total clut modified: $modify_clut_count"
