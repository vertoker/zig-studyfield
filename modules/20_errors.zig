const std = @import("std");

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};
const AllocatorError = error{
    OutOfMemory,
};
fn foo(err: AllocatorError) FileOpenError {
    // implicit error cast allowed only if output values contains all input values
    // etc. AllocatorError can be casted to FileOpenError, but otherwise it will be error
    // error OutOfMemory has both, but AccessDenied has only FileOpenError
    return err;
}

const EqlError = error{
    NotEqual,
};
fn eql(a: anytype, b: anytype) !bool {
    if (a != b)
        return error.NotEqual;
    return true;
}

// you can merge error sets to one
const AllError = FileOpenError || AllocatorError || EqlError;

pub fn printTopic() void {
    var err = foo(AllocatorError.OutOfMemory);
    std.debug.assert(err == FileOpenError.OutOfMemory);

    // also shortcut
    err = error.FileNotFound;
    // is equivalent to
    err = (error{FileNotFound}).FileNotFound;

    // anyerror literally means ANY error in compiled program, not matter where it define/using
    // Zig recommend avoid this, because better compiler know which error can produce fn

    // also you can use try, it just return error to current function (printTopic don't have ! )
    const value = eql(0, 1) catch |err2| switch (err2) {
        EqlError.NotEqual => false,
        else => unreachable,
    };
    std.debug.print("eql={}, ", .{value});

    // other syntax for errors handling
    if (eql(0, 0)) |result| {
        std.debug.print("eql2={}, ", .{result});
    } else |err3| switch (err3) {
        // handle errors here
        error.NotEqual => {
            std.debug.print("eql2=false, ", .{});
        },
        else => unreachable,
    }

    // TODO errdefer
}

// https://ziglang.org/documentation/0.15.2/#toc-Error-Union-Type
pub fn parseU64(buf: []const u8, radix: u8) !u64 { // anyerror!u64
    var x: u64 = 0;

    for (buf) |c| {
        const digit = charToDigit(c);

        if (digit >= radix) {
            return error.InvalidChar;
        }

        // x *= radix
        var ov = @mulWithOverflow(x, radix);
        if (ov[1] != 0) return error.OverFlow;

        // x += digit
        ov = @addWithOverflow(ov[0], digit);
        if (ov[1] != 0) return error.OverFlow;
        x = ov[0];
    }

    return x;
}
fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'A'...'Z' => c - 'A' + 10,
        'a'...'z' => c - 'a' + 10,
        else => std.math.maxInt(u8),
    };
}
