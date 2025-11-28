#!/bin/bash
set -o errexit
shopt -s expand_aliases

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

trap on_error ERR
function on_error {
    [ -n "$program" ] && {
        rm -f "data/${program}.out.json"
        >&2 echo "Error in \`data/${program}.log\`"
    }
}

function programs {
    jq -r '
        .[]
        | [
            .category + "/" + .path,
            .baseline_commits.LV1.hash,
            .baseline_commits.parser.hash,
            .baseline_commits.interpreter.hash
        ]
        | join(" ")

    ' programs.json
}

prev_LV1_hash=""
prev_parser_hash=""
prev_interpreter_hash=""

# alias make='make -j16'

function handle_programs {
    while IFS= read line; do
        IFS=' ' read program LV1_hash parser_hash interpreter_hash <<< "$line"
        [ -f "data/${program}.out.json" ] && {
            >&2 echo "File already exist: \`data/${program}.out.json\`"
            continue
        }

        echo -n > "data/${program}.log"

        [[ -n "$LV1_hash" && "$LV1_hash" != "$prev_LV1_hash" ]] && {
            git -C ml-tools/monlang checkout -f "$LV1_hash"
            sed -i 's/\btee\b/tee -a/g' ml-tools/monlang/tools/aggregate-libs.mri.sh
            rm -rf ml-tools/monlang/.release
            make -C ml-tools/monlang dist
        } >> "data/${program}.log" 2>&1

        [[ -n "$parser_hash" && "$parser_hash" != "$prev_parser_hash" ]] && {
            git -C ml-tools/monlang-parser checkout -f "$parser_hash"
            sed -i 's/\btee\b/tee -a/g' ml-tools/monlang-parser/tools/aggregate-libs.mri.sh
            make -C ml-tools/monlang-parser/monlang-LV2 lib/montree/dist/montree.a
            rm -rf ml-tools/monlang-parser/.deps
            make -C ml-tools/monlang-parser bin/main.elf
        } >> "data/${program}.log" 2>&1

        [[ -n "$interpreter_hash" && "$interpreter_hash" != "$prev_interpreter_hash" ]] && {
            git -C ml-tools/monlang-interpreter checkout -f "$interpreter_hash"
            sed -i 's/\btee\b/tee -a/g' ml-tools/monlang-interpreter/tools/aggregate-libs.mri.sh
            ln -fs ../monlang-parser ml-tools/monlang-interpreter/lib/monlang-parser
            make -C ml-tools/monlang-interpreter bin/main.elf
        } >> "data/${program}.log" 2>&1

        curl -sS http://127.0.0.1:55555 \
                -F "src=@data/${program}" \
                -F "srcpath=data/${program}" \
            > "data/${program}.out.json" \
            2>> "data/${program}.log"
        >&2 echo "Created file: \`data/${program}.out.json\`"

        prev_LV1_hash="$LV1_hash"
        prev_parser_hash="$parser_hash"
        prev_interpreter_hash="$interpreter_hash"
        break
    done
}

# programs | handle_programs
handle_programs
