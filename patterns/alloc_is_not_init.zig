const std = @import("std");
const Allocator = std.mem.Allocator;

// https://ziggit.dev/t/allocation-is-not-initialization/3138/2
const User = struct {
    domain: []const u8 = "ziggit.dev",
    enabled: bool = false,

    // "constructor" 1 - core initialization for type
    fn init(d: []const u8, e: bool) User {
        return .{.domain = d, .enabled  = e};
    }

    // "constructor" 2 - side initialization with allocator
    fn create(a: Allocator, d: []const u8, e: bool) !*User {
        const u = try a.create(User);
        u.* = init(d, e);
        return u;
    }
};

pub fn main() void {
    var buffer: [128]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    const u_on_stack = User.init("dom1.org", true);
    const u_on_heap = User.create(allocator, "dom2.org", true) catch unreachable;

    std.debug.print(
        "user on stack : d = '{s}', e = {} ({*})\n",
        .{u_on_stack.domain, u_on_stack.enabled, &u_on_stack}
    );

    std.debug.print(
        "user on heap : d = '{s}', e = {} ({*})\n",
        .{u_on_heap.domain, u_on_heap.enabled, u_on_heap}
    );
}