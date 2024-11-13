# Step O must be finished before step C can begin.

import re

f = open("./i.txt")
input = f.read().splitlines()
f.close()


p = re.compile(r"Step (\S) must be finished before step (\S) can begin.")
cm = {}

for line in input:
    f = p.findall(line)
    c, d = f[0][1], f[0][0]
    if c not in cm:
        cm[c] = {}
    cm[c][d] = 1
    if d not in cm:
        cm[d] = {}


def get_order(s, deps):
    order = ""
    queue = [s]

    for item in queue:
        deps.pop(item, None)
        if item in order:
            continue
        order += item
        for k in deps:
            deps[k].pop(item, None)
        if len(deps) > 0:
            srt = {
                k: v
                for k, v in sorted(
                    deps.items(), key=lambda item: (len(item[1]), item[0])
                )
            }

            queue.append(next(iter(srt)))
    return order


srt = {k: v for k, v in sorted(cm.items(), key=lambda item: (len(item[1]), item[0]))}
seq = get_order(next(iter(srt)), srt)
print(seq)
