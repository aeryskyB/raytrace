const std = @import("std");
const color = @import("lib/color3.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const img_width: u16 = 256;
    const img_height: u16 = 256;
    var r: f32 = undefined;
    var g: f32 = undefined;
    var b: f32 = undefined;
    var ir: u8 = undefined;
    var ig: u8 = undefined;
    var ib: u8 = undefined;

    var clr = color.color3.init();

    try stdout.print("P3\n{d} {d}\n255\n", .{ 2 * img_width, 2 * img_height });

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color.color3.update_(&clr, r, g, b);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }

        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color.color3.update_(&clr, r, g, b);
            color.color3.rgb_to_hsv_(&clr);
            color.color3.shift_(&clr, 30, 0, 0);
            color.color3.clamp_(&clr);
            try color.color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
    }

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color.color3.update_(&clr, r, g, b);
            color.color3.rgb_to_hsv_(&clr);
            color.color3.shift_(&clr, 75, 150, 0);
            color.color3.clamp_(&clr);
            try color.color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }

        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color.color3.update_(&clr, r, g, b);
            color.color3.rgb_to_hsv_(&clr);
            color.color3.shift_(&clr, 30, -150, 20);
            color.color3.clamp_(&clr);
            try color.color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }
}
