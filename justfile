qsb_flags := '--glsl "100 es,120,150" --hlsl 50 --msl 12'

export QML_IMPORT_PATH := justfile_directory() / "plugin/build"

default: build

build: shaders plugin

shaders:
    #!/usr/bin/env sh

    for src in {{ justfile_directory() }}/shaders/*.frag; do 
    	[ -f "$src" ] || continue
    	out="$src.qsb"
    	[ ! -f "$out" ] || [ "$src" -nt "$out" ] || continue
    	echo "Compiling $src..."
    	(qsb {{ qsb_flags }} -o "$out" "$src" && echo "Compiled $src") &
    done
    wait

plugin:
    cmake -S plugin -B plugin/build -G Ninja
    cmake --build plugin/build

run_built:
    nohup qs -p {{ justfile_directory() }} >/dev/null 2>&1 &

run: build run_built

kill:
    -killall quickshell
    -killall qs

restart: build kill run_built

cloc:
    cloc {{ justfile_directory() }} --exclude-dir=build,.cache,.vscode --exclude-lang=YAML,Markdown

reset_config: kill
    rm -rf ~/.config/kiri-shell
    just run_no_build
