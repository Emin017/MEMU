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
const c = @import("cpu/cpu.zig");
const halt = @import("cpu/exu.zig").ishalt;
const check = @import("cpu/exu.zig").check;
const initMemory = @import("mem.zig").initMem;

pub const displayReg = @import("cpu/reg.zig").displayReg;
pub const cycle = @import("cpu/exu.zig").execute;

pub fn main() anyerror!void {
    c.cpu.pc = 0x80000000;
    initMemory();
    while (!halt()) {
        c.cpu.dnpc = c.cpu.pc + 4;
        cycle() catch |err| {
            std.debug.print("Error in instruction cycle !\n", .{});
            std.debug.print("Error TYPE ID: {}\n", .{err});
            break;
        };
        c.cpu.pc = c.cpu.dnpc;
    }
    if (check()) {
        std.debug.print("Program executed successfully !\n", .{});
    } else {
        std.debug.print("Program execution failed !\n", .{});
    }
    displayReg();
}
