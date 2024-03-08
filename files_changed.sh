#!/bin/bash

count=0
git diff --name-only | while IFS= read -r file; do
    ((count++))
    echo "Modified file: $file"
    git diff -- "$file"
done

echo "Total number of modified files: $count"
