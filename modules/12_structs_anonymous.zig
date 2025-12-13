const std = @import("std");

pub fn main() void {
    const Foo = struct {};
    std.debug.print("variable: {s}\n", .{@typeName(Foo)});
    std.debug.print("anonymous: {s}\n", .{@typeName(struct {})});
    std.debug.print("function: {s}\n", .{@typeName(List(i32))});

    const anon_struct = .{ .int = @as(u32, 123) };
    std.debug.assert(anon_struct.int == 123);

    const tuple = .{@as(u32, 321)};
    std.debug.assert(tuple[0] == 321);
}

// tuples useful when you return several values
fn divmod(numerator: u32, denominator: u32) struct { u32, u32 } {
    return .{ numerator / denominator, numerator % denominator };
}

fn List(comptime T: type) type {
    return struct {
        x: T,
    };
}
