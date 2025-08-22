#!/bin/bash

source="$1"
target_dir="$2"

absolute_source=$(realpath "$1")
filename=$(basename "$1")

date="${filename%%_*}"
rest="${filename#*_}"

absolute_target=$(realpath "${target_dir}")

ln -s "${absolute_source}" "${absolute_target}/${rest}"
