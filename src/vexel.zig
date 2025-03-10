//! This modules provides structs and functions for represent a simple DOM tree.

const std = @import("std");
const testing = std.testing;
const heap = std.heap;
const ArenaAllocator = heap.ArenaAllocator;

/// A struct that represents a HTML element (or tag).
pub const ElementData = struct {
    /// The name of the element.
    tag_name: String,
    /// A map that contains the attributes of this element.
    attrs: AttrMap,

    /// Function used to add an attribute for the element.
    pub fn append_attr(self: *ElementData, attr_name: String, attr_value: String) !void {
        try self.attrs.put(attr_name, attr_value);
    }
};

/// Type union to define the type of a node.
pub const NodeType = union(enum) {
    text: String,
    element: ElementData,
};

/// Type alias to unsigned integer with 8 bits slice, commonly called String.
pub const String = []const u8;

/// Type alias to element attributes map.
pub const AttrMap = std.StringHashMap(String);

/// Type alias to a node children list.
pub const NodeChildren = std.ArrayList(Node);

// Struct to represent a DOM node.
pub const Node = struct {
    children: NodeChildren,
    node_type: NodeType,
};

/// This function is used to create a node with just a text element.
pub fn text(data: String) Node {
    var arena = ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const children = NodeChildren.init(allocator);
    defer children.deinit();

    return Node{
        .children = children,
        .node_type = NodeType{
            .text = data,
        },
    };
}

/// This function is used to create a nested node.
pub fn elem(tag_name: String, attrs: AttrMap, children: NodeChildren) Node {
    return Node{
        .children = children,
        .node_type = NodeType{
            .element = ElementData{
                .attrs = attrs,
                .tag_name = tag_name,
            },
        },
    };
}

test "create a text node" {
    const text_node = text("Text node");
    try testing.expectEqual(@as(NodeType, .{ .text = "Text node" }), text_node.node_type);
}

test "create a element node" {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var attrs = AttrMap.init(allocator);
    defer attrs.deinit();

    var children = NodeChildren.init(allocator);
    defer children.deinit();

    try children.append(text("Child Text"));

    try attrs.put("id", "main");
    try attrs.put("class", "container");

    const element_node = elem("div", attrs, children);

    try testing.expectEqual(@as(NodeType, .{
        .element = ElementData{
            .tag_name = "div",
            .attrs = attrs,
        },
    }), element_node.node_type);

    try testing.expectEqual(1, element_node.children.items.len);
    try testing.expectEqual(@as(NodeType, .{ .text = "Child Text" }), element_node.children.items[0].node_type);
}

test "append attribute to element node" {
    var arena = heap.ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var attrs = AttrMap.init(allocator);
    defer attrs.deinit();

    var element_data = ElementData{
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

    var attrs = AttrMap.init(allocator);
    defer attrs.deinit();
    try attrs.put("id", "parent");

    var children = NodeChildren.init(allocator);
    defer children.deinit();

    try children.append(text("Some text"));

    var child_attrs = AttrMap.init(allocator);
    defer child_attrs.deinit();
    try child_attrs.put("class", "child");

    var child_children = NodeChildren.init(allocator);
    defer child_children.deinit();
    try child_children.append(text("Child text"));

    try children.append(elem("span", child_attrs, child_children));

    const parent = elem("div", attrs, children);

    try testing.expectEqual(2, parent.children.items.len);

    try testing.expectEqual(@as(NodeType, .{
        .text = "Some text",
    }), parent.children.items[0].node_type);

    try testing.expectEqual(@as(NodeType, .{
        .element = ElementData{
            .tag_name = "span",
            .attrs = child_attrs,
        },
    }), parent.children.items[1].node_type);
}
