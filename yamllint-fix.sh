#!/bin/bash

fix_yaml() {
    local filename=$1
    local fixes=()
    local last_line=$(tail -n1 "$filename" | tr -d '\n\r')

    if ! head -n1 "$filename" | grep -q '^\-\-\-$'; then
        echo '---' > "$filename.tmp"
        cat "$filename" >> "$filename.tmp"
        mv "$filename.tmp" "$filename"
        fixes+=("Start of file: { original: \"\", fixed: \"--- added\" }")
    fi

    # Correct indentation
    sed -i 's/^\t/  /g' "$filename"
    sed -i 's/^  $/  /g' "$filename"

    # Fix trailing spaces
    # while IFS= read -r line || [[ -n "$line" ]]; do
    #     key=$(echo "$line" | cut -d':' -f1)
    #     value=$(echo "$line" | cut -d':' -f2-)
    #     fixed_value=$(echo "$value" | sed 's/[[:space:]]*$//')
    #     if [[ "$fixed_value" != "$value" ]]; then
    #         fixes+=("$key: { original: \"$value\", fixed: \"$fixed_value\" }")
    #     fi
    #     echo "$key: $fixed_value"
    # done < "$filename" > "$filename.tmp"

    # mv "$filename.tmp" "$filename"
    # echo "Fixed YAML file: $filename"
    sed -i -E 's/[[:space:]]+$//; s/ *: */: /' "$filename"

    echo "Fixed YAML file: $filename"
    # printf '%s\n' "${fixes[@]}"
}

process_files() {
    local file_paths=("$@")
    declare -A all_fixes=()  # Associative array to store fixes for all files

    for filepath in "${file_paths[@]}"; do
        # Check if filepath is the file to be ignored
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
