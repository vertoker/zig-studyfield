const std = @import("std");

const Value = enum(u2) {
    zero = 0,
    one = 1,
    two = 2,
};

fn isFieldOptional(comptime T: type, field_index: usize) bool {
    // get all fields from type
    const fields = @typeInfo(T).@"struct".fields;
    return switch (field_index) {
        // This prong is analyzed twice with `idx` being a comptime-known value each time
        inline 0, 1 => |idx| @typeInfo(fields[idx].type) == .optional,
        else => unreachable, // return error.IndexOutOfBounds,
    };
}

const Struct1 = struct { a: u32, b: ?u32 };

pub fn printTopic() void {
    const a: u64 = 10;
    const zz: u64 = 103;

    const b = switch (a) {
        // Multiple cases
        1, 2, 3 => 0,

        // Check in slice syntax
        5...100 => 1,

        // You can use labeled block
        101 => blk: {
            const c: u64 = 5;
            break :blk c * 2 + 1;
        },

        // You can use compile-time values
        zz => zz,
        blk: {
            const d: u32 = 5;
            const e: u32 = 100;
            break :blk d + e;
        } => 107,

        else => 9,
    };
    std.debug.assert(b == 1);

    // for enum in switch required to cover ALL possible branches. Use all enum values or else
    const value = Value.one;
    switch (value) {
        Value.zero => {},
        Value.one => {},
        //Value.two => {}, // disable for example
        else => {}, // remove else and you will get compilation error
    }

    // switch can be labeled, you can use. It's equivalent to while true
    // This mechanic is useful for state machines, more clear visible for state switching,
    // and without infinite while(true) loop risk
    sw: switch (@as(i32, 5)) {
        5 => continue :sw 4,

        // `continue` can occur multiple times within a single switch prong.
        2...4 => |v| {
            if (v > 3) {
                continue :sw 2;
            } else if (v == 3) {

                // `break` can target labeled loops.
                break :sw;
            }

            continue :sw 1;
        },

        1 => return,

        else => unreachable,
    }

    std.debug.assert(!isFieldOptional(Struct1, 0));
    std.debug.assert(isFieldOptional(Struct1, 1));
}
