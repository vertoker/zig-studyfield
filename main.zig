const printingModule = @import("modules/1_printing.zig");
const stringsModule = @import("modules/2_strings.zig");
const undefinedModule = @import("modules/3_undefined.zig");

pub fn main() void {
    printingModule.printTopic();
    stringsModule.printTopic();
    undefinedModule.printTopic();
}
