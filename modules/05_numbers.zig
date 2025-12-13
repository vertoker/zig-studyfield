const std = @import("std");
const assert = std.debug.assert;

const inf = std.math.inf(f64);
const negative_inf = -std.math.inf(f32);
const nan = std.math.nan(f128);

const big = @as(f64, 1 << 40);

export fn foo_strict(x: f64) f64 {
    // also division by 0 call a debug @panic
    return x + big - big;
}

export fn foo_optimized(x: f64) f64 {
    // Enable all unsafe compiler optimizations for floating numbers (no IEEE-754 strictness)
    // https://software-dl.ti.com/ccs/esd/documents/sdto_cgt_floating_point_optimization.html
    // https://ziglang.org/documentation/0.15.2/#setFloatMode
    @setFloatMode(.optimized); // works only per block
    return x + big - big;
}

pub fn main() void {
    const value: ?u32 = 5678;
    assert(value.? == 5678);
    //value orelse unreachable = 5678;
}
