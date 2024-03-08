#!/bin/bash

# count=0
# git diff --name-only | while IFS= read -r file; do
#     ((count++))
#     echo "Modified file: $file"
#     git diff -- "$file"
# done

# echo "Total number of modified files: $count"

count=0
git log --pretty=format:"%h" origin/main..HEAD | while IFS= read -r commit_hash; do
    if [ -n "$prev_commit_hash" ]; then
        echo "Changes between $prev_commit_hash and $commit_hash:"
        git diff --stat --color=always $prev_commit_hash $commit_hash
        git diff --color=always $prev_commit_hash $commit_hash
        count=$((count+1))
    fi
    prev_commit_hash=$commit_hash
done

echo "Total number of modified files: $count"
