# R package workshop
2024-04-05

- [Introduction](#introduction)
- [Session information](#session-information)

# Introduction

This [R package
workshop](https://combine-australia.github.io/r-pkg-dev/) was created by
COMBINE, an association for Australian students in bioinformatics,
computational biology, and related fields. It is licensed under a
[Creative Commons Attribution 4.0 International (CC BY 4.0)
license]((https://creativecommons.org/licenses/by/4.0/)).

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
