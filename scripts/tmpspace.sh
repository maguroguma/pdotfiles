#!/bin/sh

# quoted by: https://github.com/fabon-f/dotfiles/blob/master/bin/tmpspace
#
# Original idea: http://qiita.com/kawaz/items/2b6ef25f63a4f5300e84

set -eu

usage() {
    cat <<USAGE

$cmd - Make a temporary and volatile workspace

Usage
    $cmd [-h|--help]
    $cmd [--verbose]

Description
    This command make a temporary directory and start a new shell on it. If you want to finish work and delete the directory, you can execute "exit" command.
    If the new shell terminate abnormaly, a path of the directory will be printed and the directory will remain.

    -h --help   Print this usage
    --verbose   Enable verbose mode.

USAGE
}

tmpspace() {
    _PID=$$;
    _PPID=$(ps -o ppid -p "$_PID" | tail -n 1);
    shell=$(ps -p $_PPID -o comm | tail -n 1)
    if ! command -v "$shell" 1> /dev/null 2> /dev/null; then
        shell=$(echo "$shell" | cut -c 2-)
    fi


    d=$(mktemp -d) && cd "$d" || exit 1
    set +e
    "$shell"
    s=$?
    set -e
    if [ "$s" = 0 ]; then
        rm -rf "$d"
    else
        echo "Directory '$d' still exists." >&2
    fi
    exit $s
}

main() {
    cmd=$(basename "$0")
    for arg in "$@"
    do
        case $arg in
            --help) usage; exit 0;;
            -h) usage; exit 0;;
            --verbose) set -x;;
        esac
    done
    tmpspace
}
main "$@"
