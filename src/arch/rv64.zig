const std = @import("std");

pub const word_t = u64;
pub const vaddr_t = u64;
pub const paddr_t = u64;

// decode
pub const riscv64_ISADecodeInfo = packed struct {
    const inst = union {
        val: u32,
    };
};
