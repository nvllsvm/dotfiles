import pathlib


def all_paths(root):
    stack = [pathlib.Path(root)]
    paths = []
    while stack:
        for path in stack.pop().iterdir():
            paths.append(path)
            if path.is_dir():
                stack.append(path)
    return paths
