#!/bin/bash
set -o errexit
set -o nounset
shopt -s globstar

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

function creatTime {
    local file="$1"
    # git log outputs dates as iso-8601 with offset..
    # .., so we normalize into UTC to make it sortable (lexicographically)
    date -d "$(git log -1 --pretty=format:'%aI' "$file")" -u +"%Y-%m-%dT%H:%M:%SZ"
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_DIR"
# rm -rf bin
mkdir -p bin/in
cd - > /dev/null

cd "${SCRIPT_DIR}/monlang-interpreter"
# rm -f "${SCRIPT_DIR}/creationTimes.txt"
{
for file in bin/in/**; do
    [ -f "$file" ] || continue
    [ "$file" == bin/in/_.ml ] && continue
    mkdir -p "${SCRIPT_DIR}/${file%/*}"
    cp "$file" "${SCRIPT_DIR}/${file}"
    # echo "$(git log -1 --diff-filter=A --follow --pretty=format:'%aI' "$file") $file" \
    echo "$(creatTime "$file") $file"
done
} | sort > "${SCRIPT_DIR}/creationTimes.txt"
cd - > /dev/null
