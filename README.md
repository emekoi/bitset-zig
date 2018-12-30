# *set.zig*

a set type for zig.

## usage
```zig
const std = @import("std");
const Set = @import("set").Set;

const debug = std.debug;
const assert = debug.assert;

const Edges = enum {
    Top,
    Right,
    Bottom,
    Left,
};

pub fn main() void {
    var set1 = Set(Edges).empty();
    var set2 = Set(Edges).empty();
    
    set1.incl(Edges.Top);
    set1.incl(Edges.Right);
    assert(set1.card() == 2);
    
    set2.incl(Edges.Bottom);
    set2.incl(Edges.Left);
    assert(set2.card() == 2);

    var set3 = set1.setUnion(set2);
    assert(set3.card() == 4);
    assert(set3.setIntersect(set2).card() == 2);
    assert(set3.setDifference(set1).card() == 2);
    assert(set3.inSet(Edges.Top));
}
```
