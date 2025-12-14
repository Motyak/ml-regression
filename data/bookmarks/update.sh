#!/bin/bash
set -o errexit

[ "${BASH_SOURCE[0]}" == "$0" ] || {
    >&2 echo "script must be executed, not sourced"
    return 1
}

function fail {
    local msg="$1"
    >&2 echo "$msg"
    exit 1
}

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

firefox_db="$(find ~/.mozilla/firefox/ -name 'places.sqlite')"
[ "$(wc -l <<< "$firefox_db")" -eq 1 ] || fail "invalid firefox db: \`$firefox_db\`"

sql_req="$(cat << EOF
SELECT moz_bookmarks.lastModified, moz_bookmarks.title, moz_places.url
FROM moz_bookmarks JOIN moz_places ON moz_bookmarks.fk = moz_places.id
WHERE parent = 921
ORDER BY lastModified ASC
;
EOF
)"

sqlite3_out="$(sqlite3 "$firefox_db" -cmd ".separator ' '" "$sql_req")"

while IFS= read line; do
    # echo "$line"
    IFS=' ' read lastModified title url <<< "$line"
    encoded_src="$(perl -ne 'print "$1\n" if /&src=(.*)/' <<< "$url")"
    decoded_src="$(php -r 'echo urldecode($argv[1]);' "$encoded_src")"
    echo "$decoded_src" > "${SCRIPT_DIR}/ml_progs/${title}"
    echo "$(date -d @"${lastModified:0:-6}" -u +"%Y-%m-%dT%H:%M:%SZ") ml_progs/${title}"
    #                               ^^^^^ convert µs to s => remove 6 trailing digits
    :
done <<< "$sqlite3_out" > "${SCRIPT_DIR}/creationTimes.txt"
