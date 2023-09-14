#!/bin/bash

# 1st argument passed will be the target directory otherwise it will be current directory
target_directory="${1:-.}"

# List all files in the target directory and subdirectories
files_list=($(find "$target_directory" -type f))

# List of file types to be backed up
file_types=('ma' 'mb' 'drp' 'prproj' 'nk' 'aep' 'ai' 'psd')

# Get the date in format YYYY_MM_DD_HH_MM_SS
formatted_date=$(date +"%Y_%m_%d_%H_%M_%S")

# The directory to copy the files will be the target_directory/data
file_copy_directory="$target_directory/$formatted_date"

# Create the directory for file copies
mkdir -p "$file_copy_directory"

# Create a log file to keep track of which files were copied
log_file="$file_copy_directory/$formatted_date.log"

# Append the text to the log file: -e to interpret newline characters
echo -e "Files backed up:\n" >> $log_file

# Iterate over every file in files_list
for file in "${files_list[@]}"; do\
    # Extract the file extension
    file_extension=$(echo "$file" | awk -F '.' '{print $NF}')

    # If the file extension is one of the allowed file types
    if [[ " ${file_types[*]} " =~ " $file_extension " ]]; then
        # Copy the file to the created directory
        cp "$file" "$file_copy_directory"
        # Append the name of the file to the log file
        echo $file >> $log_file
    fi
done

# Change the working directory to the parent directory of the files you want to compress
cd "$(dirname "$file_copy_directory")"

# Create a compressed tar.gz file with the contents of the directory
tar -czvf "$target_directory/$formatted_date.tar.gz" "$(basename "$file_copy_directory")"

# Delete the uncompressed folder
rm -r "$file_copy_directory"