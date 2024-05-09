CSRCS = $(wildcard *.c)
EMU_CC ?= riscv64-linux-gnu-gcc
EMU_OBJCOPY ?= riscv64-linux-gnu-objcopy

compile:
	@echo "Compiling..."
	$(EMU_CC) -march=rv64g -ffreestanding -nostdlib -static -Wl,-Ttext=0 -O2 -o prog $(CSRCS)
	$(EMU_OBJCOPY) -O binary --only-section=.text prog prog.bin
	@echo "Compilation complete."
