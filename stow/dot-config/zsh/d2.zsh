d2_dev() {
    d2 "$1" "$(mktemp -d)/${1:t:r}.svg" -w
}

d2_gen() {
    local out_dir="$PWD/gen/${1:h}"
    mkdir -p "$out_dir"
    d2 "$1" - | rsvg-convert -o "$out_dir/${1:t:r}.png" -
}
compdef "_files -g '*.d2'" d2_dev d2_gen
