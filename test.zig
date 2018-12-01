const std = @import("std");
const assert = std.debug.assert;

const Mesh = @import("modules/zig-geometry/mesh.zig").Mesh;

test "fails" {
    const createMeshFromBabylon = @import("modules/zig-json/create_mesh.zig").createMeshFromBabylon;

    var mesh: Mesh = createMeshFromBabylon("fails");
    assert(mesh.vertice_count == 0);
    assert(mesh.face_count == 0);
    assert(std.mem.eql(u8, mesh.name, "fails"));
}

test "success1" {
    const createMeshFromBabylon = @import("modules/zig-json/create_mesh.zig").createMeshFromBabylon;

    var mesh = createMeshFromBabylon("success1");
    assert(mesh.vertice_count == 0);
    assert(mesh.face_count == 0);
    assert(std.mem.eql(u8, mesh.name, "success1"));
}

test "success2" {
    const createMeshFromBabylon = @import("create_mesh.zig").createMeshFromBabylon;

    var mesh: Mesh = createMeshFromBabylon("success2");
    assert(mesh.vertice_count == 0);
    assert(mesh.face_count == 0);
    assert(std.mem.eql(u8, mesh.name, "success2"));
}
