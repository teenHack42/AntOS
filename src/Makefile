#!/bin/make

# WaspOS
#Makefile for WaspOS

BASE_DIR=~/AntOS
BUILD_DIR=$(BASE_DIR)/build

# LD
LD_SCRIPT=link.ld -arch=i386 -melf_i386
LDFLAGS=-T$(LD_SCRIPT) -g

# AS / NASM
ASFLAGS=-felf32 -w+orphan-labels -g

#GCC
CFLAGS=-I $(BASE_DIR)/include -ffreestanding -m32 -g
#-nostdlib -nostdinc -g

#C Library
CLIB_PREFIX=~/opt/cross/bin
#CC=i686-elf-gcc
#LD=i686-elf-ld
CC=gcc
LD=ld

# Directory
DIRECTORY := $(sort $(dir $(wildcard ./*/)))
DIRECTORY := $(filter-out ./,$(DIRECTORY))				#filter current directory

# Sources
SOURCES := $(sort $(wildcard ./*/))						#get all files in source
SOURCES := $(filter-out ./Makefile,$(SOURCES))			#filter out Makefiles
SOURCES := $(filter-out ./Makefile~,$(SOURCES))
SOURCES := $(filter-out ./LICENSE,$(SOURCES))
SOURCES := $(filter-out ./Makefile*,$(SOURCES))
SOURCES := $(filter-out ./README*,$(SOURCES))
SOURCES := $(filter-out $(wildcard ./*~),$(SOURCES))	#filter files ending '~'
SOURCES := $(filter-out $(wildcard ./*.orig),$(SOURCES))#filter '*.orig'
SOURCES := $(filter-out $(DIRECTORY),$(SOURCES))		#filter directory names
SOURCES := $(SOURCES:.c=.o)								#we want to compile .o
SOURCES := $(SOURCES:.s=.o)
SOURCES := $(filter-out $(wildcard ./*.h),$(SOURCES))	#filter headers
SOURCES := $(filter-out ./.h,$(SOURCES))
SOURCES := $(filter-out $(wildcard ./*.ld),$(SOURCES))
SOURCES := $(filter-out ./.ld,$(SOURCES))
SOURCES := $(sort $(SOURCES))							#sort it out again

all: $(SOURCES) link

.PHONY: link
link:
	@echo "[*] Linking"
	$(LD) $(LDFLAGS) -o $(BASE_DIR)/bin/AntOS.bin boot.o $(filter-out ./boot.o, $(SOURCES)) #$(SUBDIRSRC)

.s.o:
	nasm $(ASFLAGS) $<

.PHONY: clean
clean:
	@echo "[*] Cleaning"
	@rm -f *.o
	@for c in $(DIRECTORY); do\
		$(MAKE) --no-print-directory -C $$c clean;\
	done;\
