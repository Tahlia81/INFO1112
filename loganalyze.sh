#!/bin/bash

if [ $# -eq 0 ]; then
    LOG_DIR="$(pwd)"
else
    LOG_DIR="$1"
fi

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: directory does not exist"
    exit 1
fi

> analysisData.log
> summary.log

total_errors=0
max_errors=0
max_file=" "

find "$LOG_DIR" -type f -name "*.log" -mtime -7 -print0 |
while IFS= read -r -d " " logfile
do

    errors=$(grep -i -c "error" "$logfile")
    filename=$(basename "$logfile")

    echo "$filename: $errors errors"
    echo "$filename: $errors errors" >> analysisData.log

    total_errors=$((total_errors + errors))

    if [ "$errors" -gt "$max_errors" ]; then
        max_errors=$errors
        max_file="$filename"
    fi
done

echo "Total errors: $total_errors"
echo "File with the most errors: $max_file ($max_errors errors)"

echo "Total errors: $total_errors"
echo "File with the most errors: $max_file ($max_errors errors)" >> summary.log

