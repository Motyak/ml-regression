#!/bin/bash
set -o errexit
set -o nounset

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"

# data/parser/update.sh
# data/interpreter/update.sh
# data/bookmarks/update.sh

# we want to sort the resulting json array by:
# 1) creation time
# 2) category + path

function mergeCreationTimes {
    for category in bookmarks interpreter parser; do
        while IFS= read line; do
            # echo "$line"
            IFS=' ' read creationTime path <<< "$line"
            echo "$creationTime $category $path"
            :
        done < "data/${category}/creationTimes.txt"
    done
}

creationTimes="$(mergeCreationTimes | sort)"
# echo "\`$creationTimes\`"

indent=0

function print {
    local str="$1"

    tabs=""
    for ((i = 1; i <= indent; ++i)); do
        tabs+=$'\t'
    done

    echo -n "${tabs}${str}"
}

function println {
    print "${@:-}"
    echo
}

function print_programs {
    println "["
    indent=$((indent + 1))
        local first_it="true"
        while IFS= read line; do
            IFS=' ' read creationTime category path <<< "$line"
            print_program "$creationTime" "$category" "$path" "$first_it"
            first_it="false"
            :
        done <<< "$creationTimes"
        echo
    indent=$((indent - 1))
    println "]"
}

function print_program {
    local creationTime="$1"
    local category="$2"
    local path="$3"
    local first_it="${4:-true}"
    [ "$first_it" != "true" ] && {
        echo ","
    }
    println "{"
    indent=$((indent + 1))
        println "\"category\": \"$category\","
        println "\"path\": \"$path\","
        println "\"creation_time\": \"$creationTime\","
        print_baseline_commits "$creationTime"
    indent=$((indent - 1))
    print "}"
}

function print_baseline_commits {
    local creationTime="$1"
    println "\"baseline_commits\": {"
    indent=$((indent + 1))
        print_commit LV1 "$creationTime"
        print_commit parser "$creationTime"
        print_commit interpreter "$creationTime"
    indent=$((indent - 1))
    println "}"
}

# e.g.: get_commit monlang.git '2025-01-17T17:04:36Z'
# =>
# 2025-11-16T06:00:01+01:00 a33852b824ece4c337eddb392d704ef17b4c7b55 fix tailcall elim
function get_commit {
    local git_dir="$1"
    local creationTime="$2"
    git --git-dir "$git_dir" log -1 --before="$creationTime" --pretty=format:'%aI %H %s'
}

function print_commit {
    local repo="$1"
    local creationTime="$2"

    declare -A git_dir=(
        ["LV1"]="ml-tools/monlang/.git"
        ["parser"]="ml-tools/monlang-parser/.git"
        ["interpreter"]="ml-tools/monlang-interpreter/.git"
    )
    
    local commit; commit="$(get_commit "${git_dir["$repo"]}" "$creationTime")"
    IFS=' ' read author_date hash title_line <<< "$commit"

    println "\"${repo}\": {"
    indent=$((indent + 1))
        println "\"hash\": \"${hash}\","
        println "\"title_line\": \"${title_line//\"/\\\"}\","
        # convert date with offset => UTC, default to linux epoch
        println "\"author_date\": \"$(date -d "${author_date:-@0}" -u +"%Y-%m-%dT%H:%M:%SZ")\""
    indent=$((indent - 1))

    local closing_bracket
    if [ "$repo" == "interpreter" ]; then
        closing_bracket="}"
    else
        closing_bracket="},"
    fi
    println "$closing_bracket"
}

print_programs > programs.json
