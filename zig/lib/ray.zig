const std = @import("std");
const vec3 = @import("./vec3.zig").vec3;

pub const ray = struct {
    orig: vec3,
    dir: vec3,

    pub fn init_() ray {
        return ray{
            .orig = vec3.init(0, 0, 0),
            .dir = vec3.init(0, 0, 0),
        };
    }

    pub fn init(orig: vec3, dir: vec3) ray {
        return ray{ .orig = orig, .dir = dir };
    }

    pub fn at(orig: vec3, dir: vec3, t: f32) vec3 {
        return vec3.add_v(orig, vec3.scale(dir, t));
    }
};

test "default initialization" {
    const r: ray = ray.init_();
    const p: vec3 = vec3.init(0, 0, 0);
    try std.testing.expect(@reduce(.And, r.orig.coord == p.coord) and @reduce(.And, r.dir.coord == p.coord));
}

test "normal initialization" {
    const p1: vec3 = vec3.init(1, 2, 3);
    const p2: vec3 = vec3.init(3, 2, 1);
    const r: ray = ray.init(p1, p2);
    try std.testing.expect(@reduce(.And, r.orig.coord == p1.coord) and @reduce(.And, r.dir.coord == p2.coord));
}

test "at" {
    const orig: vec3 = vec3.init(0, 0, 0);
    const dir: vec3 = vec3.init(1, 2, 3);
    const r_at: vec3 = ray.at(orig, dir, 2);
    const p: vec3 = vec3.init(2, 4, 6);
    try std.testing.expect(@reduce(.And, r_at.coord == p.coord));
}
