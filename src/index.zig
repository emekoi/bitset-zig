//  Copyright (c) 2018 emekoi
//
//  This library is free software; you can redistribute it and/or modify it
//  under the terms of the MIT license. See LICENSE for details.
//

pub fn Set(comptime T: type) type {
    return struct {
        const Self = @This();
        const Storage = @IntType(false, @memberCount(T));

        data: Storage,

        pub fn empty() Self {
            return Self {
                .data = Storage(0),
            };
        }

        pub fn universal() Self {
            return Self {
                .data = ~Storage(0),
            };   
        }

        pub fn incl(self: *Self, x: T) void {
            // @ptrCast([*]u1, &self.data)[@enumToInt(x)] = 1;
            self.data |= Storage(1) << @enumToInt(x);
        }
        
        pub fn excl(self: *Self, x: T) void {
            // @ptrCast([*]u1, &self.data)[@enumToInt(x)] = 0;
            self.data &= ~(Storage(1) << @enumToInt(x));
        }

        pub fn card(self: Self) usize {
            return @intCast(usize, @popCount(self.data));
        }

        pub fn inSet(self: Self, x: T) bool {
            // return @ptrCast([*]const u1, &self.data)[@enumToInt(x)] == 1;
            return ((self.data >> @enumToInt(x)) & Storage(1)) == Storage(1);
        }

        pub fn setEqual(self: Self, x: Self) bool {
            return self.data == x.data;
        }

        pub fn setSubset(self: Self, x: Self, proper: bool) bool {
            if (proper and self.setEqual(x)) {
                return false;
            } else {
                return (self.data & x.data) == self.data;
            }
        }

        pub fn setUnion(self: Self, x: Self) Self {
            return Self {
                .data = self.data | x.data,
            };
        }

        pub fn setDifference(self: Self, x: Self) Self {
            return Self {
                .data = (self.data ^ x.data) & self.data,
            };
        }

        pub fn setSymDifference(self: Self, x: Self) Self {
            return Self {
                .data = (self.data ^ x.data),
            };
        }
        
        pub fn setIntersect(self: Self, x: Self) Self {
            return Self {
                .data = self.data & x.data,
            };
        }

        pub fn setComplement(self: Self) Self {
            return Self {
                .data = ~self.data,
            };
        }
    };
}

test "Set" {
    const std = @import("std");
    const debug = std.debug;
    const assert = debug.assert;

    const Edges = enum {
        Top,
        Right,
        Bottom,
        Left,
    };

    var set1 = Set(Edges).empty();
    set1.incl(Edges.Top);
    set1.incl(Edges.Right);
    assert(set1.card() == 2);

    var set2 = Set(Edges).empty();
    set2.incl(Edges.Bottom);
    set2.incl(Edges.Left);
    assert(set2.card() == 2);

    var set3 = set1.setUnion(set2);
    assert(set3.card() == 4);
    assert(set3.setIntersect(set2).card() == 2);
    assert(set3.setDifference(set1).card() == 2);
    assert(set3.inSet(Edges.Top));
}

test "Set (comptime)" {
    const std = @import("std");
    const debug = std.debug;
    const assert = debug.assert;

    const Edges = enum {
        Top,
        Right,
        Bottom,
        Left,
    };

    comptime {
        var set1 = Set(Edges).empty();
        set1.incl(Edges.Top);
        set1.incl(Edges.Right);
        assert(set1.card() == 2);

        var set2 = Set(Edges).empty();    
        set2.incl(Edges.Bottom);
        set2.incl(Edges.Left);
        assert(set2.card() == 2);


        var set3 = set1.setUnion(set2);
        assert(set3.card() == 4);
        assert(set3.setIntersect(set2).card() == 2);
        assert(set3.setDifference(set1).card() == 2);
        assert(set3.inSet(Edges.Top));
    }   
}
