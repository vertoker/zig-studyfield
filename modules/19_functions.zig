const std = @import("std");

// noreturn means you guarantee that function never return
// Usually for compiler optimization
fn noReturn() noreturn {}

fn hotFunc() void {
    @branchHint(.likely); // this function most likely to call (70-80%)
}
fn neverFunc() void {
    @branchHint(.unpredictable); // you can't understand how often this function will call
}

const Point = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,
};

fn passByValue(point: Point) f32 {
    return point.x + point.y;
}
fn passAnytype(x: anytype) @TypeOf(x) {
    return x + 42;
}
fn passAnytypeFilter(x: anytype) @TypeOf(x) {
    std.debug.assert(@typeInfo(x)); // TODO
    return x + 42;
}

// Function like in C++ can be force inlined, it's very useful for optimization 1-lined functions inside structs
inline fn foo(a: i32, b: i32) i32 {
    std.debug.print("runtime a = {} b = {}", .{ a, b });
    return a + b;
}

// in functions: you can't overload by names, you can't set default compile-time values for params

pub fn main() void {
    std.debug.assert(@typeInfo(@TypeOf(passByValue)).@"fn".params[0].type == Point);
    std.debug.assert(@typeInfo(@TypeOf(passAnytype)).@"fn".is_generic);
    std.debug.print("{}, ", .{@typeInfo(@TypeOf(passAnytype)).@"fn".is_generic});
}
