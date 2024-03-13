#!/bin/bash

# Initialize copy & modify vlut clut counter
copy_count=0
modify_vlut_count=0
modify_clut_count=0

# Process each folder
for folder in */; do
    # Get folder name
    folder_name=$(basename "$folder")
    
    # Navigate to the config folder
    config_folder="$folder/Cmodel/run/config"
    if [ -d "$config_folder" ]; then
        # Delete specific file
        if [ -f "$config_folder/lsc858_12fracbit_tb.txt" ]; then
            rm "$config_folder/lsc858_12fracbit_tb.txt"
            echo "Deleted lsc858_12fracbit_tb.txt in $config_folder for folder $folder_name"
        fi
        
        # Copy appropriate file based on folder name
        case "$folder_name" in
            *lut1)
                cp "./auto_lsc_config/lsc858_12fracbit_tb.txt" "$config_folder/"
                echo "Copied lsc858_12fracbit_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))                
                ;;

            *lut2)
                cp "./auto_lsc_config/lsc651_12fracbit_tb.txt" "$config_folder/"
                echo "Copied lsc651_12fracbit_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))
                sed -i '31s|lsc858_12fracbit_tb|lsc651_12fracbit_tb|' "$folder/vmodel/sim/tb_test.v"
                if [ $? -eq 0 ]; then
                    echo "Modified tb_test.v in $folder_name for lut2"
                    ((modify_vlut_count++))
                else
                    echo "Failed to modify tb_test.v in $folder_name for lut2"
                fi
                sed -i '58,59s|lsc858_12fracbit_tb.txt|lsc651_12fracbit_tb.txt|' "$folder_name/Cmodel/run/xkisp_HDR.sh"
                if [ $? -eq 0 ]; then
                    echo "Modified xkisp_HDR.sh in $folder_name for lut2"
                    ((modify_clut_count++))
                else
                    echo "Failed to modify xkisp_HDR.sh in $folder_name for lut2"
                fi
                ;;

            *lut3)
                cp "./auto_lsc_config/lsc383_12fracbit_tb.txt" "$config_folder/"
                echo "Copied lsc383_12fracbit_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))
                sed -i '31s|lsc858_12fracbit_tb|lsc383_12fracbit_tb|' "$folder/vmodel/sim/tb_test.v"
                if [ $? -eq 0 ]; then
                    echo "Modified tb_test.v in $folder_name for lut3"
                    ((modify_vlut_count++))
                else
                    echo "Failed to modify tb_test.v in $folder_name for lut3"
                fi
                sed -i '58,59s|lsc858_12fracbit_tb.txt|lsc383_12fracbit_tb.txt|' "$folder_name/Cmodel/run/xkisp_HDR.sh"
                if [ $? -eq 0 ]; then
                    echo "Modified xkisp_HDR.sh in $folder_name for lut3"
                    ((modify_clut_count++))
                else
                    echo "Failed to modify xkisp_HDR.sh in $folder_name for lut3"
                fi
                ;;


            *lutmax)
                cp "./auto_lsc_config/lscmax_tb.txt" "$config_folder/"
                echo "Copied lscmax_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))
                sed -i '31s|lsc858_12fracbit_tb|lscmax_tb|' "$folder/vmodel/sim/tb_test.v"
                if [ $? -eq 0 ]; then
                    echo "Modified tb_test.v in $folder_name for lutmax"
                    ((modify_vlut_count++))
                else
                    echo "Failed to modify tb_test.v in $folder_name for lutmax"
                fi
                sed -i '58,59s|lsc858_12fracbit_tb.txt|lscmax_tb.txt|' "$folder_name/Cmodel/run/xkisp_HDR.sh"
                if [ $? -eq 0 ]; then
                    echo "Modified xkisp_HDR.sh in $folder_name for lutmax"
                    ((modify_clut_count++))
                else
                    echo "Failed to modify xkisp_HDR.sh in $folder_name for lutmax"
                fi
                ;;

            *lutmin)
                cp "./auto_lsc_config/lscmin_tb.txt" "$config_folder/"
                echo "Copied lscmin_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))
                sed -i '31s|lsc858_12fracbit_tb|lscmin_tb|' "$folder/vmodel/sim/tb_test.v"
                if [ $? -eq 0 ]; then
                    echo "Modified tb_test.v in $folder_name for lutmin"
                    ((modify_vlut_count++))
                else
                    echo "Failed to modify tb_test.v in $folder_name for lutmin"
                fi
                sed -i '58,59s|lsc858_12fracbit_tb.txt|lscmin_tb.txt|' "$folder_name/Cmodel/run/xkisp_HDR.sh"
                if [ $? -eq 0 ]; then
                    echo "Modified xkisp_HDR.sh in $folder_name for lutmin"
                    ((modify_clut_count++))
                else
                    echo "Failed to modify xkisp_HDR.sh in $folder_name for lutmin"
                fi
                ;;

            *lutran)
                cp "./auto_lsc_config/lscran_tb.txt" "$config_folder/"
                echo "Copied lscran_tb.txt to $config_folder for folder $folder_name"
                ((copy_count++))
                sed -i '31s|lsc858_12fracbit_tb|lscran_tb|' "$folder/vmodel/sim/tb_test.v"
                if [ $? -eq 0 ]; then
                    echo "Modified tb_test.v in $folder_name for lutran"
                    ((modify_vlut_count++))
                else
                    echo "Failed to modify tb_test.v in $folder_name for lutran"
                fi
                sed -i '58,59s|lsc858_12fracbit_tb.txt|lscran_tb.txt|' "$folder_name/Cmodel/run/xkisp_HDR.sh"
                if [ $? -eq 0 ]; then
                    echo "Modified xkisp_HDR.sh in $folder_name for lutran"
                    ((modify_clut_count++))
                else
                    echo "Failed to modify xkisp_HDR.sh in $folder_name for lutran"
                fi
                ;;

        esac
    fi
done

echo "Total files copied: $copy_count"
echo "Total vlut modified: $modify_vlut_count"
echo "Total clut modified: $modify_clut_count"