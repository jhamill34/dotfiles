#!/bin/bash 

if ! command -v d2 &> /dev/null; then 
    echo "Error: d2 must be installed"
    exit 1
fi

if ! command -v magick &>/dev/null; then
    echo "Error: magick must be installed"
    exit 1
fi

CLEAN_CACHE=0
CLEAN_GEN=0

while [[ "$1" == -* ]]; do 
    case "$1" in 
        -i|--input)
            INPUT="$2"
            shift 2
            ;;
        --clean-cache)
            CLEAN_CACHE=1
            shift 1
            ;;
        --clean-gen)
            CLEAN_GEN=1
            shift 1
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$INPUT" ]]; then
    INPUT=$(find ./Diagrams -name "*.d2" -type f | fzf)
fi

input_name=$(basename "$INPUT")
name=$(echo "$input_name" | cut -d. -f 1)
dir=$(dirname "$INPUT")

mkdir -p "${dir}/gen"
if [[ $CLEAN_CACHE == 1  ]]; then 
    find "$HOME/.cache/nvim/snacks/image" -name "*${name}*" -type f -print0 | while IFS= read -r -d $'\0' f; do 
        echo "info: removing $f"

        rm "$f"
    done
fi

source "$HOME/.config/d2/init.sh"
d2 "$INPUT" - | magick svg:- "${dir}/gen/${name}.png"



