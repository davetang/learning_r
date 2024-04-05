# R package workshop
2024-04-05

- [Introduction](#introduction)
- [Getting started](#getting-started)
  - [DESCRIPTION](#description)
  - [License](#license)
- [Session information](#session-information)

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
