const std = @import("std");
const dom = @import("root.zig");

pub const String = []const u8;

pub const AttrMap = std.StringHashMap(String);

pub const NodeChildren = std.ArrayList(dom.Node);
