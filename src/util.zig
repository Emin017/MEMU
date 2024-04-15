const std = @import("std");

pub const print = std.debug.print;

pub fn putchar(c: u8) void {
    std.os.write(std.os.Stdout, &c, 1);
}
