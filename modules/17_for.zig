const std = @import("std");

pub fn main() void {
    // nested break
    var count: usize = 0;
    outer: for (1..6) |_| {
        for (1..6) |_| {
            count += 1;
            break :outer;
        }
    }
    std.debug.assert(count == 1);

    // nested continue
    count = 0;
    outer: for (1..9) |_| {
        for (1..6) |_| {
            count += 1;
            continue :outer;
        }
    }
    std.debug.assert(count == 8);

    // inline for, recommend to use in comptime
    var sum: usize = 0;
    inline for (0..10) |index| {
        sum += index;
    }
    std.debug.print("{}\n", .{sum});
}
