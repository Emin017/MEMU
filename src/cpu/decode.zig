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
const isa = @import("../arch/rv64.zig");
const vaddr_t = isa.vaddr_t;
const word_t = isa.word_t;
const testing = std.testing;
const expect = std.testing.expect;
const print = @import("../common.zig").print;
const cpu = @import("./cpu.zig");
const utils = @import("../util.zig");

pub const decodeError = error{
    InvalidInstruction,
};
pub const Decode = struct {
    pc: vaddr_t,
    snpc: vaddr_t, // static next pc
    dnpc: vaddr_t, // dynamic next pc
    inst: u32,
};

pub const TypeB = struct {
    imm: u32,
    rs1: u32,
    rs2: u32,
    rd: u32,
};

pub const TypeI = struct {
    imm: u32,
    rs1: u32,
    rd: u32,
    pub fn decode(inst: u32) TypeI {
        const imm: u32 = utils.BITS(inst, 31, 20);
        const rs1: u32 = utils.BITS(inst, 19, 15);
        const rd: u32 = utils.BITS(inst, 11, 7);
        return TypeI{
            .imm = imm,
            .rs1 = rs1,
            .rd = rd,
        };
    }
    pub fn Operand(funct3: u32) !Operand {
        return switch (funct3) {
            0 => Operand.addi,
            else => unreachable,
        };
    }
};

pub const TypeEnv = struct {
    ebreak: u32,
    ret: u64,
    halt: u32,
    const inst_ebreak: u32 = 0b00000000000100000000000001110011;
    pub fn decode(inst: u32) TypeEnv {
        // Halt emu when is ebreak
        if (inst == inst_ebreak) {
            if (cpu.GPRs(10) == 1) return TypeEnv{ .ebreak = 1, .ret = cpu.GPRs(10), .halt = 1 } else return TypeEnv{ .ebreak = 1, .ret = cpu.GPRs(10), .halt = 0 };
        }
        return TypeEnv{ .ebreak = 0, .ret = cpu.GPRs(10), .halt = 0 };
    }
};

pub const Instruction = union(enum) {
    addi: TypeI,
    ebreak: TypeEnv,

    pub fn DecodePattern(op: anytype, val: anytype) Instruction {
        return @unionInit(Instruction, @tagName(op), val); // Return the union with the tag name of the operation and the value
    }

    pub fn decode32(inst: u32) anyerror!Instruction {
        const opcode: u32 = utils.BITS(inst, 6, 0);
        return switch (opcode) {
            0b0010011 => DecodePattern(.addi, TypeI.decode(inst)),
            0b1110011 => DecodePattern(.ebreak, TypeEnv.decode(inst)),
            else => decodeError.InvalidInstruction,
        };
    }
};
