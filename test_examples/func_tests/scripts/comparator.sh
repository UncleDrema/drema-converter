#!/bin/bash

f1=$(cat "$1")
f2=$(cat "$2")

if [ -z "$f1" ] && [ -z "$f2" ] || cmp "$1" "$2" 1>/dev/null; then
    exit 0
fi

exit 1
