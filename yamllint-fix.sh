#!/bin/bash
lint_output=$(yamllint -c .yamllint ./**/*.yaml ./**/*.yml)
if [ -n "$lint_output" ]; then
    find . -name "*.yaml" -o -name "*.yml" | xargs -I {} sh -c 'yq eval "." -i {}'
    find . -name "*.yaml" -o -name "*.yml" | xargs -I {} sh -c 'yq eval "del(. *.*  | select(type == \"string\" and test(\"\\s\$\")))" -i {}'
fi
