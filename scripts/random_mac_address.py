#!/usr/bin/env python3
import random

CHARS = ['a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9']


def rmac():
    return ':'.join(
        random.choice(CHARS) + random.choice(CHARS)
        for _ in range(6)
    )


print(rmac())
