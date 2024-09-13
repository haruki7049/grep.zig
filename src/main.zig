const std = @import("std");
const mem = std.mem;

pub fn main() !void {}

fn display_context(file_name: []const u8) !void {
    var buffer: [100]u8 = undefined;
    const file: []u8 = try std.fs.cwd().readFile(file_name, buffer);
}
