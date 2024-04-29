CSRCS = $(wildcard *.c)
CC ?= riscv64-linux-gnu-gcc
OBJCOPY ?= riscv64-linux-gnu-objcopy

compile:
	@echo "Compiling..."
	@riscv64-linux-gnu-gcc -march=rv64g -ffreestanding -nostdlib -static -Wl,-Ttext=0 -O2 -o prog $(CSRCS)
	@riscv64-linux-gnu-objcopy -O binary --only-section=.text prog prog.bin
	@echo "Compilation complete."
