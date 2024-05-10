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

var halt = false;

pub fn exu_cycle() void {
    const inst: u32 = ifu.inst_fetch(c.cpu.pc, &M.memory);
    var failed: anyerror = undefined;
    const inst_test: ?decode.Instruction = decode.Instruction.decode32(inst) catch |err| {
        failed = err;
        return;
    };
    const exu = isa.inst2exu(inst_test.?);
    const ret = exu(inst_test.?);
    _ = ret;
}

pub fn ishalt() bool {
    return halt;
}

pub fn setState(x: bool) void {
    if (x) {
        halt = true;
    } else {
        halt = false;
    }
    return;
}
