#!/usr/bin/env Rscript

r_major <- as.numeric(R.version$major)
r_minor <- as.numeric(R.version$minor)

if(r_major >= 4 && r_minor >= 1){
   library(jsonlite)
   library(ggplot2)
} else {
   stop("Requires R-4.1.0 or higher")
}

IN <- file('stdin')
open(IN)
infile <- readLines(IN)
close(IN)

expr <- fromJSON(infile)

sapply(expr$id, function(x) strsplit(x, split = "\\.")) |>
  as.data.frame() |>
  t() |>
  as.data.frame() -> metadata

cap_first <- function(x){
  s <- strsplit(x, "")[[1]][1]
  return(sub(s, toupper(s), x))
}

row.names(metadata) <- NULL
colnames(metadata) <- c('root', 'system', 'organ', 'tissue')
metadata$tissue <- tolower(metadata$tissue)
metadata$tissue <- sapply(metadata$tissue, cap_first)

data <- cbind(metadata, expr)
wanted <- c('system', 'tissue', 'min', 'q1', 'median', 'q3', 'max')
data_sub <- data[, wanted]

data_sub <- data_sub[order(data_sub$system), ]
data_sub$tissue <- factor(data_sub$tissue, levels = data_sub$tissue)

ggplot(
  data_sub,
  aes(
    x = tissue,
    ymin = min,
    lower = q1,
    middle = median,
    upper = q3,
    ymax = max,
    fill = system
  )
) +
  geom_boxplot(stat = 'identity') +
  theme_minimal() +
  theme(
    legend.position = 'right',
    axis.title.x = element_blank(),
    axis.text.x = element_text(angle = 70, hjust = 1)
  ) +
  labs(y = "Expression") -> p

ggsave("expr.png", p, bg = "white", width = 3000, height = 1600, units = "px")
