f = open("./i.txt")
input = f.read().splitlines()
f.close()

RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"

RESET = "\033[0m"  # called to return to standard terminal text color


def calculate_area(start, o, max_x, max_y):
    visited = {}
    area = 0

    instructions = [(start)]

    for ins in instructions:
        if (
            ins[0] < 0
            or ins[0] > max_x
            or ins[1] < 0
            or ins[1] > max_y
            or ins in visited
        ):
            continue

        pwnd = True

        for loc in o:
            dis_ocx, dis_ocy = abs(loc[0] - ins[0]), abs(loc[1] - ins[1])
            dis_scx, dis_scy = abs(start[0] - ins[0]), abs(start[1] - ins[1])
            if dis_ocx + dis_ocy <= dis_scx + dis_scy:
                pwnd = False

        visited[ins] = pwnd
        if pwnd:
            area += 1
            dirs = [
                (0, -1),
                (1, -1),
                (1, 0),
                (1, -1),
                (0, 1),
                (-1, 1),
                (-1, 0),
                (-1, 1),
            ]

            for dir in dirs:
                nx, ny = ins[0] + dir[0], ins[1] + dir[1]
                instructions.append((nx, ny))

    # print(start)
    draw_area(visited, o + [start], max_x, max_y)
    return area


def find_largest_finite_area(o):
    finite_areas = []
    norm_areas = []
    max_x, max_y = 0, 0
    for lix, li in enumerate(o):
        x, y = li.strip().split(", ")
        x, y = int(x), int(y)
        norm_areas.append((x, y))

        max_x = x if x > max_x else max_x
        max_y = y if y > max_y else max_y

        lb, rb, bb, tb = 0, 0, 0, 0
        for lix2, li2 in enumerate(o):
            if li != li2:
                x2, y2 = li2.strip().split(", ")
                x2, y2 = int(x2), int(y2)
                if x2 < x:
                    lb = 1
                if x2 > x:
                    rb = 1
                if y2 < y:
                    bb = 1
                if y2 > y:
                    tb = 1
        if (lb + rb + bb + tb) == 4:
            finite_areas.append((int(x), int(y)))

    # draw_map(norm_areas, max_x, max_y)
    b_area = 0
    for area in finite_areas:
        # exclude current point from areas
        comp = [a for a in norm_areas if not a == area]
        s = calculate_area(area, comp, max_x, max_y)
        b_area = s if s > b_area else b_area

    return b_area


def draw_area(visited, map, max_x, max_y, padding=5):
    for y in range(0 - padding, max_y + padding):
        print()
        for x in range(0 - padding, max_x + padding):
            match = False
            vis = False
            for vx, vy in map:
                if vy == y and vx == x:
                    match = True
                    break
            if (x, y) in visited:
                if visited[(x, y)]:
                    vis = True
            if match:
                print(RED + "X" + RESET, end="")
            elif vis:
                print(YELLOW + "O" + RESET, end="")
            else:
                print("-", end="")
    print()


def draw_map(map, max_x, max_y):
    for y in range(0, max_y + 5):
        print()
        for x in range(0, max_x + 5):
            match = False
            for vx, vy in map:
                if vy == y and vx == x:
                    match = True
                    break
            if match:
                print("x", end="")
            else:
                print(".", end="")

    print()


print(find_largest_finite_area(input))
