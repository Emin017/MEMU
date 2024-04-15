const std = @import("std");
const vaddr = @import("../arch/rv64.zig").vaddr;
pub const Mem = @import("../mem.zig").MEM.M;

pub fn inst_fetch(pc: u64, M: *const [28]u8) u32 {
    const inst_ptr = M[pc .. pc + 4];
    var inst: u32 = 0;
    for (inst_ptr, 0..) |ptr, i| {
        inst += @as(u32, ptr) << @intCast(i * 8);
    }
    return inst;
}
