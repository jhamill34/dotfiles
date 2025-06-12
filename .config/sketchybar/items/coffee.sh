#!/bin/bash

# NOTE: this one requires us to have the hammerspoon caffinated menubar active. 
#  this just mirrors the one put on the MacOS menu bar

coffee_name="Hammerspoon,Item-1"
coffee=(
	label.padding_right=0
	label.padding_left=0
	icon.padding_right=0
	icon.padding_left=0
	padding_right=0
	padding_left=0
	alias.scale=1.2
)
sketchybar --add alias "$coffee_name" right \
	--set "$coffee_name" "${coffee[@]}"

