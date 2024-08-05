const std = @import("std");

pub fn main() !void {
    const img_width: u16 = 256;
    const img_height: u16 = 256;
    var r: f32 = undefined;
    var g: f32 = undefined;
    var b: f32 = undefined;
    var ir: u8 = undefined;
    var ig: u8 = undefined;
    var ib: u8 = undefined;

    const stdout = std.io.getStdOut().writer();

    try stdout.print("P3\n{d} {d}\n255\n", .{ img_width, img_height });

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1);
            g = @as(f32, @floatFromInt(j)) / (img_height - 1);
            b = 0;

            ir = @as(u8, @intFromFloat(255.99 * r));
            ig = @as(u8, @intFromFloat(255.99 * g));
            ib = @as(u8, @intFromFloat(255.99 * b));

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }
}
