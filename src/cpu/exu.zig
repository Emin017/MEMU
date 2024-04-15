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

const M = @import("../mem.zig").MEM.M;
const c = @import("cpu.zig");
const Decode = @import("decode.zig").Decode;
const decode = @import("decode.zig").decode_operand;
const word_t = @import("../arch/rv64.zig").word_t;
const print = @import("../common.zig").print;
const ifu = @import("ifu.zig");

var halt = false;

pub fn exu_cycle() void {
    const inst: u32 = ifu.inst_fetch(c.cpu.pc, &M);
    var s: Decode = undefined;
    s.inst = inst;
    var dest: word_t = undefined;
    var src1: word_t = undefined;
    var src2: word_t = undefined;
    var opcode: word_t = undefined;
    var imm_i: word_t = undefined;
    decode(&s, &dest, &src1, &src2, &opcode, &imm_i);
    const nrZero: bool = if (dest != 0) true else false;
    const addi: bool = if ((inst & 0x7f) == 0x13 and ((inst >> 12 & 0x7)) == 0) true else false;
    const ebreak: bool = if ((inst & 0x00100073) != 0) true else false;
    if (addi) {
        if (nrZero) {
            c.setGPRs(@intCast(dest), c.cpu.gprs[src1] + imm_i);
        }
    } else if (ebreak) {
        if (c.cpu.gprs[10] == 0) {
            const out: u8 = @intCast(c.cpu.gprs[11] & 0xff);
            const str = std.fmt.digitToChar(@intCast(out - 'A' + 10), std.fmt.Case.upper);
            print("{c}" ++ "\n", .{str});
        } else if (c.cpu.gprs[10] == 1) {
            halt = true;
        } else {
            print("Unsupported ebreak command\n", .{});
        }
    } else {
        print("Unsupported instruction\n", .{});
    }
}

pub fn isHalt() bool {
    return halt;
}
