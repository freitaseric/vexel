//! This modules provides structs and functions for represent a simple DOM tree.

const std = @import("std");
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
