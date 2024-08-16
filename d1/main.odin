package d1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

import "../util"

calculate_frequency :: proc(lines: []string) -> int {
	f := 0
	for i := 0; i < len(lines); i += 1 {
		n, ok := strconv.parse_int(lines[i])
		if !ok {
			continue
		}

		f += n
	}

	return f
}

first_frequency_repetition :: proc(lines: []string) -> int {
	f := 0
	v := make(map[int]bool)

	for {
		for i := 0; i < len(lines); i += 1 {
			n, ok := strconv.parse_int(lines[i])
			if !ok {
				continue
			}

			f += n
			if f in v {
				delete(v)
				return f
			}

			v[f] = true
		}
	}
}

solution :: proc() {
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
	util.trace(solution)
}
