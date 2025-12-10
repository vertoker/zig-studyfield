const std = @import("std");

// extern make struct behave absolutely like in C, for matching C ABI
const Point = extern struct {
    x: f32,
    y: f32,
};

// packed struct make everything merge as close as possible
const Foo = packed struct {
    x: u5, // 5 bits
    y: u5, // 5 bits
    z: u5, // 5 bits
    ok: bool, // 1 bit
};
// regular struct withour packed don't make it merge
const Foo2 = struct {
    x: u5, // 1 byte or 3 junk bits
    y: u5, // 1 byte or 3 junk bits
    z: u5, // 1 byte or 3 junk bits
    ok: bool, // 1 byte or 7 junk bits
};

const foo = Foo{
    .x = 1,
    .y = 2,
    .z = 3,
    .ok = true,
};

// also you can set alignment by hands
const Point2 = struct {
    x: f32 align(64),
    y: f32 align(2),
};

// also you can set value in which struct will be stored
const Point3 = packed struct(u64) {
    x: f32 = 0,
    y: f32 = 0,
};

// https://ziglang.org/documentation/0.15.2/#toc-extern-struct
pub fn printTopic() void {
    std.debug.assert(@sizeOf(Foo) == 2);
    std.debug.assert(@sizeOf(Foo2) == 4);
    std.debug.print("packed={}, regular={}, ", .{ @sizeOf(Foo), @sizeOf(Foo2) });

    // ptr to item inside struct
    const ptr = &foo.y;
    std.debug.assert(ptr.* == 2);

    // however, this ptr not regular, it's aligned ptr. You can't cast it to regular
    // error: expected type '*const u3', found '*align(1:3:1) u3'
    // it's because of C ABI compatibility, ptr to non-byle aligned value is only Zig feature

    // offsets
    std.debug.assert(@bitOffsetOf(Foo, "x") == 0);
    std.debug.assert(@bitOffsetOf(Foo, "y") == 5);
    std.debug.assert(@bitOffsetOf(Foo, "z") == 10);
    std.debug.assert(@bitOffsetOf(Foo, "ok") == 15);

    // take bit offset, divide to 8, floor to min and you get it
    std.debug.assert(@offsetOf(Foo, "x") == 0);
    std.debug.assert(@offsetOf(Foo, "y") == 0);
    std.debug.assert(@offsetOf(Foo, "z") == 1);
    std.debug.assert(@offsetOf(Foo, "ok") == 1);

    std.debug.print("size of Point2={}, x={}, y={}\n", .{
        @sizeOf(Point2),
        @bitOffsetOf(Point2, "x"),
        @bitOffsetOf(Point2, "y"),
    });
    std.debug.assert(@sizeOf(Point2) == 64);
    std.debug.assert(@bitOffsetOf(Point2, "x") == 0);
    std.debug.assert(@bitOffsetOf(Point2, "y") == 32);

    const point: Point3 = @bitCast(@as(u64, 0));
    std.debug.print("size={}, x={}\n", .{ @sizeOf(Point3), point.x });
}
