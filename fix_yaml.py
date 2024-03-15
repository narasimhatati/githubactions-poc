import glob
import yaml

def fix_yaml(filename):
    try:
        fixes = {}
        with open(filename, 'r') as file:
            data = yaml.safe_load(file)

        for key, value in data.items():
            if isinstance(value, str):
                fixed_value = value.rstrip()
                if fixed_value != value:
                    fixes[key] = {'original': value, 'fixed': fixed_value}
                data[key] = fixed_value

        with open(filename, 'w') as file:
            yaml.dump(data, file, default_flow_style=False)
            print(f"Fixed YAML file: {filename}")

        return fixes

    except Exception as e:
        print(f"Error fixing YAML file {filename}: {e}")
        return None

def process_files(file_paths):
    all_fixes = {}
    for filepath in file_paths:
        fixes = fix_yaml(filepath)
        if fixes:
            all_fixes[filepath] = fixes

    return all_fixes

if __name__ == "__main__":
    yaml_files = glob.glob('**/*.yaml', recursive=True) + glob.glob('**/*.yml', recursive=True)
    all_fixes = process_files(yaml_files)
