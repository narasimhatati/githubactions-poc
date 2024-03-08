#!/bin/bash

count=0
git log --pretty=format:"%h" origin/main..HEAD | while IFS= read -r commit_hash; do
    echo "Commit: $commit_hash"
    git diff --stat $commit_hash^ $commit_hash
    ((count++))
done

echo "Total number of modified files: $count"
