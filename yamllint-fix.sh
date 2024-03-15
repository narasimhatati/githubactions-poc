#!/bin/bash

# Run yamllint to check YAML files and capture linting errors
lint_output=$(yamllint -c .yamllint ./**/*.yaml ./**/*.yml)

# Check if there are any linting errors
if [ -n "$lint_output" ]; then
    # Fix indentation issues using yq
    find . -name "*.yaml" -o -name "*.yml" | xargs -I {} sh -c 'yq eval "." -i {}'

    # Remove trailing spaces using yq
    find . -name "*.yaml" -o -name "*.yml" | xargs -I {} sh -c 'yq eval "del(. *.*  | select(type == \"string\" and test(\"\\s\$\")))" -i {}'
fi
