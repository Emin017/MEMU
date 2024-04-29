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

run:
	$(MAKE) -C $(IMG_DIR) compile
	zig run src/main.zig

decode:
	zig test src/cpu/decode.zig

ifu:
	zig test src/cpu/ifu.zig

fmt:
	zig fmt src/*.zig

