import glob
import yaml

def fix_yaml(filename):
    try:
        fixes = {}  # Dictionary to store fixes for this file
        with open(filename, 'r') as file:
            data = yaml.safe_load(file)

        # Perform fixes on data here
        for key, value in data.items():
            if isinstance(value, str):
                fixed_value = value.rstrip()
                if fixed_value != value:
                    fixes[key] = {'original': value, 'fixed': fixed_value}
                data[key] = fixed_value

        with open(filename, 'w') as file:
            yaml.dump(data, file, default_flow_style=False)
            print(f"Fixed YAML file: {filename}")

        return fixes  # Return the fixes made for this file

    except Exception as e:
        print(f"Error fixing YAML file {filename}: {e}")
        return None  # Return None if an error occurs

def process_files(file_paths):
    all_fixes = {}  # Dictionary to store fixes for all files
    for filepath in file_paths:
        fixes = fix_yaml(filepath)
        if fixes:
            all_fixes[filepath] = fixes  # Store fixes for this file

    return all_fixes

if __name__ == "__main__":
    yaml_files = glob.glob('**/*.yaml', recursive=True) + glob.glob('**/*.yml', recursive=True)
    all_fixes = process_files(yaml_files)

    # Print all fixes made
    for filepath, fixes in all_fixes.items():
        print(f"Fixes applied to file: {filepath}")
        for key, fix_data in fixes.items():
            print(f"- Key: {key}")
            print(f"  Original value: {fix_data['original']}")
            print(f"  Fixed value: {fix_data['fixed']}")
