const printingModule = @import("modules/1_printing.zig");
const stringsModule = @import("modules/2_strings.zig");
const undefinedModule = @import("modules/3_undefined.zig");
const testingModule = @import("modules/4_testing.zig");
const numbersModule = @import("modules/5_numbers.zig");
const arraysModule = @import("modules/6_arrays.zig");

pub fn main() void {
    printingModule.printTopic();
    stringsModule.printTopic();
    undefinedModule.printTopic();
    testingModule.printTopic();
    numbersModule.printTopic();
    arraysModule.printTopic();
}
