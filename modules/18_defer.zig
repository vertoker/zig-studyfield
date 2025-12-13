const std = @import("std");

pub fn main() void {
    std.debug.assert(defer1() == 3);
    defer2();
}

fn defer1() usize {
    var a: usize = 1;
    {
        defer a = 3;
        a = 2;
        // return in defer is not allowed
    }
    return a;
}
fn defer2() void {
    // defer calling in reverse order
    defer {
        std.debug.print("1 ", .{});
    }
    defer {
        std.debug.print("2 ", .{});
    }
    if (false) {
        defer {
            std.debug.print("3 ", .{});
        }
    }
}
