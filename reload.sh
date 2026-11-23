#!/usr/bin/env sh

pkill quickshell
pkill qs
rm -rf ~/.cache/quickshell/

export QML_IMPORT_PATH="$(realpath $(dirname "$0"))/plugin/build"
echo $QML_IMPORT_PATH
qs -p . &