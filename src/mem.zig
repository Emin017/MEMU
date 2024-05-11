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

    pub fn paddr(addr: u64) u64 {
        std.debug.print("addr:{x}\n", .{addr});
        return addr - base;
    }

    pub fn read(addr: u64) u32 {
        //TODO: implement read
        _ = addr;
        return 0;
    }

    pub fn write(addr: u64, data: u64) void {
        std.debug.print("writing to Mem addr: {x} data:{x}\n", .{ addr, data });
        const memSlice: []u8 = MEM.memory[0..];
        var value: u64 = data;
        const b: *[@sizeOf(@TypeOf(value))]u8 = @ptrCast(&value);
        std.mem.copyForwards(u8, memSlice[paddr(addr)..], b);
    }
};

const filePath = "imgfile/dummy.bin";

pub fn initMem() void {
    const memSlice: []u8 = MEM.memory[0..];
    std.mem.copyForwards(u8, memSlice, @embedFile(filePath));
}
