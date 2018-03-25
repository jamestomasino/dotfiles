#!/bin/sh
# Centers a text document as a whole, preserving indentation of
# each line, across the width of the terminal.

# get width of longest line in text file
w=$(awk '{if(length>L){L=length}}END{print L}' < "$1")
# get terminal width
c=$(tput cols)
# output file to stdout, offset to center all content
awk -v l="$(((c - w)/2))" '{printf "%*s%s\n",l,"",$0}' "$1"
