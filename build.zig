const std = @import("std");

pub fn build(b: *std.Build) void {
    const appName = "documentation_testfield";
    const printingName = "printing";
    const stringsName = "strings";

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const printingModule = addModule(printingName, "modules/printing.zig", b, target, optimize);
    const stringsModule = addModule(stringsName, "modules/strings.zig", b, target, optimize);

    stringsModule.addCSourceFiles(.{
        .root = b.path(C_ROOT_DIR),
        .files = &(C_CORE_FILES),
        .flags = &C_FLAGS,
    });
    stringsModule.addIncludePath(b.path(C_ROOT_DIR));

    const exe = b.addExecutable(.{
        .name = appName,
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .link_libc = true,
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = printingName, .module = printingModule },
                .{ .name = stringsName, .module = stringsModule },
            },
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

const C_ROOT_DIR = "include/";

const C_CORE_FILES = .{
    //"utils.h",
    "utils.c",
};

const C_LIB_FILES = .{};

const C_FLAGS = .{
    "-Wall",
    "-O2",
};
