#!/usr/bin/env sh

scripts_dir=$(dirname $0)

echo Reloading Hyprland...
hyprctl reload
echo Initializing Hyprland...
$scripts_dir/inject_hypr.sh