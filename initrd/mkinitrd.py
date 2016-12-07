#!/usr/bin/python

import sys
import os

def splitNumber (num): #splits larger numbers(more than a byte) into byte array
    lst = []
    while num > 0:
        lst.append(num & 0xFF)
        num >>= 8
    return lst[::-1]

def fout (by):
	FILE_OUT.write(by)

def myroundup(x, base=4):
	y = x
	z = int(base * round(float(y)/base))
	if y < z:
		z += base
	return z

FILE_OUT = None

if len(sys.argv) == 1:
	print("Error: Provide config file as first argument")
	exit(1)

if len(sys.argv) > 0:
	configfile = open(sys.argv[1], 'r')

imagename = ''
FilesIN = []
FilesIMG = []
filecount = 0
for line in configfile:
	if 'file:' in line:
		filecount += 1
		cut = line.split(":")#split the command from the arguments
		cut.remove("file")#remove command from list
		cut = cut[0].split(" ")#split the two arguments
		if len(cut) < 2:
			cut.append('/' + cut[0])
			cut[0] = cut[0].replace("\n", '') #remove the newline from the end of the last argument
		cut[1] = cut[1].replace("\n", '') #remove the newline from the end of the last argument
		FilesIN.append(cut[0])
		FilesIMG.append(cut[1])
		print("file: " + FilesIN[filecount-1] + " -> " + FilesIMG[filecount-1])

	if 'name:' in line:
		cut = line.split(":")#split the command from the arguments
		cut.remove("name")#remove command from list
		cut[0] = cut[0].replace("\n", '') #remove the newline from the end of the last argument
		imagename = cut[0]
		print("name: " + imagename)

FilePnt = []
FileLen = []
FileLenT = 0
for file in FilesIN:
	f = open(file, 'r')
	FilePnt.append(f)
	length = os.path.getsize(file)
	FileLenT += length
	FileLen.append(length)

HeaderLenT = 12 + len(imagename)

TLen = FileLenT + HeaderLenT

FILE_OUT = open("./initrd", 'wb')
fout(bytes(splitNumber(0x16120720)))
FILE_OUT.seek(4)
fout(bytes(splitNumber(TLen))) #total file length
FILE_OUT.seek(8)#Header Length
fout(bytes(splitNumber(HeaderLenT)))#Header Lenght
FILE_OUT.seek(12)#Name length
fout(bytes(splitNumber(len(imagename))))
FILE_OUT.seek(16)
fout(bytearray(imagename, 'utf-8'))
ftable = 16 + len(imagename)
fileoff = ftable + 4
FILE_OUT.seek(ftable)

TOffset = []

tableoffset = 0
for file, flen in zip(FilesIMG, FileLen):
	TOffset.append(tableoffset)
	FILE_OUT.seek(ftable + tableoffset + 0)
	fout(bytes(splitNumber(0)))#ofset from start of file
	FILE_OUT.seek(ftable + tableoffset + 4)
	fout(bytes(splitNumber(flen)))#length of file from offset
	FILE_OUT.seek(ftable + tableoffset + 8)
	fout(bytes(splitNumber(len(file))))#length of file name from end of entry
	FILE_OUT.seek(ftable + tableoffset + 12)
	fout(bytearray(file, 'utf-8'))
	tableoffset += 12 + len(file)

data = ftable + tableoffset
doffset = 0
countfile = 0
for file, flen, toffset in zip(FilePnt, FileLen, TOffset):
	off = data + doffset
	off = myroundup(off, 8)
	FILE_OUT.seek(off)
	dloc = data + doffset
	fout(bytearray(file.read(flen), 'utf-8'))#specify length so we get what we expect
	doffset += flen
	FILE_OUT.seek(ftable + tableoffset + 0)
	fout(bytes(splitNumber(0)))#ofset from start of file


footeroff = data + doffset + 8

footeroff = myroundup(footeroff, 8)
FILE_OUT.seek(footeroff)
fout(bytearray("AntInitRD1Foot56", 'utf-8'))
