#!/bin/bash

.PHONY: all
all:
	@make -C src
	@make -f Makefile-ISO

.PHONY: clean
clean:
	@echo "[*] Cleaning "
	@make -C src clean
