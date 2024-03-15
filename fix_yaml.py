import glob
import yaml

def fix_yaml(filename):
    try:
        with open(filename, 'r') as file:
            data = yaml.safe_load(file)

        for key, value in data.items():
            if isinstance(value, str):
                data[key] = value.rstrip()

        with open(filename, 'w') as file:
            yaml.dump(data, file, default_flow_style=False)
            print(f"Fixed YAML file: {filename}")

    except Exception as e:
        print(f"Error fixing YAML file {filename}: {e}")

def process_files(file_paths):
    for filepath in file_paths:
        fix_yaml(filepath)

if __name__ == "__main__":
    yaml_files = glob.glob('**/*.yaml', recursive=True) + glob.glob('**/*.yml', recursive=True)
    process_files(yaml_files)
