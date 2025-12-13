const std = @import("std");

// order is not guarantees
// ABI-alignment is guaranteed
const Point = struct {
    x: f32,
    y: f32,

    // analog of constructor
    pub fn init(x: f32, y: f32) Point {
        return Point{
            .x = x,
            .y = y,
        };
    }

    // analog of functions in object (this actually is static)
    pub fn dot(self: Point, other: Point) f32 {
        return self.x * other.x + self.y * other.y;
    }
};

// instance of struct
const p: Point = .{
    .x = 1.0,
    .y = 1.0,
};

// struct can have declarations
// struct can have 0 fields (and also have 0 size, this is not like C)
const Empty = struct {
    pub const PI = 3.14;
};

// struct field order is determined by the compiler,
// however, a base pointer can be computed from a field pointer
fn setYBasedOnX(x: *f32, y: f32) void {
    const point: *Point = @fieldParentPtr("x", x);
    point.y = y;
}

// structs can be returned from functions.
fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,
    };
}

// you can declare default values
const Foo = struct {
    a: i32 = 1234,
    b: i32,

    // best practice: remove default values, create default instance with default values
    // partially initialization of values can cause illegal behaviour
    const default: Foo = .{
        .a = 1,
        .b = 2,
    };
};

pub fn main() void {
    std.debug.assert(Empty.PI == 3.14);

    const nothing: Empty = .{};
    std.debug.assert(@sizeOf(Empty) == 0);
    std.debug.assert(@sizeOf(@TypeOf(nothing)) == 0);

    var point = Point{
        .x = 0.1234,
        .y = 0.5678,
    };
    setYBasedOnX(&point.x, 0.9);
    std.debug.assert(point.y == 0.9);

    // Lists

    const list1 = LinkedList(i32){
        .first = null,
        .last = null,
        .len = 0,
    };
    std.debug.assert(list1.len == 0);

    // You can cache type, useful
    const ListOfInts = LinkedList(i32);

    // Also Node not struct, but it's pub struct,
    // you can declare and use it even from function
    var node = ListOfInts.Node{
        .prev = null,
        .next = null,
        .data = 123,
    };
    const list2 = LinkedList(i32){
        .first = &node,
        .last = &node,
        .len = 1,
    };
    std.debug.assert(list2.len == 1);

    const x: Foo = .{
        .b = 5,
    };
    if (x.a + x.b != 1239) {
        comptime unreachable;
    }
}
