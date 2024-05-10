// Copyright (c) 2024 Emin
// MEMU is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//          http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

const std = @import("std");

pub const print = std.debug.print;

pub fn putchar(c: u8) void {
    std.os.write(std.os.Stdout, &c, 1);
}

pub inline fn CONCACT(a: u32, b: u32) u64 {
    return @intCast(a << 32 | b);
}

pub fn BITSMASK(hi: u5, lo: u5) u32 {
    return ((@as(u32, 1) << (hi - lo + 1)) - 1) << lo;
}

pub fn BITS(x: u32, hi: u5, lo: u5) u32 {
    const mask = BITSMASK(hi, lo);
    return (x & mask) >> @intCast(lo);
}
