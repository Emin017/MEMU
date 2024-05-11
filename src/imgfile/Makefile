CSRCS = $(wildcard *.c)
EMU_CC ?= riscv64-linux-gnu-gcc
EMU_OBJCOPY ?= riscv64-linux-gnu-objcopy
OUT_BIN = dummy

compile:
	@echo "Compiling..."
	$(EMU_CC) -march=rv64g -ffreestanding -nostdlib -static -Wl,-Ttext=0x80000000 -O2 -o $(OUT_BIN) $(CSRCS)
	$(EMU_OBJCOPY) -O binary --only-section=.text $(OUT_BIN) $(OUT_BIN).bin
	@echo "Compilation complete."
