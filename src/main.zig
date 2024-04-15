const std = @import("std");
const c = @import("cpu/cpu.zig");
const halt = @import("cpu/exu.zig").isHalt;

pub const reg_display = @import("cpu/reg.zig").reg_display;
pub const inst_cycle = @import("cpu/exu.zig").exu_cycle;

pub fn main() void {
    c.cpu.pc = 0;
    while (!halt()) {
        inst_cycle();
        c.cpu.pc += 4;
    }
    reg_display();
}
