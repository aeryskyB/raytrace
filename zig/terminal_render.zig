const std = @import("std");
const color3 = @import("lib/color3.zig").color3;

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

    var clr = color3.init();

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color3.update_(&clr, r, g, b);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
        try stdout.print("\t", .{});

        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color3.update_(&clr, r, g, b);
            color3.rgb_to_hsv_(&clr);
            color3.shift_(&clr, 30, 0, 0);
            color3.clamp_(&clr);
            try color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
        try stdout.print("\n", .{});
    }

    try stdout.print("\n\n", .{});

    for (0..img_height) |j| {
        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color3.update_(&clr, r, g, b);
            color3.rgb_to_hsv_(&clr);
            color3.shift_(&clr, 75, 150, 0);
            color3.clamp_(&clr);
            try color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
        try stdout.print("\t", .{});

        for (0..img_width) |i| {
            r = @as(f32, @floatFromInt(i)) / (img_width - 1) * 255.9;
            g = @as(f32, @floatFromInt(j)) / (img_height - 1) * 255.9;
            b = 0;
            color3.update_(&clr, r, g, b);
            color3.rgb_to_hsv_(&clr);
            color3.shift_(&clr, 30, -150, 20);
            color3.clamp_(&clr);
            try color3.hsv_to_rgb_(&clr);

            ir = @as(u8, @intFromFloat(clr.r));
            ig = @as(u8, @intFromFloat(clr.g));
            ib = @as(u8, @intFromFloat(clr.b));
            try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
        }
        try stdout.print("\n", .{});
    }
}
