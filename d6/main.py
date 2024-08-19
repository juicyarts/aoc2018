f = open("./i.txt")
input = f.read().splitlines()
f.close()


def calc(s, o, max_x, max_y, dist=False, mem={}):
    area, queue = 0, [s]
    for t in queue:
        if t in mem:
            continue

        mem[t] = (
            (sum(map(lambda loc: abs(loc[0] - t[0]) + abs(loc[1] - t[1]), o)) < dist)
            if dist
            else (
                min(map(lambda loc: abs(loc[0] - t[0]) + abs(loc[1] - t[1]), o))
                > abs(s[0] - t[0]) + abs(s[1] - t[1])
            )
        )

        if t[0] < 0 or t[0] > max_x or t[1] < 0 or t[1] > max_y or not mem[t]:
            if mem[t]:
                return 0
            continue

        area += 1
        for dir in [
            (0, -1),
            (1, 0),
            (0, 1),
            (-1, 0),
        ]:
            queue.append((t[0] + dir[0], t[1] + dir[1]))
    return area


def find_largest_finite_area(o):
    areas, mx, my = [], 0, 0
    for li in o:
        x, y = map(int, li.strip().split(", "))
        mx, my = max(mx, x), max(my, y)
        areas.append((x, y))
    return max(
        map(
            lambda area: calc(
                area, [a for a in areas if not a == area], mx, my, False, {}
            ),
            areas,
        )
    )


def find_largest_area_in_distance(o, near):
    areas, mem, mx, my, c = [], {}, 0, 0, 0
    for li in o:
        x, y = map(int, li.strip().split(", "))
        mx, my = max(mx, x), max(my, y)
        areas.append((x, y))
    for x in range(0, mx):
        for y in range(0, my):
            c = max(calc((x, y), areas, mx, my, near, mem), c)
    return c


print(find_largest_finite_area(input))
print(find_largest_area_in_distance(input, 10000))
