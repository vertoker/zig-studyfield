const std = @import("std");
const print = std.debug.print;
const mem = std.mem;

// https://github.com/blog-memo/zig-setconsoleoutputcp-2023-0909-1622
const c = @cImport({
    @cInclude("utils.c");
});

// https://ziggit.dev/t/blog-understanding-how-zig-and-c-interact/6733
pub extern fn set_console_output_cp() void;

pub fn printTopic() void {
    const bytes = "Hello";
    print("{}, ", .{@TypeOf(bytes)});
    print("{d}, ", .{bytes.len});
    print("{c}, ", .{bytes[1]});
    print("{d}\n", .{bytes[5]}); // null-terminated

    // can be replaced without C: https://github.com/ziglang/zig/issues/18229
    set_console_output_cp();

    print("{}, ", .{'e' == '\x65'});
    print("{d}, ", .{'\u{1f4a9}'});
    print("{d}, ", .{'💯'});
    print("{u}, ", .{'⚡'});
    print("{}, ", .{mem.eql(u8, "hello", "h\x65llo")});
    print("{}\n", .{mem.eql(u8, "💯", "\xf0\x9f\x92\xaf")});

    const invalid_utf8 = "\xff\xfe"; // \xNN notation
    print("0x{x}, ", .{invalid_utf8[1]});
    print("0x{x}\n", .{"💯"[1]}); // indexing non-ascii characters with ascii bytes

    printRus();
}

// https://ssojet.com/character-encoding-decoding/utf-16-in-zig/
fn printRus() void {
    const bytes_utf8 = "Привет\n";
    var utf16_buffer: [100]u16 = undefined;

    const utf16_len = std.unicode.utf8ToUtf16Le(utf16_buffer[0..], bytes_utf8) catch 0;
    const utf16_slice = utf16_buffer[0..utf16_len];

    for (utf16_slice) |utf16_char| {
        print("{u}", .{utf16_char});
    }
    //print("UTF-16 printing: {any}\n", .{utf16_slice});
}
