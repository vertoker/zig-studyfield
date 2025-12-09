const printingModule = @import("modules/1_printing.zig");
const stringsModule = @import("modules/2_strings.zig");
const undefinedModule = @import("modules/3_undefined.zig");
const testingModule = @import("modules/4_testing.zig");
const numbersModule = @import("modules/5_numbers.zig");
const arraysModule = @import("modules/6_arrays.zig");
const vectorsModule = @import("modules/7_vectors.zig");
const pointersModule = @import("modules/8_pointers.zig");
const alignmentModule = @import("modules/9_alignment.zig");
const structsModule = @import("modules/10_structs.zig");
const structsExtModule = @import("modules/11_structs_ext.zig");

pub fn main() void {
    printingModule.printTopic();
    stringsModule.printTopic();
    undefinedModule.printTopic();
    testingModule.printTopic();
    numbersModule.printTopic();
    arraysModule.printTopic();
    vectorsModule.printTopic();
    pointersModule.printTopic();
    alignmentModule.printTopic();
    structsModule.printTopic();
    structsExtModule.printTopic();
}
