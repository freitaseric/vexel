const std = @import("std");
const dom = @import("root.zig");
const types = @import("types.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var html_attrs = types.AttrMap.init(allocator);
    defer html_attrs.deinit();

    var html_children = types.NodeChildren.init(allocator);
    defer html_children.deinit();

    const html = dom.elem("html", html_attrs, html_children);

    std.debug.print("{any}\n", .{html});
}
