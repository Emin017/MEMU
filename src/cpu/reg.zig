const std = @import("std");
const c = @import("cpu.zig");
const print = @import("../util.zig").print;

pub const regs: [32][]const u8 = [_][]const u8{ "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6" };

pub fn reg_name2idx(name: []const u8) usize {
    for (regs, 0..) |reg, i| {
        if (std.mem.eql(u8, reg, name)) {
            return i;
        }
    }
    return 1;
}

pub fn reg_display() void {
    for (regs) |reg| {
        const idx: usize = reg_name2idx(reg);
        print("{s} value:{d}\t", .{ reg, c.cpu.gprs[idx] });
        if ((idx + 1) % 4 == 0) {
            print("\n", .{});
        }
    }
}
