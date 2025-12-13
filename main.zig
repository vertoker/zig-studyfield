const printing_module = @import("modules/01_printing.zig");
const strings_module = @import("modules/02_strings.zig");
const undefined_module = @import("modules/03_undefined.zig");
const testing_module = @import("modules/04_testing.zig");
const numbers_module = @import("modules/05_numbers.zig");
const arrays_module = @import("modules/06_arrays.zig");
const vectors_module = @import("modules/07_vectors.zig");
const pointers_module = @import("modules/08_pointers.zig");
const alignment_module = @import("modules/09_alignment.zig");
const structs_module = @import("modules/10_structs.zig");
const structsExt_module = @import("modules/11_structs_ext.zig");
const structsAnonymous_module = @import("modules/12_structs_anonymous.zig");
const enums_module = @import("modules/13_enums.zig");
const unions_module = @import("modules/14_unions.zig");
const switch_module = @import("modules/15_switch.zig");
const while_module = @import("modules/16_while.zig");
const for_module = @import("modules/17_for.zig");
const defer_module = @import("modules/18_defer.zig");
const functions_module = @import("modules/19_functions.zig");
const errors_module = @import("modules/20_errors.zig");
const optionals_module = @import("modules/21_optionals.zig");
const casting_module = @import("modules/22_casting.zig");
const comptime_module = @import("modules/23_comptime.zig");
const allocators_module = @import("modules/24_allocators.zig");

const alloc_is_not_init_pattern = @import("patterns/alloc_is_not_init.zig");

pub fn main() void {
    // Modules
    printing_module.main();
    strings_module.main();
    undefined_module.main();
    testing_module.main();
    numbers_module.main();
    arrays_module.main();
    vectors_module.main();
    pointers_module.main();
    alignment_module.main();
    structs_module.main();
    structsExt_module.main();
    structsAnonymous_module.main();
    enums_module.main();
    unions_module.main();
    switch_module.main();
    while_module.main();
    for_module.main();
    defer_module.main();
    functions_module.main();
    errors_module.main();
    optionals_module.main();
    casting_module.main();
    comptime_module.main();
    allocators_module.main();

    // Patterns
    alloc_is_not_init_pattern.main();
}
