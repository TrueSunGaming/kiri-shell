#!/usr/bin/env sh

pkill quickshell
pkill qs
rm -rf ~/.cache/quickshell/
qs -p . &