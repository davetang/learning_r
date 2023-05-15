#!/usr/bin/env Rscript
#
# Pipe input into R line by line
#

# the first argument to `file` is:
# 
# 1. a path to the file to be opened
# 2. a complete URL
# 3. "" (the default)
# 4. "clipboard"
# 5. "stdin" to refer to the C-level ‘standard input’ of the process
IN <- file('stdin')

# opens a connection
open(IN)

# read text lines from a connection
# `n` sets the maximal number of lines to read. Negative values indicate that
# one should read up to the end of input on the connection.
while(length(line <- readLines(IN,n=1L)) > 0){
   # write data to a file
   write(line, stderr())
}

# closes a connection
close(IN)
