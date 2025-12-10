const std = @import("std");

// regular union, in-memory representation is not guaranteed
const Payload = union {
    int: i64,
    float: f64,
    boolean: bool,
};

const ComplexTypeTag = enum {
    ok,
    not_ok,
};
// union can be declared with enum, where for every type applies selected type
const ComplexType = union(ComplexTypeTag) {
    ok: u8,
    not_ok: void,

    fn truthy(self: ComplexType) bool {
        return switch (self) {
            ComplexType.ok => |x_int| x_int != 0,
            ComplexType.not_ok => unreachable,
        };
    }
};

// Full C-compatibility with C union, see extern struct
const ExternUnion = extern union {};

// Packed with bytes union, see packed struct
const PackedUnion = packed union {};

// opaque is a type with unknown (non-zero) size and alignment. This used for safe C integration
const What = opaque {};

pub fn printTopic() void {
    var payload: Payload = .{ .float = 0.0 };
    std.debug.print("float={}, ", .{payload.float});
    // payload.int = 1234; // you can't change it because "Only one field can be active at a time"

    payload = .{ .int = 1234 }; // only way - assign absolutely new payload value
    std.debug.print("int={}, ", .{payload.int});

    // union with enum can be used in switch
    var typeTag = ComplexType{ .ok = 255 };
    switch (typeTag) {
        .ok => typeTag.ok +%= 2, // only way to modify it - take ptr
        .not_ok => unreachable,
    }
    std.debug.print("typeTag={}, ", .{typeTag.truthy()});

    // Shadowing: can't hide values

    const PI = 3.14;
    _ = PI; // supress compiler

    {
        //const PI = 3.14; // now allowed, it hides PI from outer scope
        const PI2 = 3.14;
        _ = PI2;
    }

    var y: i32 = 123;
    // you can write regular code in this labeled block for value initialization
    const x = blk: {
        y += 1;
        break :blk y;
    };
    std.debug.assert(x == 124);
    std.debug.assert(y == 124);
}
