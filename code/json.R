#!/usr/bin/env Rscript

# https://github.com/jeroen/jsonlite
library(jsonlite)

# convert JSON to a data frame
my_json <- fromJSON("../data/ace2.archs4.json")
str(my_json)
