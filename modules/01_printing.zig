//! Module comment, anything before it - error

const std = @import("std");
const print = std.debug.print;
const os = std.os;
const assert = std.debug.assert;
const builtin = @import("builtin");

/// Main function (doc comment)
pub fn main() void {
    // Only 1 line comments, without /* */
    print("Hello, {s}!\n", .{"World"});

    print("1 + 1 = {}\n", .{1 + 1});
    print("{} {} {}\n", .{
        true and false,
        true | false,
        !true,
    });

    var optional_value: ?[]const u8 = null; // optional string with char (1 byte)
    assert(optional_value == null);
    // Print optional can be not {}, but with {?s}
    print("Optional 1, type={}, value={?s}\n", .{ @TypeOf(optional_value), optional_value });

    optional_value = "AEEYY!";
    assert(optional_value != null);
    print("Optional 2, type={}, value={?s}\n", .{ @TypeOf(optional_value), optional_value });

    {
        var number_or_error: anyerror!i32 = error.ArgNotFound;
        // Print {!} is specifier for errors
        print("Optional 3, type={}, value={!}\n", .{ @TypeOf(number_or_error), number_or_error });

        number_or_error = 1234;
        print("Optional 4, type={}, value={!}\n", .{ @TypeOf(number_or_error), number_or_error });
    }

    const target_zig_version = comptime std.SemanticVersion.parse("0.15.3") catch unreachable;
    print("{}.{}.{} ", .{target_zig_version.major, target_zig_version.minor, target_zig_version.patch});
}
