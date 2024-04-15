run:
	zig run src/main.zig

decode:
	zig test src/cpu/decode.zig

ifu:
	zig test src/cpu/ifu.zig

fmt:
	zig fmt src/*.zig

