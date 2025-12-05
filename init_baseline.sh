#!/bin/bash
shopt -s globstar
set -o errexit

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

function json_to_out {
    "${SCRIPT_DIR}/json_to_out.sh"
}

cd "${SCRIPT_DIR}/data"
for f in **/*.out.json; do
    [ -f "$f" ] || continue
    mkdir -p "$(dirname "${SCRIPT_DIR}/baseline/${f%.json}.txt")"
    json_to_out < "$f" > "${SCRIPT_DIR}/baseline/${f%.json}.txt"
    # break
done
