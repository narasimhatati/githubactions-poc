#!/bin/bash

count=0
while IFS= read -r file; do
    ((count++))
    echo "Modified file: $file"
    git diff -- "$file"
done < <(git diff --name-only)

echo "Total number of modified files: $count"
