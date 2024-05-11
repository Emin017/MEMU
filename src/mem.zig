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

pub const MEM = struct {
    pub const base = 0x80000000;
    pub const size = 0x8000000;
    pub const img: [28]u8 = [_]u8{ 0x13, 0x05, 0x00, 0x00, 0x93, 0x05, 0x10, 0x04, 0x73, 0x00, 0x10, 0x00, 0x13, 0x05, 0x10, 0x00, 0x93, 0x05, 0x00, 0x00, 0x73, 0x00, 0x10, 0x00, 0x6f, 0x00, 0x00, 0x00 };
    pub var memory = std.mem.zeroes([size]u8);
    pub fn read(addr: u64) u32 {
        return @as(u32, memory[addr][0..4]);
    }
};

const filePath = "imgfile/prog.bin";

pub fn initMem() void {
    const memSlice: []u8 = MEM.memory[0..];
    std.mem.copyForwards(u8, memSlice, @embedFile(filePath));
}
