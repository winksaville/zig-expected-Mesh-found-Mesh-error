const Mesh = @import("modules/zig-geometry/mesh.zig").Mesh;

pub fn createMeshFromBabylon(file_name: []const u8) Mesh {
    // Parse file in Bablyon json format to json tree
    // ...
    var vertice_count: usize = 0;
    var face_count: usize = 0;

    var mesh = Mesh.init(file_name, vertice_count, face_count);

    // Convert json tree to Mesh
    // ...

    return mesh;
}
