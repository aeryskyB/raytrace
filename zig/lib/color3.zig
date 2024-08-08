const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub const color3 = struct {
    r: f32,
    g: f32,
    b: f32,
    rgb: bool, // scales -> [0, 255]
    hsv: bool, // scales -> [0, 255]
    norm: bool, // scales -> [0, 1]

    pub fn init() color3 {
        return color3{ .r = 0, .g = 0, .b = 0, .rgb = true, .hsv = false, .norm = false };
    }

    pub fn init_rgb(r: f32, g: f32, b: f32) color3 {
        return color3{ .r = r, .g = g, .b = b, .rgb = true, .hsv = false, .norm = false };
    }

    pub fn is_rgb(c: color3) bool {
        return c.rgb;
    }

    pub fn is_hsv(c: color3) bool {
        return c.hsv;
    }

    pub fn to_norm_(clr: *color3) void {
        if (clr.norm) return;
        clr.r = clr.r / 255;
        clr.g = clr.g / 255;
        clr.b = clr.b / 255;
        clr.norm = true;
    }

    pub fn from_norm_(clr: *color3) void {
        if (!clr.norm) return;
        clr.r = clr.r * 255;
        clr.g = clr.g * 255;
        clr.b = clr.b * 255;
        clr.norm = false;
    }

    pub fn rgb_to_hsv_(clr: *color3) void {
        if (clr.hsv) return;
        if (!clr.norm) {
            color3.to_norm_(clr);
        }
        var v: f32 = undefined;
        var m: f32 = undefined;
        var c: f32 = undefined;
        var s: f32 = undefined;
        var h_: f32 = undefined;
        var h: f32 = undefined;

        v = @max(@max(clr.r, clr.g), clr.b);
        m = @min(@min(clr.r, clr.g), clr.b);
        c = v - m;
        s = if (v == 0) 0 else c / v;
        if (c == 0) {
            h_ = 0;
        } else if (v == clr.r) {
            h_ = (clr.g - clr.b) / c;
        } else if (v == clr.g) {
            h_ = (clr.b - clr.r) / c + 2;
        } else if (v == clr.b) {
            h_ = (clr.r - clr.g) / c + 4;
        } else {
            h_ = 0;
        }

        if (h_ < 0) {
            h = (h_ / 6) + 1;
        } else {
            h = h_ / 6;
        }

        clr.r = h;
        clr.g = s;
        clr.b = v;
        color3.from_norm_(clr);
        clr.hsv = true;
        clr.rgb = false;
    }

    pub fn hsv_to_rgb_(clr: *color3) !void {
        if (clr.rgb) return;
        if (!clr.norm) {
            color3.to_norm_(clr);
        }

        var h: f32 = undefined;
        var s: f32 = undefined;
        var v: f32 = undefined;
        var c: f32 = undefined;
        var h_: f32 = undefined;
        var x: f32 = undefined;
        var r_: f32 = undefined;
        var g_: f32 = undefined;
        var b_: f32 = undefined;
        var m: f32 = undefined;

        h = clr.r;
        s = clr.g;
        v = clr.b;
        c = v * s;
        h_ = h * 6;
        x = c * (1 - @abs(try std.math.mod(f32, h_, 2) - 1));
        if (0 <= h_ and h_ < 1) {
            r_ = c;
            g_ = x;
            b_ = 0;
        } else if (1 <= h_ and h_ < 2) {
            r_ = x;
            g_ = c;
            b_ = 0;
        } else if (2 <= h_ and h_ < 3) {
            r_ = 0;
            g_ = c;
            b_ = x;
        } else if (3 <= h_ and h_ < 4) {
            r_ = 0;
            g_ = x;
            b_ = c;
        } else if (4 <= h_ and h_ < 5) {
            r_ = x;
            g_ = 0;
            b_ = c;
        } else {
            r_ = c;
            g_ = 0;
            b_ = x;
        }
        m = v - c;
        clr.r = (r_ + m);
        clr.g = (g_ + m);
        clr.b = (b_ + m);
        color3.from_norm_(clr);
        clr.rgb = true;
        clr.hsv = false;
    }

    pub fn clamp_(clr: *color3) void {
        if (clr.norm) {
            clr.r = @max(@min(clr.r, 1), 0);
            clr.g = @max(@min(clr.g, 1), 0);
            clr.b = @max(@min(clr.b, 1), 0);
        } else {
            clr.r = @max(@min(clr.r, 255), 0);
            clr.g = @max(@min(clr.g, 255), 0);
            clr.b = @max(@min(clr.b, 255), 0);
        }
    }

    pub fn shift_(clr: *color3, sr: f32, sg: f32, sb: f32) void {
        if (sr > 0 or sr < 0) {
            clr.r = clr.r + sr;
        }
        if (sg > 0 or sg < 0) {
            clr.g = clr.g + sg;
        }
        if (sb > 0 or sg < 0) {
            clr.b = clr.b + sb;
        }
    }

    pub fn update_(clr: *color3, r: f32, g: f32, b: f32) void {
        clr.r = r;
        clr.g = g;
        clr.b = b;
    }

    pub fn mix(clr1: color3, clr2: color3) color3 {
        return color3.init_rgb(clr1.r + clr2.r, clr1.g + clr2.g, clr1.b + clr2.b);
    }

    pub fn scale_(clr: *color3, tr: f32, tg: f32, tb: f32) void {
        if (tr > 1 or tr < 1) {
            clr.r = clr.r * tr;
        }
        if (tg > 1 or tg < 1) {
            clr.g = clr.g * tg;
        }
        if (tb > 1 or tb < 1) {
            clr.b = clr.b * tb;
        }
    }

    pub fn write_ppm_rgb_pxl(clr: color3) !void {
        const ir: u8 = @as(u8, @intFromFloat(clr.r));
        const ig: u8 = @as(u8, @intFromFloat(clr.g));
        const ib: u8 = @as(u8, @intFromFloat(clr.b));

        try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
    }

    pub fn write_term_rgb_pxl(clr: color3) !void {
        const ir: u8 = @as(u8, @intFromFloat(clr.r));
        const ig: u8 = @as(u8, @intFromFloat(clr.g));
        const ib: u8 = @as(u8, @intFromFloat(clr.b));

        try stdout.print("\x1b[38;2;{d};{d};{d}m██", .{ ir, ig, ib });
    }
};

test "initialization" {
    const c = color3.init();
    try std.testing.expect(c.r == 0 and c.g == 0 and c.b == 0 and c.rgb and !c.hsv and !c.norm);
}

test "rgb initialization" {
    const c = color3.init_rgb(100, 200, 255);
    try std.testing.expect(c.r == 100 and c.g == 200 and c.b == 255 and c.rgb and !c.hsv and !c.norm);
}

test "rgb test" {
    const c = color3.init_rgb(1, 2, 3);
    try std.testing.expect(color3.is_rgb(c));
}

test "norm test" {
    var c = color3.init_rgb(0, 127.5, 255);
    color3.to_norm_(&c);
    try std.testing.expectEqual(c.r, 0);
    try std.testing.expectEqual(c.g, 0.5);
    try std.testing.expectEqual(c.b, 1.0);
    color3.from_norm_(&c);
    try std.testing.expectEqual(c.r, 0);
    try std.testing.expectEqual(c.g, 127.5);
    try std.testing.expectEqual(c.b, 255);
}

test "1: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(100, 150, 200);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 100);
    try std.testing.expectEqual(c.g, 150);
    try std.testing.expectEqual(c.b, 200);
}

test "2: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(150, 100, 200);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 150);
    try std.testing.expectEqual(c.g, 100);
    try std.testing.expectEqual(c.b, 200);
}

test "3: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(200, 150, 100);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 200);
    try std.testing.expectEqual(c.g, 150);
    try std.testing.expectEqual(c.b, 100);
}

test "4: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(100, 200, 150);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 100);
    try std.testing.expectEqual(c.g, 200);
    try std.testing.expectEqual(c.b, 150);
}

test "5: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(200, 100, 150);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 200);
    try std.testing.expectEqual(c.g, 100);
    try std.testing.expectEqual(c.b, 150);
}

test "6: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(150, 200, 100);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 150);
    try std.testing.expectEqual(c.g, 200);
    try std.testing.expectEqual(c.b, 100);
}

test "7: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(150, 150, 150);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 150);
    try std.testing.expectEqual(c.g, 150);
    try std.testing.expectEqual(c.b, 150);
}

test "8: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(0, 0, 0);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 0);
    try std.testing.expectEqual(c.g, 0);
    try std.testing.expectEqual(c.b, 0);
}

test "9: rgb -> hsv -> rgb" {
    var c = color3.init_rgb(255, 255, 255);
    color3.rgb_to_hsv_(&c);
    try color3.hsv_to_rgb_(&c);
    try std.testing.expectEqual(c.r, 255);
    try std.testing.expectEqual(c.g, 255);
    try std.testing.expectEqual(c.b, 255);
}

test "shift #1" {
    var c = color3.init_rgb(200, 150, 100);
    color3.shift_(&c, 15, 20, 25);
    try std.testing.expectEqual(c.r, 215);
    try std.testing.expectEqual(c.g, 170);
    try std.testing.expectEqual(c.b, 125);
}

test "shift #2" {
    var c = color3.init_rgb(127.5, 127.5, 127.5);
    color3.to_norm_(&c);
    color3.shift_(&c, -0.5, 0, 0.5);
    color3.from_norm_(&c);
    try std.testing.expectEqual(c.r, 0);
    try std.testing.expectEqual(c.g, 127.5);
    try std.testing.expectEqual(c.b, 255);
}

test "clamp #1" {
    var c = color3.init_rgb(256, -1, 1000);
    color3.clamp_(&c);
    try std.testing.expectEqual(c.r, 255);
    try std.testing.expectEqual(c.g, 0);
    try std.testing.expectEqual(c.b, 255);
}

test "clamp #2" {
    var c = color3.init_rgb(256, -1, 1000);
    color3.to_norm_(&c);
    color3.clamp_(&c);
    try std.testing.expectEqual(c.r, 1);
    try std.testing.expectEqual(c.g, 0);
    try std.testing.expectEqual(c.b, 1);
}

test "update" {
    var c = color3.init_rgb(0, 0, 0);
    color3.update_(&c, 10, 20, 30);
    try std.testing.expectEqual(c.r, 10);
    try std.testing.expectEqual(c.g, 20);
    try std.testing.expectEqual(c.b, 30);
}

test "mix #1" {
    const c1 = color3.init_rgb(10, 20, 30);
    const c2 = color3.init_rgb(30, 20, 10);
    var c3 = color3.mix(c1, c2);
    color3.clamp_(&c3);
    const c4 = color3.init_rgb(40, 40, 40);
    try std.testing.expect(c3.r == c4.r and c3.g == c4.g and c3.b == c4.b);
}

test "mix #2" {
    const c1 = color3.init_rgb(100, 200, 300);
    const c2 = color3.init_rgb(30, 20, 10);
    var c3 = color3.mix(c1, c2);
    color3.clamp_(&c3);
    const c4 = color3.init_rgb(130, 220, 255);
    try std.testing.expect(c3.r == c4.r and c3.g == c4.g and c3.b == c4.b);
}

test "scale #1" {
    var c1 = color3.init_rgb(10, 20, 30);
    color3.scale_(&c1, 2, 2, 2);
    color3.clamp_(&c1);
    const c2 = color3.init_rgb(20, 40, 60);
    try std.testing.expect(c1.r == c2.r and c1.g == c2.g and c1.b == c2.b);
}

test "scale #2" {
    var c1 = color3.init_rgb(100, 200, 300);
    color3.scale_(&c1, 2, 2, 2);
    color3.clamp_(&c1);
    const c2 = color3.init_rgb(200, 255, 255);
    try std.testing.expect(c1.r == c2.r and c1.g == c2.g and c1.b == c2.b);
}
