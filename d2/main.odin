package d2

import "../util"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

count_letters :: proc(input: string) -> (int, int) {
	cm := []map[rune]int{{}, {}, {}}
	defer delete_map(cm[0])
	defer delete_map(cm[1])
	defer delete_map(cm[2])

	for c in input {
		cm[2][c] += 1
		if cm[2][c] > 2 {
			cm[1][c] = 1
			delete_key(&cm[0], c)
		} else if cm[2][c] > 1 {
			cm[0][c] = 1
		}
	}

	return len(cm[0]) > 0 ? 1 : 0, len(cm[1]) > 0 ? 1 : 0
}

calc_checksum :: proc(lines: []string) -> int {
	two, three := 0, 0
	for i := 0; i < len(lines); i += 1 {
		tw, th := count_letters(strings.trim_space(lines[i]))
		two += tw
		three += th
	}

	return two * three
}

compare_lines :: proc(a: string, b: string) -> (string, bool) {
	m := [dynamic]rune{}
	defer delete_dynamic_array(m)

	for c, i in a {
		if a[i] == b[i] {
			append(&m, c)
		}
	}

	if len(m) >= len(a) - 1 {
		return utf8.runes_to_string(m[:]), true
	}

	return "", false
}

find_similar :: proc(lines: []string) -> (sim: string) {
	for i := 0; i < len(lines); i += 1 {
		for j := 0; j < len(lines); j += 1 {
			if i != j {
				if r, s := compare_lines(lines[i], lines[j]); s {
					return r
				}
			}
		}
	}
	return ""
}


solution :: proc() {
	data, ok := os.read_entire_file("./i.txt")
	defer delete(data)

	if !ok {
		panic("Could not read file")
	}

	s := strings.split_lines(strings.trim_space(string(data)))
	part_one := calc_checksum(s)
	fmt.println("P1 Result: ", part_one)

	part_two := find_similar(s)
	fmt.println("P2 Result: ", part_two)
}


main :: proc() {
	solution()
}
