const std = @import("std");

pub fn printTopic() void {
    // nested break
    outer: while (true) {
        while (true) {
            break :outer;
        }
    }

    // nested continue
    var i: usize = 0;
    outer: while (i < 10) : (i += 1) {
        while (true) {
            continue :outer;
        }
    }
}
