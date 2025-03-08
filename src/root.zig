const heap = @import("std").heap;
const ArenaAllocator = heap.ArenaAllocator;
const types = @import("types.zig");

pub const ElementData = struct {
    tag_name: types.String,
    attrs: types.AttrMap,

    pub fn append_attr(self: *ElementData, attr_name: types.String, attr_value: types.String) !void {
        self.attrs.put(attr_name, attr_value);
    }
};

pub const NodeType = union(enum) {
    text: types.String,
    element: ElementData,
};

pub const Node = struct {
    children: types.NodeChildren,
    node_type: NodeType,
};

pub fn text(data: types.String) Node {
    var arena = ArenaAllocator.init(heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const children = types.NodeChildren.init(allocator);
    defer children.deinit();

    return Node{
        .children = children,
        .node_type = NodeType{
            .text = data,
        },
    };
}

pub fn elem(tag_name: types.String, attrs: types.AttrMap, children: types.NodeChildren) Node {
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
