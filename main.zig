const printing = @import("modules/printing.zig");
const strings = @import("modules/strings.zig");

pub fn main() void {
    printing.printTopic();
    strings.printTopic();
}
