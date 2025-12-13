const std = @import("std");
const assert = std.debug.assert;

pub fn main() void {
    const all_two = [_]u16{2} ** 10;
    std.debug.print("{any}\n", .{all_two});

    comptime {
        assert(all_two.len == 10);
        assert(all_two[5] == 2);
    }

    var array = [_]i32{ 1, 2, 3, 4 };

    const slice = array[0 .. array.len / 2];
    slice[0] += 1;
    std.debug.print("{any} ", .{slice});

    const alt_slice: []const i32 = &.{ 1, 2, 3, 4 };
    std.debug.print("{any} \n", .{alt_slice});

    // If you slice with comptime-known start and end positions, the result is
    // a pointer to an array, rather than a slice.
    const array_ptr = array[0..array.len];
    std.debug.assert(@TypeOf(array_ptr) == *[array.len]i32);

    // Multidimensional array (nesting arrays)

    const mat4x5 = [_][5]f32{
        [_]f32{ 1.0, 0.0, 0.0, 0.0, 0.0 },
        [_]f32{ 0.0, 1.0, 0.0, 1.0, 0.0 },
        [_]f32{ 0.0, 0.0, 1.0, 0.0, 0.0 },
        [_]f32{ 0.0, 0.0, 0.0, 1.0, 9.9 },
    };

    std.debug.assert(std.mem.eql(f32, &mat4x5[1], &[_]f32{ 0.0, 1.0, 0.0, 1.0, 0.0 }));
    std.debug.assert(mat4x5[3][4] == 9.9);

    for (mat4x5, 0..) |row, row_index| {
        for (row, 0..) |cell, column_index| {
            if (row_index == column_index) {
                std.debug.assert(cell == 1.0);
            }
        }
    }

    const all_zero: [4][5]f32 = .{.{0} ** 5} ** 4;
    std.debug.assert(all_zero[0][0] == 0);

    // null-terminated array (special for C-stirngs)
    const array2 = [_:0]u8{ 1, 2, 3, 4 };

    std.debug.assert(@TypeOf(array2) == [4:0]u8);
    std.debug.assert(array2.len == 4); // len is 4
    std.debug.assert(array2[4] == 0); // but allocated 5 symbols with end symbol = 0
}
