const std = @import("std");

pub fn main() void {
    // Here's 4 types of pointer
    // 1. *T - pointer, can be used for everything, like in C
    // 2. [*]T - pointer to unknown size array
    // 3. *[N]T - pointer to compile-known size array
    // 4. []T - pointer to runtime-known size array (is a slice)

    // Hint 1: ptr can't be null, otherwise use optional life ?*T or ?[]T (or allowzero as *allowzero T)
    // Hint 2: For string is Zig NOT preferred sentinel-terminated ptr (with '0' endline)
    // Better use slice or anything where you known len (compiletime or runtime len)
    // It's cool for bounds checking and prevent illegal behaviour

    // Standard ptr to value (https://ziglang.org/documentation/0.15.2/#toc-Sentinel-Terminated-Pointers)
    const x: i32 = 1234;
    const x_ptr: *const i32 = &x; // dereference
    std.debug.assert(x_ptr.* == 1234); // x.* means access to value in ptr
    std.debug.print("{} == {}, ", .{ x_ptr.*, 1234 });

    // Sentinel-terminated pointer, protect from overflow and overreads
    const msg = "Hello";
    const x_ptr_zero: [msg.len:0]u8 = msg.*; // cast only for known length
    std.debug.assert(x_ptr_zero[0] == 'H');
    std.debug.assert(x_ptr_zero[5] == 0);

    // Printing
    std.debug.print("addr={}, ", .{@intFromPtr(x_ptr)});

    const bytes: [4]u8 align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    std.debug.assert(u32_ptr.* == 0x12121212);
    std.debug.print("{} == {}, ", .{ u32_ptr.*, 0x12121212 });

    // Standard ptr to array
    var array = [_]u8{ 1, 2, 3, 4 };
    const array_ptr: *u8 = &array[2];
    std.debug.assert(array_ptr.* == 3);
    array_ptr.* += 1;
    std.debug.assert(array_ptr.* == 4);
    std.debug.print("{} == {}, \n", .{ array_ptr.*, 4 });

    // Array ptr to slice (from single value)
    const x_array_ptr = x_ptr[0..1];
    std.debug.assert(@TypeOf(x_array_ptr) == *const [1]i32);

    // Array ptr to array
    // *[N]T not support ptr + int, explicit set type to unknown array [*]T
    const array_ptr_2: [*]u8 = &array; // yes, here's implicit cast from *[N]T to [*]T
    // Regular pointers math
    std.debug.assert(array_ptr_2[1..] == array_ptr_2 + 1);

    // Array ptr to slices
    var length: usize = 0; // runtime-value
    _ = &length; // tell to compiler "this value is changed" (actually not)
    var slice = array[length..array.len]; // []T is a slice (fat ptr). It contains ptr + size

    std.debug.assert(slice[0] == 1);
    slice.ptr += 1; // now state is in a bad state
    std.debug.assert(slice[0] == 2);

    // Sentinel-Terminated Slices
    const slice2: [:0]const u8 = "hello"; // runtime-known length and '0' at the end, perfect solution for C-strings
    std.debug.assert(slice2.len == 5);
    std.debug.assert(slice2[5] == 0);
}
