#!/bin/bash

fix_yaml() {
    local filename=$1
    local fixes=()
    local last_line=$(tail -n1 "$filename" | tr -d '\n\r')

    # Ensure the file starts with '---'
    if ! head -n1 "$filename" | grep -q '^\-\-\-$'; then
        echo '---' > "$filename.tmp"
        cat "$filename" >> "$filename.tmp"
        mv "$filename.tmp" "$filename"
        fixes+=("Start of file: { original: \"\", fixed: \"--- added\" }")
    fi

    # Correct indentation
    sed -i 's/^\t/  /g' "$filename"
    sed -i 's/^  $/  /g' "$filename"
    sed -i 's/^[[:space:]]\{2,\}/ /g' "$filename"

    # Remove trailing spaces and ensure a single newline at the end of the file
    sed -i -E 's/[[:space:]]+$//; ${/^$/!s/$/\n/}' "$filename"

    # Remove extra empty lines in the middle of the file
    sed -i '/^$/N;/^\n$/D' "$filename"

    # Ensure only one empty line at the end of the file
    if [ "$last_line" != "" ]; then
        echo >> "$filename"
        fixes+=("End of file: { original: \"\", fixed: \"Added newline\" }")
    fi

    # Check for 'new-lines: type: unix' rule
    if ! grep -q 'new-lines:\s*type:\s*unix' "$filename"; then
        fixes+=("new-lines: type: unix rule missing")
    fi

    echo "Fixed YAML file: $filename"
    printf '%s\n' "${fixes[@]}"
}

process_files() {
    local file_paths=("$@")
    declare -A all_fixes=()  # Associative array to store fixes for all files

    for filepath in "${file_paths[@]}"; do
        if [ "$filepath" != "./.github/workflows/yaml-linting.yaml" ]; then
            fixes=$(fix_yaml "$filepath")
            if [ -n "$fixes" ]; then
                all_fixes["$filepath"]=$fixes
            fi
        else
            echo "Skipping file: $filepath"
        fi
    done

    for key in "${!all_fixes[@]}"; do
        printf 'File: %s\n' "$key"
        for fix in "${all_fixes[$key]}"; do
            printf '  %s\n' "$fix"
        done
    done
}

find . -type f \( -name "*.yaml" -o -name "*.yml" \) | while IFS= read -r file; do
    process_files "$file"
done
