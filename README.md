# Zig expected Mesh found Mesh error

[This repo](https://github.com/winksaville/zig-expected-Mesh-found-Mesh-error) demostrates
a zig compiler error is encountered when
the compiler finds the same imported symbol declared in two places.

I encountered this in my [zig-3d-soft-engine](https://github.com/winksaville/zig-3d-soft-engine) project. And
I've created this simplified repo to demostrate the problem in a
simpler project.

This simple project is organized into the following tree and is
simpler in form to the zig-3d-soft-engine.

```
$ tree
.
├── create_mesh.zig
├── LICENSE
├── modules
│   ├── zig-geometry
│   │   └── mesh.zig
│   └── zig-json
│       ├── create_mesh.zig
│       └── modules
│           └── zig-geometry
│               └── mesh.zig
├── README.md
├── test.zig
└── zig-cache
    ├── test
    └── test.o
```

In particular notice that there are two occurrences of
mesh.zig. The reason is because in the full project
zig-geometry and zig-json are included in the
"parent" project using `git submodule`. And the reason there
are two `mesh.zig` files is because zig-json also includes
zig-geometry as a submodule. Hence there are two complete
copies of the zig-geometry and thus two mesh.zig files.
One in `modules/zig-geometry/mesh.zig` and the other in
`modules/zig-json/modules/zig-geometry/mesh.zig`.

In the parent project I have `test.zig`:
```
$ cat -n test.zig
     1	const std = @import("std");
     2	const assert = std.debug.assert;
     3
     4	const Mesh = @import("modules/zig-geometry/mesh.zig").Mesh;
     5
     6	test "fails" {
     7	    const createMeshFromBabylon = @import("modules/zig-json/create_mesh.zig").createMeshFromBabylon;
     8
     9	    var mesh: Mesh = createMeshFromBabylon("fails");
    10	    assert(mesh.vertice_count == 0);
    11	    assert(mesh.face_count == 0);
    12	    assert(std.mem.eql(u8, mesh.name, "fails"));
    13	}
    14
    15	test "success1" {
    16	    const createMeshFromBabylon = @import("modules/zig-json/create_mesh.zig").createMeshFromBabylon;
    17
    18	    var mesh = createMeshFromBabylon("success1");
    19	    assert(mesh.vertice_count == 0);
    20	    assert(mesh.face_count == 0);
    21	    assert(std.mem.eql(u8, mesh.name, "success1"));
    22	}
    23
    24	test "success2" {
    25	    const createMeshFromBabylon = @import("create_mesh.zig").createMeshFromBabylon;
    26
    27	    var mesh: Mesh = createMeshFromBabylon("success2");
    28	    assert(mesh.vertice_count == 0);
    29	    assert(mesh.face_count == 0);
    30	    assert(std.mem.eql(u8, mesh.name, "success2"));
    31	}
```

If we run test `fails` we get `error: expected type 'Mesh', found 'Mesh'.
because the compiler sees two copies of `mesh.zig`:
```
$ zig test test.zig --test-filter fails
/home/wink/prgs/graphics/zig-expected-Mesh-found-Mesh-error/test.zig:9:43: error: expected type 'Mesh', found 'Mesh'
    var mesh: Mesh = createMeshFromBabylon("fails");
                                          ^
/home/wink/prgs/graphics/zig-expected-Mesh-found-Mesh-error/modules/zig-geometry/mesh.zig:1:18: note: Mesh declared here
pub const Mesh = struct {
                 ^
/home/wink/prgs/graphics/zig-expected-Mesh-found-Mesh-error/modules/zig-json/modules/zig-geometry/mesh.zig:1:18: note: Mesh declared here
pub const Mesh = struct {
                 ^
```

I've found two workarounds, the first one is `success1`. The only
difference between `fails` and `success1` is rather than explicitly typing
`var mesh: Mesh` as in line 9 for `fails`:
```
9	    var mesh: Mesh = createMeshFromBabylon("fails");
```

In `success1`, line 18, the explicit typing is removed:
```
18	    var mesh = createMeshFromBabylon("success1");
```
And it works:
```
$ zig test test.zig --test-filter success1
Test 1/1 success1...OK
All tests passed.
```
But that isn't viable, because creating Mesh's does occur.

The second solution, which is what I'm using in [zig-3d-soft-engine](https://github.com/winksaville/zig-3d-soft-engine),
is to place a copy of "create_mesh.zig" in the "parent" project and use it rather than
the one in the submodule. This solves the problem because only
`modules/zig-geometry/mesh.zig` is being referenced and test `success2` works:
```
$ zig test test.zig --test-filter success2
Test 1/1 success2...OK
All tests passed.
```

I'm hoping there is a "right" way to do this so that I can use
`git submodules` as I've described.
