#!/bin/bash

.PHONY: all
all:
	@echo "[*] Starting build"
	@make -C src
	@echo "[*] Creating ISO"
	@make -f Makefile-ISO
	@echo "[*] DONE!"

.PHONY: clean
clean:
	@echo "[*] Cleaning "
	@make -C src clean

qemu:
	qemu-system-i386 -serial stdio -cdrom AntOS.iso -d guest_errors

qemu-mon:
	qemu-system-i386 -monitor stdio -cdrom AntOS.iso -d guest_errors
