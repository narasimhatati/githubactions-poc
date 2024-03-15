#!/bin/bash

lint_output=$(yamllint -c .yamllint ./**/*.yaml ./**/*.yml)

if [ -n "$lint_output" ]; then
    while IFS= read -r file; do
        yq eval "." -i "$file"
        yq eval "del(. *.*  | select(type == \"string\" and test(\"\\s\$\")))" -i "$file"
    done < <(find . -name "*.yaml" -o -name "*.yml")
fi
