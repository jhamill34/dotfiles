#!/bin/bash 

if ! command -v d2 &> /dev/null; then 
    echo "Error: d2 must be installed"
    exit 1
fi

INPUT="$1"
output_dir=$(mktemp -d)
output_file="${output_dir}/${input_name}.svg"

source "$HOME/.config/d2/init.sh"
d2 "$INPUT" "$output_file" -w 
