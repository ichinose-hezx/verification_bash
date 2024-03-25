#!/bin/bash

remove_files() {
    local dir=$1
    echo "Removing files in $dir"
    rm -rf "$dir"/*
    ((remove_count++))
}

remove_files ./test