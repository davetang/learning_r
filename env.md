R environments
================

- [Introduction](#introduction)
- [Session info](#session-info)

## Introduction

Create a new environment to avoid namespace collisions.

``` r
first_env <- new.env()
source("code/hello.R", local = first_env)
first_env$hello()
```

    ## [1] "Hello"

Create another new environment.

``` r
second_env <- new.env()
source("code/hello2.R", local = second_env)
second_env$hello()
```

    ## [1] "Hola"

`.GlobalEnv` is the Global Environment which is the workspace
environment where user-defined objects and functions are stored by
default. It is the environment where all objects (variables, functions,
etc.) created interactively in an R session are stored unless otherwise
specified.

``` r
.GlobalEnv
```

    ## <environment: R_GlobalEnv>

Second environment.

``` r
second_env
```

    ## <environment: 0x55c5b8c95ef0>

If we list objects in `.GlobalEnv`, we will see nothing because the
`hello()` functions are stored in different environments.

``` r
lsf.str(envir = .GlobalEnv)
```

List objects in `first_env`.

``` r
lsf.str(envir = first_env)
```

    ## hello : function ()

List objects in `second_env`.

``` r
lsf.str(envir = second_env)
```

    ## hello : function ()

## Session info

Session info.

    ## R version 4.5.0 (2025-04-11)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.2 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## time zone: Etc/UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] lubridate_1.9.4 forcats_1.0.0   stringr_1.5.1   dplyr_1.1.4    
    ##  [5] purrr_1.0.4     readr_2.1.5     tidyr_1.3.1     tibble_3.2.1   
    ##  [9] ggplot2_3.5.2   tidyverse_2.0.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.6       compiler_4.5.0     tidyselect_1.2.1   scales_1.4.0      
    ##  [5] yaml_2.3.10        fastmap_1.2.0      R6_2.6.1           generics_0.1.4    
    ##  [9] knitr_1.50         pillar_1.10.2      RColorBrewer_1.1-3 tzdb_0.5.0        
    ## [13] rlang_1.1.6        stringi_1.8.7      xfun_0.52          timechange_0.3.0  
    ## [17] cli_3.6.5          withr_3.0.2        magrittr_2.0.3     digest_0.6.37     
    ## [21] grid_4.5.0         hms_1.1.3          lifecycle_1.0.4    vctrs_0.6.5       
    ## [25] evaluate_1.0.3     glue_1.8.0         farver_2.1.2       rmarkdown_2.29    
    ## [29] tools_4.5.0        pkgconfig_2.0.3    htmltools_0.5.8.1
