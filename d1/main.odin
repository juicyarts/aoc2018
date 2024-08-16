package d1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

import "../util"

calculate_frequency :: proc(lines: []string) -> int {
	freq := 0
	for i := 0; i < len(lines); i += 1 {
		n, ok := strconv.parse_int(lines[i])
		if !ok {
			continue
		}

		freq += n
	}

	return freq
}

first_frequency_repetition :: proc(lines: []string) -> int {
	freq := 0
	visited := make(map[int]bool)

	for {
		for i := 0; i < len(lines); i += 1 {
			n, ok := strconv.parse_int(lines[i])
			if !ok {
				continue
			}

			freq += n
			if freq in visited {
				delete(visited)
				return freq
			}

			visited[freq] = true
		}
	}
}

day_one :: proc() {
	data, ok := os.read_entire_file("./i.txt")
	defer delete(data)

	if !ok {
		panic("Could not read file")
	}

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part_one := calculate_frequency(lines)
	fmt.println("P1 Result: ", part_one)

	part_two := first_frequency_repetition(lines)
	fmt.println("P2 Result: ", part_two)
}

main :: proc() {
	util.trace(day_one)
}
