#!/usr/bin/env sh

pkill quickshell
pkill qs
rm -rf ~/.cache/quickshell/

kiri_path=$(dirname "$0")
export QML_IMPORT_PATH="$kiri_path/plugin/build"
qs -p $kiri_path &