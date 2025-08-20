#!/bin/bash 

if ! command -v d2 &> /dev/null; then 
    echo "Error: d2 must be installed"
    exit 1
fi

if ! command -v fzf &> /dev/null; then 
    INPUT="$1"
else 
    INPUT=$(find ./Diagrams -name "*.d2" -type f | fzf)
fi

output_dir=$(mktemp -d)
output_file="${output_dir}/${input_name}.svg"

source "$HOME/.config/d2/init.sh"
d2 "$INPUT" "$output_file" -w 
