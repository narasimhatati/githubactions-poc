#!/bin/bash

# count=0
# git log --pretty=format:"%h" origin/main..HEAD | while IFS= read -r commit_hash; do
#     echo "Commit: $commit_hash"
#     git show --stat --color=always $commit_hash
#     git show --color=always $commit_hash
#     # git diff --stat $commit_hash^ $commit_hash
#     count=$((count+1))
# done

# echo "Total number of modified files: $count"

count=0

if [ "$GITHUB_EVENT_NAME" == "pull_request" ]; then
    # For PR workflow
    git diff --name-only ${{ github.event.before }}..${{ github.sha }} | while IFS= read -r file; do
        ((count++))
        echo "Modified file: $file"
        git show --stat --color=always ${{ github.sha }}^..${{ github.sha }}
        git diff --color=always ${{ github.sha }}^..${{ github.sha }} -- "$file"
    done
elif [ "$GITHUB_EVENT_NAME" == "push" ] && [ "$GITHUB_REF" == "refs/heads/main" ]; then
    # For post-merge workflow
    git log --pretty=format:"%h" origin/main..HEAD | while IFS= read -r commit_hash; do
        if [ -n "$prev_commit_hash" ]; then
            echo "Changes between $prev_commit_hash and $commit_hash:"
            git diff --stat --color=always $prev_commit_hash $commit_hash
            git diff --color=always $prev_commit_hash $commit_hash
            ((count++))
        fi
        prev_commit_hash=$commit_hash
    done
fi

echo "Total number of modified files: $count"
