const std = @import("std");
const color3 = @import("./lib/color3.zig").color3;
const vec3 = @import("./lib/vec3.zig").vec3;
const ray = @import("./lib/ray.zig").ray;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const aspect_ratio: f32 = 16.0 / 9.0;
    const img_w: u10 = 400;

    const img_h: u10 = @as(u10, @intFromFloat(@as(f32, @floatFromInt(img_w)) / aspect_ratio));
    if (img_h < 1) {
        img_h = 1;
    }

    const focal_len: f32 = 1.0;

    // vp -> viewport
    const vp_h: f32 = 2.0;
    const vp_w: f32 = vp_h * (@as(f32, @floatFromInt(img_w)) / @as(f32, @floatFromInt(img_h)));
    const camera_o = vec3.init(0, 0, 0); // o -> origin

    const vp_u: vec3 = vec3.init(vp_w, 0, 0);
    const vp_v: vec3 = vec3.init(0, -vp_h, 0);

    // pxl -> pixel :)
    const pxl_delta_u: vec3 = vec3.scale(vp_u, 1 / @as(f32, @floatFromInt(img_w)));
    const pxl_delta_v: vec3 = vec3.scale(vp_v, 1 / @as(f32, @floatFromInt(img_h)));

    const norm_p: vec3 = vec3.init(0, 0, -focal_len);

    const vp_up_left: vec3 = vec3.add_v(vec3.add_v(camera_o, norm_p), vec3.add_v(vec3.scale(vp_u, -0.5), vec3.scale(vp_v, -0.5)));

    // initial write
    try stdout.print("P3\n{d} {d}\n255\n", .{ img_w, img_h });

    const pixel_up_left_loc: vec3 = vec3.add_v(vp_up_left, vec3.scale(vec3.add_v(pxl_delta_u, pxl_delta_v), 0.5));
    var pxl_v: vec3 = undefined;
    var pxl: vec3 = undefined;
    var ray_dir: vec3 = undefined;
    var r: ray = undefined;
    var clr: color3 = undefined;
    const sphr_r: f32 = 0.5;
    for (0..img_h) |j| {
        pxl_v = vec3.add_v(pixel_up_left_loc, vec3.scale(pxl_delta_v, @as(f32, @floatFromInt(j))));
        for (0..img_w) |i| {
            pxl = vec3.add_v(pxl_v, vec3.scale(pxl_delta_u, @as(f32, @floatFromInt(i))));
            ray_dir = vec3.add_v(pxl, vec3.scale(camera_o, -1));
            r = ray.init(camera_o, ray_dir);
            clr = ray_color(&r, norm_p, sphr_r);
            try color3.write_ppm_rgb_pxl(clr);
        }
    }
}

fn hit_sphere(sphr_c: vec3, sphr_r: f32, r: ray) bool {
    const co: vec3 = vec3.add_v(sphr_c, vec3.scale(r.orig, -1));
    const a: f32 = vec3.dot(r.dir, r.dir);
    const b: f32 = -2 * vec3.dot(r.dir, co);
    const c: f32 = vec3.dot(co, co) - sphr_r * sphr_r;
    const discr: f32 = b * b - 4 * a * c;
    return discr >= 0;
}

fn ray_color(r: *ray, sphr_c: vec3, sphr_r: f32) color3 {
    if (hit_sphere(sphr_c, sphr_r, r.*)) {
        return color3.init_rgb(255, 0, 0);
    }

    const v: vec3 = vec3.scale(r.dir, 1 / vec3.length(r.dir));
    const a: f32 = 0.5 * (v.coord[1] + 1);
    var c1 = color3.init_rgb(255, 255, 255); // white
    var c2 = color3.init_rgb(0, 255, 255); // cyan
    color3.scale_(&c1, 1 - a, 1 - a, 1 - a);
    color3.clamp_(&c1);
    color3.scale_(&c2, a, a, a);
    color3.clamp_(&c2);
    return color3.mix(c1, c2);
}
