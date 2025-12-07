const std = @import("std");
const builtin = @import("builtin");

pub fn printTopic() void {
    std.debug.print("Is a test build? - {}", .{builtin.is_test});
}
// zig build test --summary all

test "2+2=4!" {
    std.debug.print("2 + 2 is really equals 4?\n", .{});
    std.debug.assert(2 + 2 == 4);
    try std.testing.expect(2 + 2 == 4);
    try std.testing.expectEqual(4, 2 + 2);
}
test "2+2=5? no, skip it" {
    return error.SkipZigTest;
}
test "detect memory leak" {
    var list = std.array_list.Managed(u32).init(std.testing.allocator);
    defer list.deinit(); // comment to see memory leak

    try list.append('☔');
    try std.testing.expect(list.items.len == 1);
}
