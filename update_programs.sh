#!/bin/bash
set -o errexit
set -o nounset

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

INDENT_SIZE=4
indent=0

function print {
    local str="$1"

    spaces=""
    for ((i = 0; i < INDENT_SIZE * indent; ++i)); do
        spaces+=" "
    done
    echo -n "$spaces"
    
    echo "$str"
}

function print_programs {
    print "["
    indent=$((indent + 1))
        while IFS= read line; do
            IFS=' ' read creationTime category path
            print_program "$creationTime" "$category" "$path"
            :
        done <<< "$creationTimes"
    indent=$((indent - 1))
    print "]"
}

function print_program {
    local creationTime="$1"
    local category="$2"
    local path="$3"
    print "{"
    indent=$((indent + 1))
        print "\"category\": \"$category\","
        print "\"path\": \"$path\","
        print "\"creation_time\": \"$creationTime\","
        print_baseline_commits "$creationTime"
    indent=$((indent - 1))
    print "}"
}

function print_baseline_commits {
    local creationTime="$1"
    print "\"baseline_commits\": {"
    indent=$((indent + 1))
        print_commit LV1 "$creationTime"
        print_commit parser "$creationTime"
        print_commit interpreter "$creationTime"
    indent=$((indent - 1))
    print "}"
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
        ["LV1"]="monlang.git"
        ["parser"]="monlang-parser.git"
        ["interpreter"]="monlang-interpreter.git"
    )
    
    local commit; commit="$(get_commit "${git_dir["$repo"]}" "$creationTime")"
    IFS=' ' read author_date hash title_line <<< "$commit"

    print "${repo}: {"
    indent=$((indent + 1))
        print "\"hash\": \"${hash}\","
        print "\"title_line\": \"${title_line//\"/\\\"}\","
        # convert date with offset => UTC
        print "\"author_date\": \"$(date -d "$author_date" -u +"%Y-%m-%dT%H:%M:%SZ")\""
    indent=$((indent - 1))

    local closing_bracket
    if [ "${git_dir["$repo"]}" == "interpreter" ]; then
        closing_bracket="}"
    else
        closing_bracket="},"
    fi
    print "$closing_bracket"
}

print_programs > programs.json
