#!/usr/bin/env Rscript
#
# Pass command line arguments to Rscript without using any additional packages
# like optparse.
#
# ./argv.R --help --no -gamma 15 test -a test2 -d 20 test3

# From the documentation
# trailingOnly is a logical (FALSE by default). Should only arguments after
# --args be returned?
args <- commandArgs(trailingOnly = FALSE)
print("trailingOnly = FALSE")
print(args)

# if trailingOnly is set to TRUE, command line arguments will be stored after
# `--args` and the other arguments are no longer present
# note that args does not get destroyed
args <- commandArgs(trailingOnly = TRUE)
print("trailingOnly = TRUE")
print(args)
print(paste0("Class of args: ", class(args)))

# check if arguments were passed
if (length(args)==0) {
  message("No arguments passed")
}

#' Parse parameter declaration
#'
#' `get_args()` parses a GNU getopt styled string that declares the optional
#' parameters and whether or not they accept values. For example:
#'
#  `getopt -a -o abhc:d: --long alpha,beta,help,gamma:,delta: -- "$@"`
#'
#' The function works for both short and long argument declarations.
#'
#' @param x string declaring parameter declaration
#' @param my_delim delimiter used for splitting `x`
#'
#' @return A named logical vector
#'
#' @examples
#' get_args('abhc:d:o')
#' get_args('alpha,beta,help,gamma:,delta:,omega', ',')
get_args <- function(x, my_delim = ""){
  my_args <- vector()
  my_names <- vector(mode = "character")
  my_split <- unlist(strsplit(x, split = my_delim))
  # split the colon in long arguments
  my_split <- unlist(
    sapply(my_split, function(x){
      if(grepl("\\w+:$", x)){
        return(c(sub(":$", "", x), ":"))
      } else {
        return(x)
      }
    })
  )
  for(i in 1:(length(my_split))){
    if(my_split[i] == ":"){
      next
    }
    if(i < length(my_split) && my_split[i+1] == ":"){
      my_args <- append(my_args, TRUE)
    } else {
      my_args <- append(my_args, FALSE)
    }
    my_names <- append(my_names, my_split[i])
  }
  names(my_args) <- my_names
  return(my_args)
}
 
my_args <- get_args('abhc:d:o')
my_args <- append(my_args, get_args('alpha,beta,help,gamma:,delta:,omega', ','))

# once the for loop starts I can't modify `i`
# use a `switch` to skip over values that should be input for arguments
switch <- FALSE

my_opts <- list()
my_pos <- vector(mode = "character")
for (i in 1:(length(args))){
  if(switch){
    switch <- FALSE
    next
  }
  arg <- args[i]
  if (grepl("^-", arg)){
    arg_ <- sub("^--*", "", arg)
    if(arg_ %in% names(my_args)){
      message(paste0(arg, " is a recognised flag"))
      my_val <- TRUE
      if(my_args[arg_]){
        message(paste0(arg, " accepts a value which should be ", args[i+1]))
        my_val <- args[i+1]
        switch <- TRUE
      }
      my_opts[[arg_]] <- my_val
    } else {
      message(paste0(arg, " is an unrecognised flag"))
    }
  } else {
    message(paste0(arg, " is a positional argument"))
    my_pos <- append(my_pos, arg)
  }
}

# optional arguments
print(my_opts)
# positional arguments
print(my_pos)