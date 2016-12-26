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
