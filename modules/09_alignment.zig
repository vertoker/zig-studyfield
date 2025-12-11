const std = @import("std");

pub fn printTopic() void {
    const x: i32 = 1234;
    const align_of_i32 = @alignOf(@TypeOf(x));
    std.debug.print("{}, ", .{align_of_i32});

    const ubyte_as_uint: u8 align(4) = 100;
    const uint: u32 = 100;
    std.debug.assert(ubyte_as_uint == uint);
    std.debug.print("{} == {}\n", .{ ubyte_as_uint, uint });
}

fn derp() align(@sizeOf(usize) * 2) i32 {
    return 1234;
}
fn noop1() align(1) void {}
fn noop4() align(4) void {}
