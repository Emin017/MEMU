const std = @import("std");

pub const CPU_ERROR = error{
    InvalidRegister,
    InvalidInstruction,
    InvalidHalt,
    UnsupportedInstruction,
};

pub const CPU_STATE = struct {
    const Self = @This();
    pc: u64,
    gprs: [32]u64 = [_]u64{},
    pub fn init() !Self {
        Self.pc = 0;
        for (0..32) |i| {
            Self.gprs[i] = 0x0;
        }
    }
};

pub var cpu: CPU_STATE = undefined;

pub fn GPRs(idx: u32) u64 {
    return cpu.gprs[idx];
}

pub fn setGPRs(idx: u32, val: u64) void {
    cpu.gprs[idx] = val;
}
