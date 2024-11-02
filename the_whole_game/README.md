# README

Based on [The Whole Game](https://r-pkgs.org/whole-game.html).

Initiate new package from an active R session by using the {devtools} package.

```r
install.packages("devtools")
library(devtools)
```

1. `create_package(/tmp/regexcite)`

Write a function in RStudio session.

```r
strsplit1 <- function(x, split) {
  strsplit(x, split = split)[[1]]
}
```

2. The helper `use_r()` creates and/or opens a script below `R/`. It will put the definition of `strsplit1()` and only the definition of `strsplit1()` in `R/strsplit1.R` and save it.

```r
use_r("strsplit1")
```
