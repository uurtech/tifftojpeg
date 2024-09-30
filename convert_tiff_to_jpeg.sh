#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it and try again."
    exit 1
fi

# Check if input directory is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_directory>"
    exit 1
fi

# Set input directory
input_dir="$1"

# Check if input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory does not exist."
    exit 1
fi

# Create output directory
output_dir="${input_dir}_jpg"
mkdir -p "$output_dir"

# Convert images to JPG
for image_file in "$input_dir"/*; do
    if [ -f "$image_file" ]; then
        base_name=$(basename "$image_file")
        extension="${base_name##*.}"
        filename="${base_name%.*}"
        
        # Convert extension to lowercase for comparison
        extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
        
        # Skip if the file is already a JPG
        if [ "$extension_lower" = "jpg" ] || [ "$extension_lower" = "jpeg" ]; then
            echo "Skipping: $image_file (already JPG)"
            continue
        fi
        
        jpg_file="$output_dir/${filename}.jpg"
        convert "$image_file" "$jpg_file"
        echo "Converted: $image_file -> $jpg_file"
    fi
done

echo "Conversion complete. JPG files are in: $output_dir"