const std = @import("std");

pub fn printTopic() void {
    const a = @Vector(4, i32);
    const b = @Vector(4, i32){ 1, 2, 3, 4 };

    std.debug.print("a={any}, b={any}\n", .{ a, b });
}
