#!/bin/bash

input="$(< /dev/stdin)"

echo -n "prog: "
jq -r '.prog' <<< "$input"
echo

echo -n "prog_exitcode: "
jq -r '.prog_exitcode' <<< "$input"
echo

echo 'out/traceback.txt: ```'
jq -r '.out."traceback.txt"' <<< "$input" | awk '{print "\t"$0;}'
echo '```'
echo

echo 'out/console.txt: ```'
jq -r '.out."console.txt"' <<< "$input" | awk '{print "\t"$0;}'
echo '```'
echo

echo 'out/LV1.ast.txt: ```'
jq -r '.out."LV1.ast.txt"' <<< "$input" | awk '{print "\t"$0;}'
echo '```'
echo

echo 'out/LV2.ast.txt: ```'
jq -r '.out."LV2.ast.txt"' <<< "$input" | awk '{print "\t"$0;}'
echo '```'
echo

echo -n "out/LV1.tokens.json: "
jq -r --tab '.out."LV1.tokens.json"' <<< "$input"
echo

echo -n "out/LV2.tokens.json: "
jq -r --tab '.out."LV2.tokens.json"' <<< "$input"
