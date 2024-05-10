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
const decode = @import("../cpu/decode.zig");
const cpu = @import("../cpu/cpu.zig");
const setState = @import("../cpu/exu.zig").setState;

pub const word_t = u64;
pub const vaddr_t = u64;
pub const paddr_t = u64;

// decode
pub const riscv64_ISADecodeInfo = packed struct {
    const inst = union {
        val: u32,
    };
};

pub const MatchOp = *const fn (inst: decode.Instruction) void;

pub fn addi(inst: decode.Instruction) void {
    const op = inst.addi;
    cpu.setGPRs(op.rd, cpu.GPRs(op.rs1) +% op.imm);
    return;
}

pub fn ebreak(inst: decode.Instruction) void {
    if (inst.ebreak.halt == 1) {
        // std.debug.print("is halt:{}\n", .{inst.ebreak.halt});
        setState(true);
    } else {
        const out: u8 = @intCast(cpu.cpu.gprs[11] & 0xff);
        std.debug.print("{c}", .{out});
        setState(false);
    }
    return;
}

pub fn inst2exu(inst: decode.Instruction) MatchOp {
    return switch (inst) {
        .addi => addi,
        .ebreak => ebreak,
    };
}
