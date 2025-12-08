#!/bin/bash
set -o errexit -o errtrace -o pipefail
shopt -s globstar

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

trap on_error ERR
function on_error {
    [ -n "$program" ] && {
        rm -f "${SCRIPT_DIR}/baseline/${program}.out.txt"
    }
}

function json_to_out {
    "${SCRIPT_DIR}/json_to_out.sh"
}

cd "${SCRIPT_DIR}/data"
for program in **/*; do
    [ -f "$program" ] || continue
    [[ "$program" != *.out.json ]] || continue
    [[ "$program" != *.log ]] || continue
    [[ "$program" != */update.sh ]] || continue
    [[ "$program" != */creationTimes.txt ]] || continue
    # [[ "$program" == *quicksort* ]] || continue
    # echo "$program"; continue
    mkdir -p "$(dirname "${SCRIPT_DIR}/baseline/${program}.out.txt")"

   curl -sS http://127.0.0.1:55555 \
            -F "src=@${program}" \
            -F "srcpath=data/${program}" \
        | json_to_out \
        > "${SCRIPT_DIR}/baseline/${program}.out.txt"

    >&2 echo "Created file: \`${SCRIPT_DIR}/baseline/${program}.out.txt\`"
    # break
done

cd "${SCRIPT_DIR}"
{
    echo "monlang"
    git -C ml-tools/monlang log -1 --pretty=format:'%aI %H %s'
    echo -e "\n"

    echo "monlang-parser"
    git -C ml-tools/monlang-parser log -1 --pretty=format:'%aI %H %s'
    echo -e "\n"

    echo "monlang-interpreter"
    git -C ml-tools/monlang-interpreter log -1 --pretty=format:'%aI %H %s'
    echo -e "\n"

    echo "monlang-server"
    git -C ml-tools/monlang-server log -1 --pretty=format:'%aI %H %s'
    echo
    :
} > "baseline/regression.txt"
