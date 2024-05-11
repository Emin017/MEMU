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
const c = @import("cpu.zig");
const print = @import("../util.zig").print;

pub const regs: [32][]const u8 = [_][]const u8{ "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6" };

pub fn regname2idx(name: []const u8) usize {
    for (regs, 0..) |reg, i| {
        if (std.mem.eql(u8, reg, name)) {
            return i;
        }
    }
    return 1;
}

pub fn displayReg() void {
    for (regs) |reg| {
        const idx: usize = regname2idx(reg);
        print("{s} value:{x}\t", .{ reg, c.cpu.gprs[idx] });
        if ((idx + 1) % 4 == 0) {
            print("\n", .{});
        }
    }
}
