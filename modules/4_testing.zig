const std = @import("std");
const builtin = @import("builtin");

pub fn printTopic() void {
    std.debug.print("Is a test build? - {}\n", .{builtin.is_test});
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

test "expectError demo" {
    const expected_error = error.DemoError;
    const actual_error_union: anyerror!void = error.DemoError;

    // `expectError` will fail when the actual error is different than the expected error
    try std.testing.expectError(expected_error, actual_error_union);
}

// TODO move to future allocator module
test "using an allocator" {
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const result = try concat(allocator, "foo", "bar");
    try std.testing.expect(std.mem.eql(u8, "foobar", result));
}

fn concat(allocator: std.mem.Allocator, a: []const u8, b: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, a.len + b.len);
    @memcpy(result[0..a.len], a);
    @memcpy(result[a.len..], b);
    return result;
}

// TODO move to future concurrency module
test "thread local storage" {
    const thread1 = try std.Thread.spawn(.{}, testTls, .{});
    const thread2 = try std.Thread.spawn(.{}, testTls, .{});
    testTls();
    thread1.join();
    thread2.join();
}

threadlocal var x: i32 = 1234;
fn testTls() void {
    std.testing.assert(x == 1234);
    x += 1;
    std.testing.assert(x == 1235);
}
