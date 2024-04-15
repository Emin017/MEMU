const std = @import("std");
const print = std.debug.print;

var printf_buf: [1024]u8 = undefined;
pub fn printf(comptime format: []const u8, args: anytype) void {
    const slice = std.fmt.bufPrint(printf_buf[0..], format, args) catch @panic("bufPrint failure");
    print(slice);
}
