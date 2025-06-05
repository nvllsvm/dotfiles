#!/usr/bin/env python3
import random
import string


def rmac():
    return ":".join(
        random.choice(string.hexdigits) + random.choice(string.hexdigits)
        for _ in range(6)
    ).lower()


print(rmac())
