const std = @import("std");

pub fn main() !void {
    const img_width: u16 = 255;
    const img_height: u16 = 255;
    var r: f32 = undefined;
    var g: f32 = undefined;
    var b: f32 = undefined;
    var ir: u8 = undefined;
    var ig: u8 = undefined;
    var ib: u8 = undefined;

    const stdout = std.io.getStdOut().writer();

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1);
            g = @as(f32, @floatFromInt(j)) / (img_height - 1);
            b = 0;

            ir = @as(u8, @intFromFloat(255.99 * r));
            ig = @as(u8, @intFromFloat(255.99 * g));
            ib = @as(u8, @intFromFloat(255.99 * b));

            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
        try stdout.print("\n", .{});
    }
}
