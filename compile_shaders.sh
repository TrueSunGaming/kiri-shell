#!/usr/bin/env sh

for file in shaders/*.frag; do 
    [ -e "$file" ] || continue
    echo "Compiling $file..."
    (qsb --glsl "100 es,120,150" --hlsl 50 --msl 12 -o "$file.qsb" "$file" && echo "Compiled $file") &
done
wait

./reload.sh