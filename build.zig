const std = @import("std");
const builtin = @import("builtin");

const ModulesNames = [_][]const u8{
    "modules/01_printing",
    "modules/02_strings",
    "modules/03_undefined",
    "modules/04_testing",
    "modules/05_numbers",
    "modules/06_arrays",
    "modules/07_vectors",
    "modules/08_pointers",
    "modules/09_alignment",
    "modules/10_structs",
    "modules/11_structs_ext",
    "modules/12_structs_anonymous",
    "modules/13_enums",
    "modules/14_unions",
    "modules/15_switch",
    "modules/16_while",
    "modules/17_for",
    "modules/18_defer",
    "modules/19_functions",
    "modules/20_errors",
    "modules/21_optionals",
    "modules/22_casting",
    "modules/23_comptime",
    "modules/24_allocators",
    "patterns/alloc_is_not_init",
};

const zig_version = std.SemanticVersion{
    .major = 0,
    .minor = 15,
    .patch = 2,
};

comptime {
    // Compare versions while allowing different pre/patch metadata.
    const zig_version_eq = zig_version.major == builtin.zig_version.major and
        zig_version.minor == builtin.zig_version.minor and
        zig_version.patch == builtin.zig_version.patch;

    if (!zig_version_eq) {
        @compileError(std.fmt.comptimePrint(
            "unsupported zig version: expected {f}, found {f}",
            .{ zig_version, builtin.zig_version },
        ));
    }
}

pub fn build(b: *std.Build) void {
    // A compile error stack trace of 10 is arbitrary in size but helps with debugging (TigerBeetle)
    b.reference_trace = 10;

    const appName = "documentation_testfield";
    const run_step = b.step("run", "Run the app");
    const test_step = b.step("test", "Run tests");

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    //var modules: [ModulesNames.len]*std.Build.Module = &.{};
    var imports: [ModulesNames.len]std.Build.Module.Import = undefined;

    for (0..ModulesNames.len) |i| {
        var buffer: [100]u8 = undefined;
        const moduleName = ModulesNames[i];

        const path = std.fmt.bufPrint(&buffer, "{s}.zig", .{moduleName}) catch unreachable;
        const module = addModule(b, .{
            .name = moduleName,
            .path = path,
            .target = target,
            .optimize = optimize
        });

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

// useful pattern - create anonymous structs to organize all options data
fn addModule(b: *std.Build, options: struct {
    name: []const u8,
    path: []const u8,
    target: ?std.Build.ResolvedTarget,
    optimize: ?std.builtin.OptimizeMode
}) *std.Build.Module {
    const mod = b.addModule(options.name, .{
        .link_libc = true,
        .root_source_file = b.path(options.path),
        .target = options.target,
        .optimize = options.optimize,
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
