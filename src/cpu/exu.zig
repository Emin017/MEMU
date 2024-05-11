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

const M = @import("../mem.zig").MEM;
const c = @import("cpu.zig");
const decode = @import("decode.zig");
const word_t = @import("../arch/rv64.zig").word_t;
const print = @import("../util.zig").print;
const ifu = @import("ifu.zig");
const isa = @import("../arch/rv64.zig");

const state = struct {
    halt: bool,
    good: bool,
};
var cpuState = state{ .halt = false, .good = false };

pub fn execute() anyerror!void {
    const inst: u32 = ifu.instfetch(c.cpu.pc, &M.memory);
    const inst_test: ?decode.Instruction = decode.Instruction.decode32(inst) catch |err| {
        std.debug.print("Unknown instruction: {x}\n", .{inst});
        return err;
    };
    const step = isa.step(inst_test.?);
    const ret = step(inst_test.?);
    _ = ret;
}

pub fn ishalt() bool {
    return cpuState.halt;
}

pub fn check() bool {
    return cpuState.good;
}

pub fn setState(x: bool) void {
    if (x) {
        cpuState.good = true;
    } else {
        cpuState.good = false;
    }
    cpuState.halt = true;
    return;
}
