pub const Mesh = struct {
    const Self = @This();

    pub name: []const u8,
    pub vertice_count: usize,
    pub face_count: usize,

    pub fn init(name: []const u8, vertice_count: usize, face_count: usize) Self {
        return Self{
            .name = name,
            .vertice_count = vertice_count,
            .face_count = face_count,
        };
    }
};
