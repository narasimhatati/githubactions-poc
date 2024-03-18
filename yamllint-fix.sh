#!/bin/bash

fix_yaml() {
    local filename=$1
    local fixes=()
    local last_line=$(tail -n1 "$filename" | tr -d '\n\r')

    # Add a newline at the end of the file if missing
    if [ "$last_line" != "" ]; then
        echo >> "$filename"
        fixes+=("End of file: { original: \"Missing newline\", fixed: \"Added newline\" }")
    fi

    # Correct indentation
    sed -i 's/^\t/  /g' "$filename"  # Replace tabs with 2 spaces
    sed -i 's/^  $/  /g' "$filename"  # Remove excess spaces

    # Fix trailing spaces
    while IFS= read -r line || [[ -n "$line" ]]; do
        key=$(echo "$line" | cut -d':' -f1)
        value=$(echo "$line" | cut -d':' -f2-)
        fixed_value=$(echo "$value" | sed 's/[[:space:]]*$//')
        if [[ "$fixed_value" != "$value" ]]; then
            fixes+=("$key: { original: \"$value\", fixed: \"$fixed_value\" }")
        fi
        echo "$key: $fixed_value"
    done < "$filename" > "$filename.tmp"

    mv "$filename.tmp" "$filename"
    echo "Fixed YAML file: $filename"
    printf '%s\n' "${fixes[@]}"
}

process_files() {
    local file_paths=("$@")
    declare -A all_fixes=()  # Associative array to store fixes for all files

    for filepath in "${file_paths[@]}"; do
        fixes=$(fix_yaml "$filepath")
        if [ -n "$fixes" ]; then
            all_fixes["$filepath"]=$fixes
        fi
    done

    for key in "${!all_fixes[@]}"; do
        printf 'File: %s\n' "$key"
        for fix in "${all_fixes[$key]}"; do
            printf '  %s\n' "$fix"
        done
    done
}

yaml_files=$(find . -type f \( -name "*.yaml" -o -name "*.yml" \))
process_files "${yaml_files[@]}"
