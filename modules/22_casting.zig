const std = @import("std");

// Zig has 3 ways to cast type from one to another
// 1. Type Coercion - implicit cast. just assign one type value to another related type value, most used
// 2. Explicit cast - cast via buildin functions @...Cast, like @bitCast @alignCast or @ptrCast
// 3. Peer Type Resolution -

pub fn printTopic() void {
    // way 1 - type coercion
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

    // arrays, slices, pointers

}

fn foo(b2: u16) void {
    _ = b2;
}
