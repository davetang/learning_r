Memory usage in R
================

- [Data](#data)
- [Memory usage](#memory-usage)
- [Session info](#session-info)

## Data

Create `mat1`.

``` r
num_rows <- 1000
num_cols <- 1000

mat1 <- matrix(num_rows * num_cols, nrow = num_rows, ncol = num_cols)
dim(mat1)
```

    ## [1] 1000 1000

Create `mat2`.

``` r
num_rows <- 10000
num_cols <- 10000

mat2 <- matrix(num_rows * num_cols, nrow = num_rows, ncol = num_cols)
dim(mat2)
```

    ## [1] 10000 10000

## Memory usage

`object.size` reports the space allocated for an object.

``` r
format(object.size(mat1), 'auto')
```

    ## [1] "7.6 Mb"

``` r
format(object.size(mat2), 'auto')
```

    ## [1] "762.9 Mb"

In RStudio, the [Environment
pane](https://support.posit.co/hc/en-us/articles/1500005616261-Understanding-Memory-Usage-in-the-RStudio-IDE)
will show the amount of memory used in the session. Currently it is
showing 1.05 GiB.

Remove `mat2`.

``` r
rm(mat2)
ls()
```

    ## [1] "mat1"     "num_cols" "num_rows"

The memory usage is still 1.05 GiB. Run `gc()` to cause a garbage
collection to take place.

``` r
gc()
```

    ##           used (Mb) gc trigger  (Mb)  max used  (Mb)
    ## Ncells  912325 48.8    1499938  80.2   1499938  80.2
    ## Vcells 2604438 19.9  100173530 764.3 102817469 784.5

Now the memory usage is down to 309 MiB.

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
