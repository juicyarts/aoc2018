package d1

import "core:c/libc"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
import "core:strconv"
import "core:strings"

calculate_frequency :: proc(lines: []string) -> int {
	freq := 0
	for i := 0; i < len(lines); i += 1 {
		n, ok := strconv.parse_int(lines[i])
		if ok {
			freq += n
		}
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

reset_tracking_allocator :: proc(a: ^mem.Tracking_Allocator) -> bool {
	err := false

	for _, value in a.allocation_map {
		fmt.printf("%v: Leaked %v bytes\n", value.location, value.size)
		err = true
	}

	mem.tracking_allocator_clear(a)
	return err
}

main :: proc() {
	default_allocator := context.allocator
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, default_allocator)
	context.logger = log.create_console_logger()
	context.allocator = mem.tracking_allocator(&tracking_allocator)

	data, ok := os.read_entire_file("./i.txt")
	if !ok {
		panic("Could not read file")
	}

	lines := strings.split_lines(string(data))

	part_one := calculate_frequency(lines)
	fmt.println("P1 Result: ", part_one)

	part_two := first_frequency_repetition(lines)
	fmt.println("P2 Result: ", part_two)

	delete(data)
	delete(lines)

	if reset_tracking_allocator(&tracking_allocator) {
		libc.getchar()
	}
}
