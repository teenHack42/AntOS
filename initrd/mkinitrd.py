#!/usr/bin/python

import sys
import os

def splitNumber (num): #splits larger numbers(more than a byte) into byte array
    lst = []
    while num > 0:
        lst.append(num & 0xFF)
        num >>= 8
    return lst[::-1]

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

HeaderLenT = 0

TLen = FileLenT + HeaderLenT

FILE_OUT = open("./initrd", 'wb')
FILE_OUT.write(bytes(splitNumber(TLen))) #total file length
FILE_OUT.seek(4)#Header Length
FILE_OUT.write(bytes(splitNumber(HeaderLenT)))#Header Lenght
FILE_OUT.seek(8)#Name length
FILE_OUT.write(bytes(splitNumber(len(imagename))))
FILE_OUT.seek(12)
FILE_OUT.write(bytearray(imagename, 'utf-8'))
next = 12 + len(imagename)
FILE_OUT.seek(next)
