package d3

import "../util"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:time"

parse_line :: proc(line: string) -> (string, int, int, int, int) {
	s := strings.split(line, " @ ")
	id, pos := s[0], strings.split(s[1], ": ")
	st, of := strings.split(pos[0], ","), strings.split(pos[1], "x")
	x1, y1 := strconv.atoi(st[0]), strconv.atoi(st[1])
	x2, y2 := (x1 - 1) + strconv.atoi(of[0]), (y1 - 1) + strconv.atoi(of[1])
	delete(s)
	delete(st)
	delete(of)
	delete(pos)
	return id, x1, x2, y1, y2
}

calculate_overlaps :: proc(
	x1: int,
	x2: int,
	y1: int,
	y2: int,
	x3: int,
	x4: int,
	y3: int,
	y4: int,
) -> (
	has_overlap: bool,
	overlap_x_start: int,
	overlap_y_start: int,
	overlap_x_end: int,
	overlap_y_end: int,
) {
	x, y, xs, xe, ys, ye, o := 0, 0, x1, y1, x2, y2, false
	if !(x4 < x1 || x3 > x2 || y4 < y1 || y3 > y2) {
		o = true
		xs, xe = x1 > x3 ? x1 : x3, x2 < x4 ? x2 : x4
		ys, ye = y1 > y3 ? y1 : y3, y2 < y4 ? y2 : y4
	}

	return o, xs, ys, xe, ye
}

identify_overlaps :: proc(input: []string) -> (int, string) {
	overlaps := [1000]map[int]int{}
	visited := map[string]int{}
	only := ""

	defer delete_map(visited)

	for line, li in input {
		id, x1, x2, y1, y2 := parse_line(line)
		ov_cnt := 0
		for c_line, cli in input {
			if li != cli {
				cid, cx1, cx2, cy1, cy2 := parse_line(c_line)
				s := strings.concatenate({id, cid})
				s2 := strings.concatenate({cid, id})

				// These strings are leaking but deleting them
				// destroys the purpose of the memoisation.
				// defer delete_string(s2)
				// defer delete_string(s)

				if visited[s] > 0 || visited[s2] > 0 {
					if visited[s] > 1 || visited[s2] > 1 {
						ov_cnt += 1
					}
					continue
				}

				visited[s] = 1
				o, xs, ys, xe, ye := calculate_overlaps(x1, x2, y1, y2, cx1, cx2, cy1, cy2)

				// Poor mans implementation. Rather than iterating over the simulated map
				// one could compare these overlaps to previous ones, that way one can 
				// avoid at least one further nested iteration
				if o {
					visited[s] = 2
					ov_cnt += 1
					for i in xs ..= xe {
						for j in ys ..= ye {
							overlaps[j][i] += 1
						}
					}
				}
			}
		}

		if ov_cnt == 0 {
			only = id
		}
	}

	overlap_count := 0
	for i in 0 ..< 1000 {
		overlap_count += len(overlaps[i])
		delete_map(overlaps[i])
	}

	return overlap_count, only
}

test_data := []string{"#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"}

solution :: proc() {
	data, ok := os.read_entire_file("./i.txt")
	defer delete(data)

	if !ok {
		panic("Could not read file")
	}

	lines := strings.split_lines(strings.trim_space(string(data)))
	defer delete(lines)

	when ODIN_DEBUG {
		part_one, part_two := identify_overlaps(test_data)
		fmt.println("P1 Result: ", part_one)
		fmt.println("P2 Result: ", part_two)
	} else {
		part_one, part_two := identify_overlaps(lines)
		fmt.println("P1 Result: ", part_one)
		fmt.println("P2 Result: ", part_two)
	}
}

main :: proc() {
	when ODIN_DEBUG {
		util.trace(solution)
	} else {
		solution()
	}
}
