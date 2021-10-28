import itertools


def chunked(iterable, max_size):
    i = iter(iterable)
    while result := list(itertools.islice(i, max_size)):
        yield result
