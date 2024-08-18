import re
from string import ascii_lowercase as abc

f = open("./i.txt")
input = f.readline()
f.close()


def react(o):
    ns = " "
    for i, c in enumerate(o):
        if c == ns[-1].swapcase():
            ns = ns[:-1]
        else:
            ns += c
    return len(ns.strip())


def reduce(o):
    min = len(o)
    for c in abc:
        norm = re.sub(c, "", o, flags=re.IGNORECASE)
        res = react(norm)
        min = res if res < min else min
    return min


print(react(input.strip()))
print(reduce(input.strip()))
