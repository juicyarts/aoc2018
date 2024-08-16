package util

import "core:c/libc"
import "core:fmt"
import "core:log"
import "core:mem"

reset_tracking_allocator :: proc(a: ^mem.Tracking_Allocator) -> bool {
	err := false

	for _, value in a.allocation_map {
		fmt.printf("%v: Leaked %v bytes\n", value.location, value.size)
		err = true
	}

	mem.tracking_allocator_clear(a)
	return err
}

trace :: proc(fn: proc()) {
	default_allocator := context.allocator
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, default_allocator)
	context.logger = log.create_console_logger()
	context.allocator = mem.tracking_allocator(&tracking_allocator)

	fn()

	if reset_tracking_allocator(&tracking_allocator) {
		libc.getchar()
	}
}
