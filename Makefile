#
# MIT License
#
# Copyright (c) 2020-2023 EntySec
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

ar = ar
cc = clang

objc_flags = -x objective-c -fobjc-arc

cflags = -std=c99 -I$(pwny)/include -Wall -Wextra -Werror -pedantic-errors
cflags += $(objc_flags) -arch arm64 -arch arm64e -isysroot $(sdk)

ldflags = -L$(pwny) -lpawn -lpwny -F $(sdk) -framework Foundation -framework UIKit

plugin = plugin.m
target = ictl

source = src
build = build

.PHONY: all setup plugin dylib clean

setup:
	@ mkdir -p $(build)

clean:
	@ echo [Cleaning build]
	@ rm -rf $(build)
	@ echo [Done cleaning build]

plugin:
	@ echo [Compiling plugin]
	@ $(cc) $(cflags) $(ldflags) $(plugin) -o $(build)/$(target)
	@ echo [Done compiling plugin]

dylib:
	@ echo [Compiling dylib]
	@ cd $(source); make
	@ echo [Done compiling dylib]
