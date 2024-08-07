const std = @import("std");
const v3 = @import("./vec3.zig");

pub const ray = struct {
    orig: v3.vec3,
    dir: v3.vec3,

    pub fn init_() ray {
        return ray{
            .orig = v3.vec3.init(0, 0, 0),
            .dir = v3.vec3.init(0, 0, 0),
        };
    }

    pub fn init(orig: v3.vec3, dir: v3.vec3) ray {
        return ray{ .orig = orig, .dir = dir };
    }

    pub fn at(orig: v3.vec3, dir: v3.vec3, t: f32) v3.vec3 {
        return v3.vec3.add(orig, v3.vec3.scale(dir, t));
    }
};

test "default initialization" {
    const r: ray = ray.init_();
    const p: v3.vec3 = v3.vec3.init(0, 0, 0);
    try std.testing.expect(@reduce(.And, r.orig.coord == p.coord) and @reduce(.And, r.dir.coord == p.coord));
}

test "normal initialization" {
    const p1: v3.vec3 = v3.vec3.init(1, 2, 3);
    const p2: v3.vec3 = v3.vec3.init(3, 2, 1);
    const r: ray = ray.init(p1, p2);
    try std.testing.expect(@reduce(.And, r.orig.coord == p1.coord) and @reduce(.And, r.dir.coord == p2.coord));
}

test "at" {
    const orig: v3.vec3 = v3.vec3.init(0, 0, 0);
    const dir: v3.vec3 = v3.vec3.init(1, 2, 3);
    const r_at: v3.vec3 = ray.at(orig, dir, 2);
    const p: v3.vec3 = v3.vec3.init(2, 4, 6);
    try std.testing.expect(@reduce(.And, r_at.coord == p.coord));
}
