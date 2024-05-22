def print_tree(path, prefix=''):
    import os

    files = sorted(os.listdir(path))
    for index, file in enumerate(files):
        current_path = os.path.join(path, file)
        if os.path.isdir(current_path):
            new_prefix = '│ ' if index < len(files) - 1 else '  '
            print(f"{prefix}├─┬ {file}")
            print_tree(current_path, prefix + new_prefix)
        else:
            connector = '├──' if index < len(files) - 1 else '└──'
            print(f"{prefix}{connector} {file}")

# Specify the top level directory path here
path = './'
print_tree(path)
