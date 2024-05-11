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
const mem = @import("../mem.zig").MEM;
const setState = @import("../cpu/exu.zig").setState;
const utils = @import("../util.zig");

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

// RV32I
pub fn auipc(inst: decode.Instruction) void {
    const op = inst.auipc;
    cpu.setGPRs(op.rd, cpu.cpu.pc +% (op.imm << 12));
    return;
}

pub fn jal(inst: decode.Instruction) void {
    const op = inst.jal;
    cpu.setGPRs(op.rd, cpu.cpu.pc +% 4);
    cpu.cpu.dnpc = cpu.cpu.pc +% utils.sext(op.imm, 20);
    return;
}

pub fn jalr(inst: decode.Instruction) void {
    const op = inst.jalr;
    cpu.setGPRs(op.rd, cpu.cpu.pc +% 4);
    cpu.cpu.dnpc = cpu.GPRs(op.rs1) +% op.imm;
    return;
}

pub fn addi(inst: decode.Instruction) void {
    const op = inst.addi;
    cpu.setGPRs(op.rd, cpu.GPRs(op.rs1) +% op.imm);
    return;
}

pub fn ebreak(inst: decode.Instruction) void {
    if (inst.ebreak.halt == 1) {
        setState(true);
    } else {
        setState(false);
    }
    return;
}

// RV64I
pub fn ld(inst: decode.Instruction) void {
    const op = inst.ld;
    const addr = cpu.GPRs(op.rs1) +% op.imm;
    cpu.setGPRs(op.rd, mem.read(addr));
    return;
}

pub fn sd(inst: decode.Instruction) void {
    const op = inst.sd;
    const addr = cpu.GPRs(op.rs1) +% op.imm;
    const data = cpu.GPRs(op.rs2);
    mem.write(addr, data);
    return;
}

pub fn step(inst: decode.Instruction) MatchOp {
    return switch (inst) {
        .auipc => auipc,
        .jal => jal,
        .jalr => jalr,
        .addi => addi,
        .ld => ld,
        .sd => sd,
        .ebreak => ebreak,
        else => unreachable,
    };
}
