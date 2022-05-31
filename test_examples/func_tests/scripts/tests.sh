#!/bin/bash

data_path="../data"
app="./../../app.exe"
converter="./../../../drema_converter.exe"
comparator="./comparator.sh"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ ! -f "$converter" ]; then
    echo "Converter not found on way $converter!"
    exit 1
fi

if [ ! -f "$app" ]; then
    echo "App not found on way $app!"
    exit 1
fi

test_in_raw=$(find $data_path -name "test_[0-9][0-9]_in.txt" | sort | tr '\n' ' ')
test_expect_raw=$(find $data_path -name "test_[0-9][0-9]_expect.txt" | sort | tr '\n' ' ')

IFS=' ' read -r -a test_in <<< "$test_in_raw"
IFS=' ' read -r -a test_expect <<< "$test_expect_raw"

test_in_c=${#test_in[@]}
test_expect_c=${#test_expect[@]}
failed=0

if [ "$test_in_c" -ne "$test_expect_c" ]; then
    echo "In and Expect files count not equal! Aborting tests!"
    exit 1
fi

echo "Starting tests:"

for i in "${!test_in[@]}"; do
    test=${test_in[$i]}
    test_num=${test%_*}
    echo $"Test $test_num"
    $converter -t -T int -o "${test_num}_in.bin" "${test_num}_in.txt" 1>/dev/null
    $app "${test_num}_in.bin" "${test_num}_out.bin"
    $converter -b -T int -o "${test_num}_out.txt" "${test_num}_out.bin" 1>/dev/null
    if $comparator "${test_num}_out.txt" "${test_expect[$i]}"; then
        echo -e "TEST: ${GREEN}PASSED${NC}"
    else
        echo -e "TEST: ${RED}FAILED${NC}"
        failed=$((failed+1))
    fi
    rm "${test_num}_in.bin" "${test_num}_out.txt" "${test_num}_out.bin"
done
