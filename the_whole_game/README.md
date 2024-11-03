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

3. To test `strsplit1()` for package development, {devtools} offers the `load_all()` function to make `strsplit1()` available for experimentation.

```r
load_all()
```

`load_all()` has made the `strsplit1()` function available, although it does not exist in the global environment. `load_all()` simulates the process of building, installing, and attaching a package. As your package accumulates more functions, some exported, some not, some of which call each other, some of which call functions from packages you depend on, `load_all()` gives you a much more accurate sense of how the package is developing than test driving functions defined in the global environment.

```r
exists("strsplit1", where = globalenv(), inherits = FALSE)
```
```
 [1] FALSE
```

4. `check()` is a convenient way to run `R CMD check`, which is the gold standard for checking that an R package is in full working order, in your R session. `check()` is meant for interactive consumption and it is essential to actually read the output of the check! Deal with problems early and often.

5. The `DESCRIPTION` file provides metadata about your package. Below is an example:

```
Package: regexcite
Title: Make Regular Expressions More Exciting
Version: 0.0.0.9000
Authors@R:
    person("Jane", "Doe", , "jane@example.com", role = c("aut", "cre"))
Description: Convenience functions to make some common tasks with string
    manipulation and regular expressions a bit easier.
License: `use_mit_license()`, `use_gpl3_license()` or friends to pick a
    license
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.1.2
```


