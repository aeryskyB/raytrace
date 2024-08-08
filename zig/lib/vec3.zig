const std = @import("std");

pub const vec3 = struct {
    coord: @Vector(3, f32),

    pub fn init(x: f32, y: f32, z: f32) vec3 {
        return vec3{
            .coord = @Vector(3, f32){ x, y, z },
        };
    }

    pub fn add_v(v1: vec3, v2: vec3) vec3 {
        return vec3{
            .coord = v1.coord + v2.coord,
        };
    }

    pub fn add_s(v: vec3, t: f32) vec3 {
        return vec3{
            .coord = v.coord + @as(@Vector(3, f32), @splat(t)),
        };
    }

    pub fn scale(v: vec3, t: f32) vec3 {
        return vec3{
            .coord = v.coord * @as(@Vector(3, f32), @splat(t)),
        };
    }

    pub fn length(v: vec3) f32 {
        return @sqrt(@reduce(.Add, v.coord * v.coord));
    }

    pub fn dot(v1: vec3, v2: vec3) f32 {
        return @reduce(.Add, v1.coord * v2.coord);
    }

    pub fn cross(v1: vec3, v2: vec3) vec3 {
        return vec3{ .coord = @Vector(3, f32){
            v1.coord[1] * v2.coord[2] - v1.coord[2] * v2.coord[1],
            v1.coord[2] * v2.coord[0] - v1.coord[0] * v2.coord[2],
            v1.coord[0] * v2.coord[1] - v1.coord[1] * v2.coord[0],
        } };
    }
};

test "initialization" {
    const v = vec3.init(100, 200, 255);
    try std.testing.expectEqual(v.coord[0], 100);
    try std.testing.expectEqual(v.coord[1], 200);
    try std.testing.expectEqual(v.coord[2], 255);
}

test "vector add" {
    const v1 = vec3.init(10, 20, 30);
    const v2 = vec3.init(2, 3, 4);
    const v3 = vec3.add_v(v1, v2);
    const v4 = vec3.init(12, 23, 34);
    try std.testing.expect(@reduce(.And, v3.coord == v4.coord));
}

test "scalar add" {
    const v1 = vec3.init(10, 20, 30);
    const t: f32 = 10;
    const v2 = vec3.add_s(v1, t);
    const v3 = vec3.init(20, 30, 40);
    try std.testing.expect(@reduce(.And, v2.coord == v3.coord));
}

test "scale" {
    const v1 = vec3.init(10, 20, 30);
    const v2 = vec3.scale(v1, 2);
    const v3 = vec3.init(20, 40, 60);
    try std.testing.expect(@reduce(.And, v2.coord == v3.coord));
}

test "length" {
    const v = vec3.init(3, 4, 12);
    try std.testing.expectEqual(vec3.length(v), 13);
}

test "dot product" {
    const v1 = vec3.init(1, 2, 3);
    const v2 = vec3.init(4, 5, 6);
    try std.testing.expectEqual(vec3.dot(v1, v2), 32);
}

test "cross product" {
    const v1 = vec3.init(1, 2, 3);
    const v2 = vec3.init(4, 5, 6);
    const v3 = vec3.cross(v1, v2);
    const v4 = vec3.init(-3, 6, -3);
    try std.testing.expect(@reduce(.And, v3.coord == v4.coord));
}
