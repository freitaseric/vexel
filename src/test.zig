const std = @import("std");
const testing = std.testing;
const heap = std.heap;
const vexel = @import("root.zig");

test "create a text node" {
    const text_node = vexel.text("Text node");
    try testing.expectEqual(@as(vexel.NodeType, .{ .text = "Text node" }), text_node.node_type);
}

test "create a element node" {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var attrs = vexel.AttrMap.init(allocator);
    defer attrs.deinit();

    var children = vexel.NodeChildren.init(allocator);
    defer children.deinit();

    try children.append(vexel.text("Child Text"));

    try attrs.put("id", "main");
    try attrs.put("class", "container");

    const element_node = vexel.elem("div", attrs, children);

    try testing.expectEqual(@as(vexel.NodeType, .{
        .element = vexel.ElementData{
            .tag_name = "div",
            .attrs = attrs,
        },
    }), element_node.node_type);

    try testing.expectEqual(1, element_node.children.items.len);
    try testing.expectEqual(@as(vexel.NodeType, .{ .text = "Child Text" }), element_node.children.items[0].node_type);
}

test "append attribute to element node" {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var attrs = vexel.AttrMap.init(allocator);
    defer attrs.deinit();

    var element_data = vexel.ElementData{
        .tag_name = "div",
        .attrs = attrs,
    };

    try element_data.append_attr("id", "container");

    const value = element_data.attrs.get("id");
    try testing.expectEqual("container", value);
}

test "create a complex node structure" {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var attrs = vexel.AttrMap.init(allocator);
    defer attrs.deinit();
    try attrs.put("id", "parent");

    var children = vexel.NodeChildren.init(allocator);
    defer children.deinit();

    try children.append(vexel.text("Some text"));

    var child_attrs = vexel.AttrMap.init(allocator);
    defer child_attrs.deinit();
    try child_attrs.put("class", "child");

    var child_children = vexel.NodeChildren.init(allocator);
    defer child_children.deinit();
    try child_children.append(vexel.text("Child text"));

    try children.append(vexel.elem("span", child_attrs, child_children));

    const parent = vexel.elem("div", attrs, children);

    try testing.expectEqual(2, parent.children.items.len);
    
    try testing.expectEqual(@as(vexel.NodeType, .{
        .text = "Some text",
    }), parent.children.items[0].node_type);

    try testing.expectEqual(@as(vexel.NodeType, .{
        .element = vexel.ElementData{
            .tag_name = "span",
            .attrs = child_attrs,
        },
    }), parent.children.items[1].node_type);
}
