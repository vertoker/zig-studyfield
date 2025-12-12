const std = @import("std");

// Zig has 3 ways to cast type from one to another
// 1. Type Coercion - implicit cast. just assign one type value to another related type value, most used
// 2. Explicit cast - cast via buildin functions @...Cast, like @bitCast @alignCast or @ptrCast
// 3. Peer Type Resolution -

pub fn printTopic() void {

    // Way 1 - type coercion

    const a: u8 = 1;
    const b: u16 = a;
    const c: u32 = b;
    const d: u64 = c;
    const e: u128 = d;
    _ = e;

    foo(a);

    const b3: u16 = @as(u16, a);
    _ = b3;

    const a4: i32 = 1;
    const b4: *const i32 = &a4;
    _ = b4;

    // check 08_pointers.zig file, you find 4 types of pointers
    // you can cast downsizing (4 to 3, 3 to 2, 2 to 1), but not uprizing (1 to 2, 2 to 3, 3 to 4)

    const x1: []const u8 = "hello";
    const x2: []const u8 = &[5]u8{ 'h', 'e', 'l', 'l', 111 };
    std.debug.assert(std.mem.eql(u8, x1, x2));

    // undefined can be coerced to any type
}

fn foo(b2: u16) void {
    _ = b2;
}
