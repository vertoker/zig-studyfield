const std = @import("std");

// comptime parameter
// comptime type - main way to create generic functions
// https://ziglang.org/documentation/0.15.2/#toc-Generic-Data-Structures
fn max(comptime T: type, a: T, b: T) T {
    comptime {
        // You can in compilation process, calculate your dependencies for parameters
        // You can use only comptime values (like T in this example)
        const info = @typeInfo(T);
        switch (info) {
            .int, .float, .comptime_int, .comptime_float => {},
            else => @compileError("max() applies only numeric types (Int, Float, ComptimeInt, ComptimeFloat)"),
        }
    }

    return if (a > b) a else b;
}

pub fn printTopic() void {
    const m = max(u64, 0, 1);
    _ = m;

    //const mError = max(bool, false, true);
    //_ = mError;

    comptime var i = 0;
    inline while (i < 10) : (i += 1) {} // enumerate at comptime
    comptime std.debug.assert(i == 10); // check in comptime
    std.debug.assert(i == 10); // check in runtime

    // recursion calls budget at comptime - none, it's causes StackOverflow, it's a bug
    // Limit it with @setEcalBranchQuota, default is 1000
    // https://github.com/ziglang/zig/issues/13724
}
