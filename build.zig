const std = @import("std");

pub fn build(b: *std.Build) void {
    const appName = "documentation_testfield";

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

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

    //exe.addIncludePath(.{ .path = "modules/" });
    //exe.root_module.addCSourceFile(.{ .file = b.path("test.c"), .flags = &.{"-std=c99"} });
    //exe.root_module.addObject(obj);
    //exe.root_module.linkLibrary(lib);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
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

const ModulesNames = [_][]const u8{
    "1_printing",
    "2_strings",
    "3_undefined",
};

const C_ROOT_DIR = "include/";
const C_CORE_FILES = .{
    "utils.c",
};
const C_FLAGS = .{
    "-Wall",
    "-O2",
};
