#!/bin/bash

remove_count=0
caselist_count=0
modify_height_count=0
modify_width_count=0
modify_parameter_count=0

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

    # Check if folder name contains "360p"
    if [[ "$folder" == *"360p"* ]]; then
        # Copy list_360p_352x288_16b.f to Cmodel/run/caselist directory
        cp "./auto_lsc_config/list_360p_352x288_16b.f" "$caselist_dir/"
        echo "Copied list_360p_352x288_16b.f to $caselist_dir"
        sed -i '27s|list_360p_352x288_16b.f|list_360p_352x288_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '28s|list_360p_352x288_16b.f|list_360p_352x288_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '29s|list_360p_352x288_16b.f|list_360p_352x288_16b.f|' "$folder/vmodel/sim/tb_test.v"
        ((caselist_count++))
    fi

    if [[ "$folder" == *"480p"* ]]; then
        # Copy list_480p_640x480_16b.f to Cmodel/run/caselist directory
        cp "./auto_lsc_config/list_480p_640x480_16b.f" "$caselist_dir/"
        echo "Copied list_480p_640x480_16b.f to $caselist_dir"
        sed -i '27s|list_360p_352x288_16b.f|list_480p_640x480_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '28s|list_360p_352x288_16b.f|list_480p_640x480_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '29s|list_360p_352x288_16b.f|list_480p_640x480_16b.f|' "$folder/vmodel/sim/tb_test.v"
        ((caselist_count++))

        # Perform replacement and count occurrences
        sed -i 's|288|480|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "480" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_height_count+=replace_count))
            echo "Modified height $replace_count times in $folder"
        else
            echo "Failed to modify height in $folder"
        fi
        sed -i 's|352|640|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "640" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_width_count+=replace_count))
            echo "Modified width $replace_count times in $folder"
        else
            echo "Failed to modify width in $folder"
        fi
    fi

    if [[ "$folder" == *"720p"* ]]; then
        # Copy list_720p_1280x720_16b.f to Cmodel/run/caselist directory
        cp "./auto_lsc_config/list_720p_1280x720_16b.f" "$caselist_dir/"
        echo "Copied list_720p_1280x720_16b.f to $caselist_dir"
        sed -i '27s|list_360p_352x288_16b.f|list_720p_1280x720_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '28s|list_360p_352x288_16b.f|list_720p_1280x720_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '29s|list_360p_352x288_16b.f|list_720p_1280x720_16b.f|' "$folder/vmodel/sim/tb_test.v"
        ((caselist_count++))
        # Perform replacement and count occurrences
        sed -i 's|288|720|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "720" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_height_count+=replace_count))
            echo "Modified height $replace_count times in $folder"
        else
            echo "Failed to modify height in $folder"
        fi
        sed -i 's|352|1280|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "1280" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_width_count+=replace_count))
            echo "Modified width $replace_count times in $folder"
        else
            echo "Failed to modify width in $folder"
        fi
    fi

    if [[ "$folder" == *"1080p"* ]]; then
        # Copy list_1080p_1920x1080_16b.f to Cmodel/run/caselist directory
        cp "./auto_lsc_config/list_1080p_1920x1080_16b.f" "$caselist_dir/"
        echo "Copied list_1080p_1920x1080_16b.f to $caselist_dir"
        sed -i '27s|list_360p_352x288_16b.f|list_1080p_1920x1080_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '28s|list_360p_352x288_16b.f|list_1080p_1920x1080_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '29s|list_360p_352x288_16b.f|list_1080p_1920x1080_16b.f|' "$folder/vmodel/sim/tb_test.v"
        ((caselist_count++))
        # Perform replacement and count occurrences
        sed -i 's|288|1080|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "1080" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_height_count+=replace_count))
            echo "Modified height $replace_count times in $folder"
        else
            echo "Failed to modify height in $folder"
        fi
        sed -i 's|352|1920|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "1920" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_width_count+=replace_count))
            echo "Modified width $replace_count times in $folder"
        else
            echo "Failed to modify width in $folder"
        fi
    fi

    if [[ "$folder" == *"2048x1536"* ]]; then
        # Copy list_1080p_1920x1080_16b.f to Cmodel/run/caselist directory
        cp "./auto_lsc_config/list_2k_2048x1536_16b.f" "$caselist_dir/"
        echo "Copied list_2k_2048x1536_16b.f to $caselist_dir"
        sed -i '27s|list_360p_352x288_16b.f|list_2k_2048x1536_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '28s|list_360p_352x288_16b.f|list_2k_2048x1536_16b.f|' "$folder/vmodel/sim/tb_test.v"
        sed -i '29s|list_360p_352x288_16b.f|list_2k_2048x1536_16b.f|' "$folder/vmodel/sim/tb_test.v"
        ((caselist_count++))
        # Perform replacement and count occurrences
        sed -i 's|288|1536|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "1536" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_height_count+=replace_count))
            echo "Modified height $replace_count times in $folder"
        else
            echo "Failed to modify height in $folder"
        fi
        sed -i 's|352|2048|g' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            replace_count=$(grep -o "2048" "$folder/Cmodel/run/config/config.txt" | wc -l)
            ((modify_width_count+=replace_count))
            echo "Modified width $replace_count times in $folder"
        else
            echo "Failed to modify width in $folder"
        fi
    fi

    if [[ "$folder" == *"para1"* ]]; then
        sed -i '3s|.*|LSC__GRID:0.en:1.strength:113,|' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            ((modify_parameter_count++))
            echo "Modified strength in $folder"
        else
            echo "Failed to modify strength in $folder"
        fi
    fi

    if [[ "$folder" == *"para2"* ]]; then
        sed -i '3s|.*|LSC__GRID:0.en:1.strength:49,|' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            ((modify_parameter_count++))
            echo "Modified strength in $folder"
        else
            echo "Failed to modify strength in $folder"
        fi
    fi

    if [[ "$folder" == *"para3"* ]]; then
        sed -i '3s|.*|LSC__GRID:0.en:1.strength:8,|' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            ((modify_parameter_count++))
            echo "Modified strength in $folder"
        else
            echo "Failed to modify strength in $folder"
        fi
    fi

    if [[ "$folder" == *"paramin"* ]]; then
        sed -i '3s|.*|LSC__GRID:0.en:1.strength:0,|' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            ((modify_parameter_count++))
            echo "Modified strength in $folder"
        else
            echo "Failed to modify strength in $folder"
        fi
    fi

    if [[ "$folder" == *"paramax"* ]]; then
        sed -i '3s|.*|LSC__GRID:0.en:1.strength:128,|' "$folder/Cmodel/run/config/config.txt"
        if [ $? -eq 0 ]; then
            ((modify_parameter_count++))
            echo "Modified strength in $folder"
        else
            echo "Failed to modify strength in $folder"
        fi
    fi
done

echo "Total files removed: $remove_count"
echo "Total caselists updated: $caselist_count"
echo "Total heights modified: $modify_height_count"
echo "Total widths modified: $modify_width_count"
echo "Total parameters modified: $modify_parameter_count"