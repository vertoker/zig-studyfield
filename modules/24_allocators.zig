const std = @import("std");

pub fn printTopic() void {
    // https://ziglang.org/documentation/0.15.2/#toc-Choosing-an-Allocator

    // Fixed Buffer Allocatior
    var buffer: [128]u8 = undefined; // no need to deallocate this
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const array = allocator.alloc(u8, 128) catch unreachable;
    array[0] = 255;

    // Arena Allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator2 = arena.allocator();
    const ptr = allocator2.create(u32) catch unreachable;
    std.debug.print("ptr={*}\n", .{ptr});
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
