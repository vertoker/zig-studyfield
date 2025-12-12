const std = @import("std");
const builtin = @import("builtin");

const ModulesNames = [_][]const u8{
    "01_printing",
    "02_strings",
    "03_undefined",
    "04_testing",
    "05_numbers",
    "06_arrays",
    "07_vectors",
    "08_pointers",
    "09_alignment",
    "10_structs",
    "11_structs_ext",
    "12_structs_anonymous",
    "13_enums",
    "14_unions",
    "15_switch",
    "16_while",
    "17_for",
    "18_defer",
    "19_functions",
    "20_errors",
    "21_optionals",
    "22_casting",
    "23_comptime",
    "24_allocators",
};

pub fn build(b: *std.Build) void {
    // const target_zig_version = std.SemanticVersion.parse("0.15.2") catch |err| switch (err) {
    //    else => {
    //        @compileLog("{t}", .{err});
    //        @compileError("Can't parse target_zig_version");
    //    },
    // };
    const appName = "documentation_testfield";

    //if (builtin.zig_version.order(target_zig_version) == .lt)
    //    @compileError("builtin.zig_version can't be less than target_zig_version");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const run_step = b.step("run", "Run the app");
    const test_step = b.step("test", "Run tests");

    //var modules: [ModulesNames.len]*std.Build.Module = &.{};
    var imports: [ModulesNames.len]std.Build.Module.Import = undefined;

    for (0..ModulesNames.len) |i| {
        var buffer: [100]u8 = undefined;
        const moduleName = ModulesNames[i];

        const path = std.fmt.bufPrint(&buffer, "modules/{s}.zig", .{moduleName}) catch unreachable;
        const module = addModule(moduleName, path, b, target, optimize);

        module.addCSourceFiles(.{
            .root = b.path(C_ROOT_DIR),
            .files = &(C_CORE_FILES),
            .flags = &C_FLAGS,
        });
        module.addIncludePath(b.path(C_ROOT_DIR));

        imports[i] = .{ .name = moduleName, .module = module };

        const mod_tests = b.addTest(.{
            .root_module = module,
        });

        const run_mod_tests = b.addRunArtifact(mod_tests);
        test_step.dependOn(&run_mod_tests.step);
    }

    const exe = b.addExecutable(.{
        .name = appName,
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .link_libc = true,
            .target = target,
            .optimize = optimize,
            .imports = &imports,
        }),
    });
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Tests
    const run_exe_tests = b.addRunArtifact(exe_tests);
    test_step.dependOn(&run_exe_tests.step);

    // Debugging Tests
    // https://ziggit.dev/t/zig-debugging-with-lldb/3931/7

    const lldb = b.addSystemCommand(&.{
        "lldb",
        // add lldb flags before --
        "--",
    });
    // appends the unit_tests executable path to the lldb command line
    lldb.addArtifactArg(exe_tests);
    // lldb.addArg can add arguments after the executable path

    const lldb_step = b.step("debug", "run the tests under lldb");
    lldb_step.dependOn(&lldb.step);
}

fn addModule(name: []const u8, path: []const u8, b: *std.Build, target: ?std.Build.ResolvedTarget, optimize: ?std.builtin.OptimizeMode) *std.Build.Module {
    const mod = b.addModule(name, .{
        .link_libc = true,
        .root_source_file = b.path(path),
        .target = target,
        .optimize = optimize,
    });
    return mod;
}

const C_ROOT_DIR = "include/";
const C_CORE_FILES = .{
    "utils.c",
};
const C_FLAGS = .{
    "-Wall",
    "-O2",
};
