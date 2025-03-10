const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const vexel_mod = b.createModule(.{
        .root_source_file = b.path("src/vexel.zig"),
        .target = target,
        .optimize = optimize,
    });

    const vexel = b.addSharedLibrary(.{
        .name = "vexel",
        .root_source_file = b.path("src/vexel.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(vexel);

    {
        const vexel_unit_tests = b.addTest(.{
            .root_source_file = b.path("src/vexel.zig"),
            .target = target,
            .optimize = optimize,
        });
        vexel_unit_tests.root_module.addImport("vexel", vexel_mod);

        const vexel_unit_tests_run = b.addRunArtifact(vexel_unit_tests);

        const vexel_unit_tests_run_step = b.step("test", "Run unit tests");
        vexel_unit_tests_run_step.dependOn(&vexel_unit_tests_run.step);
    }

    const install_docs = b.addInstallDirectory(.{
        .source_dir = vexel.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    const docs_step = b.step("docs", "Install docs into zig-out/docs");
    docs_step.dependOn(&install_docs.step);
}
