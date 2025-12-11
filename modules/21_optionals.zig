const std = @import("std");

pub fn printTopic() void {
    const int: i32 = 1234;
    const int_optional: ?i32 = null;
    _ = int;

    if (int_optional) |integer| {
        std.debug.print("{}, ", .{integer});
    }

    const type_optional: ?type = null;
    _ = type_optional;
}
