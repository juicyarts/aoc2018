package d3

import "core:fmt"
import "core:os"
import "core:strings"

import "../util"

solution :: proc() {
	data, ok := os.read_entire_file("./i.txt")
	defer delete(data)

	if !ok {
		panic("Could not read file")
	}

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part_one := "foo"
	fmt.println("P1 Result: ", part_one)

	part_two := "bar"
	fmt.println("P2 Result: ", part_two)
}

main :: proc() {
	util.trace(solution)
}
