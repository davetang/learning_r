# R package workshop
2024-04-05

- [TL;DR](#tldr)
- [Introduction](#introduction)
- [Getting started](#getting-started)
  - [DESCRIPTION](#description)
  - [License](#license)
  - [Functions](#functions)
  - [Checking your package](#checking-your-package)
  - [Documenting our function](#documenting-our-function)
  - [Testing](#testing)
- [Session information](#session-information)

# TL;DR

Install packages, check whether the system is ready to build packages,
initialise package, add license, create file to hold functions, and
check for issues.

``` r
pkgs <- c("devtools", "usethis", "roxygen2", "testthat", "knitr", "ggplot2", "rlang")
install.packages(pkgs, Ncpus = 2)
pkgbuild::check_build_tools()

usethis::create_package(path = '/tmp/mypkg')
usethis::use_mit_license("Dave Tang")
usethis::use_r("colours")
devtools::document()
usethis::use_testthat()
usethis::use_test("colours")
devtools::check()
```

# Introduction

This [R package
workshop](https://combine-australia.github.io/r-pkg-dev/) was created by
COMBINE, an association for Australian students in bioinformatics,
computational biology, and related fields. It is licensed under a
[Creative Commons Attribution 4.0 International (CC BY 4.0)
license](https://creativecommons.org/licenses/by/4.0/).

An R package is a collection of functions that are bundled together in a
way that makes it easy to share. Usually these functions are designed to
work together to complete a specific task such as analysing a particular
kind of data. Packages are the best way to distribute code and
documentation; even if you never intend to share your package it is
useful to have a place to store your commonly used functions. It’s a bit
more effort now but it will save you a lot of time in the long run.

This workshop teaches a modern package development workflow that makes
use of packages designed to help with writing packages. The two main
packages are {devtools} and {usethis}:

- {devtools} contains functions that will help with development tasks
  such as checking, building and installing packages.
- {usethis} contains a range of templates and handy functions for making
  life easier, many of which were originally in {devtools}.

Other packages used in this workshop include:

- {roxygen2} for function documentation
- {testthat} for writing unit tests
- {knitr} for building vignettes

Install the required packages for this workshop.

``` r
pkgs <- c("devtools", "usethis", "roxygen2", "testthat", "knitr", "ggplot2", "rlang")
install.packages(pkgs, Ncpus = 2)
```

Some stages of the package development process can require other
programs to be installed on your computer. To check that you have
everything you need run the following:

``` r
pkgbuild::check_build_tools()
```

    Your system is ready to build packages!

# Getting started

To begin building a package, we need a package name; names can only
consist of letters, numbers and dots (.) and must start with a letter.
While all of these are allowed it is generally best to stick to just
lowercase letters. Having a mix of lower and upper case letters can be
hard for users to remember (is it RColorBrewer or Rcolorbrewer or
rcolorbrewer?). For this workshop, we are going to use {mypkg}.

To create a template for our package, use `usethis::create_package()`.

``` r
usethis::create_package(path = '/tmp/mypkg')
```

Several files get created.

``` bash
ls -R /tmp/mypkg
```

    /tmp/mypkg:
    DESCRIPTION
    mypkg.Rproj
    NAMESPACE
    R

    /tmp/mypkg/R:

- `DESCRIPTION` contains the metadata for your package.
- `NAMESPACE` describes the functions in our package; it should not be
  manually edited.
- `mypkg.Rproj` is a RStudio project file.
- `R` is the directory that will hold all our R code.

These files are the minimal amount that is required for a package but we
will create other files as we go along. Some other useful (hidden) files
have also been created by {usethis}:

- `.gitignore` is useful if you use `git` for version control.
- `.Rbuildignore` is used to mark files that are in the directory but
  aren’t really part of the package and shouldn’t be included when we
  build it. Most of the time you won’t need to worry about this as
  {usethis} will edit it for you.

## DESCRIPTION

The `DESCRIPTION` file is one of the most important parts of a package.
It contains all the metadata about the package, things like what the
package is called, what version it is, a description, who the authors
are, what other packages it depends on, etc.

``` bash
cat /tmp/mypkg/DESCRIPTION
```

    Package: mypkg
    Title: What the Package Does (One Line, Title Case)
    Version: 0.0.0.9000
    Authors@R: 
        person("First", "Last", , "first.last@example.com", role = c("aut", "cre"),
               comment = c(ORCID = "YOUR-ORCID-ID"))
    Description: What the package does (one paragraph).
    License: `use_mit_license()`, `use_gpl3_license()` or friends to pick a
        license
    Encoding: UTF-8
    Roxygen: list(markdown = TRUE)
    RoxygenNote: 7.3.1

- The `Title` should be a single line in Title Case that explains what
  your package is.
- The `Description` is a paragraph which goes into a bit more detail
  about what the package does.

The `Authors@R` field shows an example of how to define an author. You
can see that the example person has been assigned the author (“aut”) and
creator (“cre”) roles. There must be at least one author and one creator
for every package (they can be the same person) and the creator must
have an email address. Other roles include:

- `cre`: the creator or maintainer of the package, the person who should
  be contacted when there are problems
- `aut`: authors, people who have made significant contributions to the
  package
- `ctb`: contributors, people who have made smaller contributions
- `cph`: copyright holder, useful if this is someone other than the
  creator (such as their employer)

## License

The software license describes how our code can be used and without one
people must assume that it can’t be used at all! For this example we
will use the MIT license which basically says the code can be used for
any purpose and doesn’t come with any warranties. There are templates
for some of the most common licenses included in {usethis}.

``` r
usethis::use_mit_license("Dave Tang")
```

## Functions

Use `usethis::use_r()` to create an empty file in `R` to hold our
function about colours.

``` r
usethis::use_r("colours")
```

There are no rules about how to organise your functions into different
files but in general similar functions should be grouped together into
the same file with a clear name. Putting all functions into a single
file is not ideal but neither is having a separate file for each
function. A good rule of thumb is that if you are finding it hard to
locate a function you might need to move it to a new file.

The example for this workshop is a function that takes the red, green
and blue values for a colour and returns a given number of shades. Save
the function below into `R/colours.R`.

``` r
make_shades <- function(colour, n, lighter = TRUE) {
  # Convert the colour to RGB
  colour_rgb <- grDevices::col2rgb(colour)[, 1]
  
  # Decide if we are heading towards white or black
  if (lighter) {
    end <- 255
  } else {
    end <- 0
  }
  
  # Calculate the red, green and blue for the shades
  # we calculate one extra point to avoid pure white/black
  red   <- seq(colour_rgb[1], end, length.out = n + 1)[1:n]
  green <- seq(colour_rgb[2], end, length.out = n + 1)[1:n]
  blue  <- seq(colour_rgb[3], end, length.out = n + 1)[1:n]
  
  # Convert the RGB values to hex codes
  shades <- grDevices::rgb(red, green, blue, maxColorValue = 255)
  
  return(shades)
}
```

Usually when we write a new function we load it by copying the code to
the console or sourcing the R file. When we are developing a package we
want to try and keep our environment empty so that we can be sure we are
only working with objects inside the package. Instead we can load
functions using `devtools::load_all()`.

## Checking your package

The `devtools::check()` function runs a series of checks to make sure
your package is working correctly. It is highly recommended that you run
`devtools::check()` often and follow its advice to fix any problems.

``` r
devtools::check()
```

You will see all the different types of checks that {devtools} has run
but the most important section is at the end where it tells you how many
errors, warnings, and notes there are.

- Errors happen when your code has broken and failed one of the checks.
  If errors are not fixed your package will not work correctly.
- Warnings are slightly less serious but should also be addressed. Your
  package will probably work without fixing them but it is highly
  advised that you do.
- Notes are advice rather than problems. It can be up to you whether or
  not to address them but there is usually a good reason to.

Often the failed checks come with hints about how to fix them but
sometimes they can be hard to understand.

## Documenting our function

The {roxygen2} package makes it easy to document our function by writing
some special comments at the start of our function. This has the extra
advantage of keeping the documentation with the code which make it
easier to keep it up to date.

If you are using RStudio, open the “Code” menu and select “Insert
Roxygen skeleton”, which will create the template shown below. The
parameters were automatically generated.

``` r
#' Title
#'
#' @param colour 
#' @param n 
#' @param lighter 
#'
#' @return
#' @export
#'
#' @examples
```

Roxygen comments all start with `#'`. The first line is the title of the
function followed by a blank line. Next is a paragraph that provides a
more detailed description of the function.

The next section describes the parameters for the function marked by the
`@param` field.

The next field is `@return`, which is used to describe what the function
returns. This is usually fairly short but you should provide enough
detail to make sure that the user knows what they are getting back.

The next field is `@export` and is a bit different because it doesn’t
add documentation to the help file but instead modifies the `NAMESPACE`
file. Adding `@export` tells {Roxygen} that this is a function that we
want to be available to the user. When we build the documentation,
{Roxygen} will then add the correct information to the `NAMESPACE` file.
If we had an internal function that wasn’t meant to be used by the user
we would leave out `@export`.

The last field in the skeleton is `@examples` and is where we put some
short examples showing how the function can be used. These will be
placed in the help file and can be run using `example("function")`.

``` r
#' Make shades
#'
#' Given a colour make n lighter or darker shades
#' 
#' @param colour The colour to make shades of
#' @param n The number of shades to make
#' @param lighter Whether to make lighter (TRUE) or darker (FALSE) shades
#'
#' @return A vector of n colour hex codes
#' @export
#'
#' @examples
#' # Five lighter shades
#' make_shades("goldenrod", 5)
#' # Five darker shades
#' make_shades("goldenrod", 5, lighter = FALSE)
```

There are other useful fields such as `@author` (specify the function
author), `@references` (any associated references) and `@seealso` (links
to related functions).

Use `devtools::document()` to build the documentation.

``` r
devtools::document()
```

## Testing

Unit tests are checks to make sure that a function works in the way that
we expect. The examples in the documentation act like informal unit
tests because they are run as part of the checking process but it is
better to have something more rigorous.

One approach to writing unit tests is what is known as “test driven
development”. The idea is to write the tests before you write a
function. This way you know exactly what a function is supposed to do
and what problems there might be. While this is a good principal it can
take a lot of advance planning.

A more common approach could be called “bug-driven testing”. For this
approach whenever we come across a bug we write a test for it before we
fix it, that way the same bug should never happen a again. When combined
with some tests for obvious problems this is a good compromise between
testing for every possible outcome and not testing at all.

For example, let’s see what happens when we ask `make_shades()` for a
negative number of shades.

``` r
make_shades("goldenrod", -1)
```

    Error in seq(colour_rgb[1], end, length.out = n + 1)[1:n]: only 0's may be mixed with negative subscripts

Before we make any changes to the function let’s design some tests to
make sure we get what we expect. There are a few ways to write unit
tests for R packages but we are going to use the {testthat} package. We
can set everything up with {usethis}.

``` r
usethis::use_testthat()
```

A `tests/` directory will be created to hold all our tests. There is
also a `tests/testthat.R` file which looks like this:

``` r
# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(mypkg)

test_check("mypkg")
```

The above script makes sure that our tests are run with
`devtools::check()`. To open a new test file use `usethis::use_test()`.

``` r
usethis::use_test("colours")
```

# Session information

``` r
sessionInfo()
```

    R version 4.3.2 (2023-10-31)
    Platform: x86_64-pc-linux-gnu (64-bit)
    Running under: Ubuntu 22.04.3 LTS

    Matrix products: default
    BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0

    locale:
     [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
     [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
     [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
     [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
     [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

    time zone: Etc/UTC
    tzcode source: system (glibc)

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    other attached packages:
     [1] lubridate_1.9.3 forcats_1.0.0   stringr_1.5.0   dplyr_1.1.3    
     [5] purrr_1.0.2     readr_2.1.4     tidyr_1.3.0     tibble_3.2.1   
     [9] ggplot2_3.5.0   tidyverse_2.0.0

    loaded via a namespace (and not attached):
     [1] gtable_0.3.4      jsonlite_1.8.7    compiler_4.3.2    tidyselect_1.2.0 
     [5] callr_3.7.3       scales_1.3.0      yaml_2.3.7        fastmap_1.1.1    
     [9] R6_2.5.1          generics_0.1.3    knitr_1.45        munsell_0.5.0    
    [13] pillar_1.9.0      tzdb_0.4.0        rlang_1.1.3       utf8_1.2.4       
    [17] stringi_1.7.12    xfun_0.40         timechange_0.2.0  cli_3.6.1        
    [21] withr_2.5.1       magrittr_2.0.3    ps_1.7.5          processx_3.8.2   
    [25] digest_0.6.33     grid_4.3.2        rstudioapi_0.15.0 hms_1.1.3        
    [29] lifecycle_1.0.3   vctrs_0.6.4       evaluate_0.22     glue_1.6.2       
    [33] pkgbuild_1.4.4    fansi_1.0.5       colorspace_2.1-0  rmarkdown_2.25   
    [37] tools_4.3.2       pkgconfig_2.0.3   htmltools_0.5.8  
