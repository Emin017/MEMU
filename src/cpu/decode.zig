const std = @import("std");
const isa = @import("../arch/rv64.zig");
const vaddr_t = isa.vaddr_t;
const word_t = isa.word_t;
const testing = std.testing;
const expect = std.testing.expect;
const print = @import("../common.zig").print;

const DECODE_TYPE = enum {
    TYPE_I,
    TYPE_U,
    TYPE_S,
    TYPE_J,
    TYPE_R,
    TYPE_B,
    TYPE_C,
    TYPE_N,
};

pub const Decode = struct {
    pc: vaddr_t,
    snpc: vaddr_t, // static next pc
    dnpc: vaddr_t, // dynamic next pc
    inst: u32,
};

fn BITSMASK(hi: u5, lo: u5) u32 {
    return ((@as(u32, 1) << (hi - lo + 1)) - 1) << lo;
}

fn BITS(x: u32, hi: u5, lo: u5) u32 {
    const mask = BITSMASK(hi, lo);
    return (x & mask) >> @intCast(lo);
}

pub fn decode_operand(s: *Decode, dest: *word_t, src1: *word_t, src2: *word_t, inst_type: *word_t, imm: *word_t) void {
    const i: u32 = s.*.inst;
    const rd: u32 = BITS(i, 11, 7);
    const rs1: u32 = BITS(i, 19, 15);
    const rs2: u32 = BITS(i, 24, 20);
    const opcode: u32 = BITS(i, 6, 0);
    const imm_i: u32 = BITS(i, 31, 20);
    dest.* = rd;
    src1.* = rs1;
    src2.* = rs2;
    inst_type.* = opcode;
    imm.* = imm_i;
}

test "decode_operand" {
    var s: Decode = undefined;
    s.inst = 0x00000033;
    var dest: word_t = undefined;
    var src1: word_t = undefined;
    var src2: word_t = undefined;
    var opcode: word_t = undefined;
    decode_operand(&s, &dest, &src1, &src2, &opcode);
    print("dest: {}, src1: {}, src2: {}, opcode: {}\n", .{ dest, src1, src2, opcode });
    try testing.expect(dest == 0);
    try testing.expect(src1 == 0);
    try testing.expect(src2 == 0);
    try testing.expect(opcode == 51);
}
