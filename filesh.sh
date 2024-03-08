#!/bin/bash

count=0
git log --pretty=format:"%h" origin/main..HEAD | while IFS= read -r commit_hash; do
    echo "Commit: $commit_hash"
    git show --stat --color=always $commit_hash
    git show --color=always $commit_hash
    # git diff --stat $commit_hash^ $commit_hash
    count=$((count+1))
done

echo "Total number of modified files: $count"
