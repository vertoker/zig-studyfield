const std = @import("std");

// declare enum
const Type = enum {
    ok,
    not_ok,
};

// declare enum instance
const c = Type.ok;

// declare enum with ordinal value specification
// it can be not byte, but anyway will be used aligment to bytes
const Value = enum(u2) {
    zero = 0, // specify number under each enum value
    one = 1,
    two = 2,
};

// You can also override only some values
const Value3 = enum(u4) {
    a, // will be 0
    b = 8,
    c, // will be 9
    d = 4,
    e, // will be 5
    _, // this means any other value, which is not in this enum. Useful for functions
};

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,

    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

// enum by default is not C-compatible, provide C integer tag type
const Foo = enum(c_int) { a, b, c }; // this will work with C

pub fn main() void {
    std.debug.assert(@intFromEnum(Value.one) == 1);

    const p = Suit.spades;
    std.debug.assert(!p.isClubs());

    // switch for enums
    const what_is_it = switch (p) {
        Suit.clubs => "clubs",
        Suit.diamonds => "diamonds",
        .hearts => "hearts", // you can to not setup enum name, only enum value name like .name
        Suit.spades => "spades",
    };
    std.debug.assert(std.mem.eql(u8, what_is_it, "spades"));

    std.debug.assert(@typeInfo(Value3).@"enum".tag_type == u4);
    std.debug.assert(std.mem.eql(u8, @tagName(Value.zero), "zero"));
}
