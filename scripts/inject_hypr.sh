#!/usr/bin/env sh

scripts_dir=$(dirname "$0")
injected_content=$(cat $scripts_dir/../external/hyprland.lua)
hyprctl eval $injected_content