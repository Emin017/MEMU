# Copyright (c) 2024 Emin
# MEMU is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

IMG_DIR ?= src/imgfile
BUILD_DIR ?= zig-out
BIN_DIR ?= $(BUILD_DIR)/bin

build:
	zig build -j`nproc` -Doptimize=ReleaseFast

test-img:
	$(MAKE) -C $(IMG_DIR) compile

run: build test-img
	$(BIN_DIR)/memu

test: test-img
	zig run src/main.zig

decode:
	zig test src/cpu/decode.zig

ifu:
	zig test src/cpu/ifu.zig

fmt:
	zig fmt src/*.zig

clean:
	rm -rf $(BUILD_DIR)/ zig-cache/

.default: build
.PHONY: build test-img run test decode ifu fmt clean
