#!/usr/bin/env Rscript
#
# Summary
#
# use as.* to convert between int (dec), hex, and oct
# use `charToRaw` to convert ASCII character to hex
#
# Char: :
# Dec:  58
# Hex:  3A
# Oct:  072
#

# helper function to print a command and its output
print_cmd <- function(cmd){
   res <- eval(parse(text = cmd))
   print(paste0('`', cmd, '`', " returns ", '`', res, '`'))
}

my_int <- 58
print_cmd("intToUtf8(my_int)")

# convert to hex
print_cmd("as.hexmode(my_int)")
my_hex <- as.hexmode(my_int)
# convert to octal
print_cmd("as.octmode(my_int)")
my_oct <- as.octmode(my_int)

print(class(my_hex))
print(class(my_oct))

print_cmd("as.integer(my_hex)")
print_cmd("as.integer(my_oct)")

# returns hex
print_cmd("charToRaw(':')")

# convert back to dec/int
print_cmd("as.integer(charToRaw(':'))")

print("ASCII table in dec/int")
print(sapply(0:127, function(x){
   paste0(x, ' = [', intToUtf8(x), ']')
}))
