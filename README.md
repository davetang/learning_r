## Introduction

This README was generated by running `readme.Rmd` in RStudio Server.

Install packages if missing and load.

``` r
.libPaths('/packages')
my_packages <- 'beepr'

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package, '/packages')
   }
  library(my_package, character.only = TRUE)
}
```

## Learning R

> "To understand computations in R, two slogans are helpful:
>
> -   Everything that exists is an object.
> -   Everything that happens is a function call."
>
> --John Chambers

### Vectors

R is a vectorised language and what this means is that you can perform
operations on vectors without having to iterate through each element. A
vector is simply "a single entity consisting of a collection of things"
but these items must all belong to the same class. If you try to create
a vector with different classes, the vector will be coerced in the
following order: `logical` \< `integer` \< `numeric` \< `character`.

``` r
my_char <- c(1, 3.14, TRUE, 'str')
class(my_char)
```

    ## [1] "character"

``` r
my_num <- c(1, 2, 3.14, 4)
class(my_num)
```

    ## [1] "numeric"

You can easily square each number in a vector by applying a exponential
function.

``` r
my_int <- 1:6
my_int^2
```

    ## [1]  1  4  9 16 25 36

You can operate on a vector using another vector too. If the right
vector isn't the same length as the left vector but is a multiple, R
performs a procedure called "recycling" that will re-use the right
vector on the next set of values.

``` r
my_int + c(1, 2)
```

    ## [1] 2 4 4 6 6 8

Named vectors can be used as simple lookup tables.

``` r
my_lookup <- c(
  "HKG" = "Hong Kong",
  "PNG" = "Papua New Guinea",
  "AUS" = "Australia",
  "JPN" = "Japan"
)

my_lookup["PNG"]
```

    ##                PNG 
    ## "Papua New Guinea"

### Lists

Unlike vectors, lists can be used to store heterogeneous things.

``` r
my_list <- list(
  my_func = function(x){x^2},
  my_df = data.frame(a = 1:3),
  my_vec = 1:6
)

my_list$my_func(my_list$my_vec)
```

    ## [1]  1  4  9 16 25 36

`lapply` can be used to apply a function to each item in a list and will
return a list.

``` r
my_list <- list(
  a = 1:3,
  b = 4:10,
  c = 11:20
)

lapply(my_list, sum)
```

    ## $a
    ## [1] 6
    ## 
    ## $b
    ## [1] 49
    ## 
    ## $c
    ## [1] 155

Another handy function is the `do.call` function, which constructs and
executes a function call on a list. The example below is useful for
converting a list into a matrix.

``` r
my_list <- list(
  a = 1:3,
  b = 4:6,
  c = 7:9
)

# returns a matrix
do.call(what = rbind, args = my_list)
```

    ##   [,1] [,2] [,3]
    ## a    1    2    3
    ## b    4    5    6
    ## c    7    8    9

There is also the
[purrr::map](https://purrr.tidyverse.org/reference/map.html) function,
that is
[similar](https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html)
to the apply functions in base R, but you explicitly specify the output
type. The `map_lgl` function will return logicals, i.e. Booleans.

``` r
map_lgl(.x = 1:10, .f = function(x) x > 5)
```

    ##  [1] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE

### Objects.

[Base types](https://adv-r.hadley.nz/base-types.html).

### Useful tips

When asking for help online, it is useful to include a minimal example
that includes some data specific to your question. To easily convert
data into code, use the `dput()` function. The example below is just for
illustrative purposes since the `women` dataset is included with R, so
you would not need to generate code for it.

``` r
dput(women)
```

    ## structure(list(height = c(58, 59, 60, 61, 62, 63, 64, 65, 66, 
    ## 67, 68, 69, 70, 71, 72), weight = c(115, 117, 120, 123, 126, 
    ## 129, 132, 135, 139, 142, 146, 150, 154, 159, 164)), class = "data.frame", row.names = c(NA, 
    ## -15L))

### Hacks

There are probably better ways to do the following, which is why I have
labelled them as hacks, so follow at your own peril.

### Library paths

Some R packages require libraries not included in the default library
path. Use `Sys.setenv` to include additional library paths. First we'll
get the default path.

``` r
Sys.getenv("LD_LIBRARY_PATH")
```

    ## [1] "/usr/local/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/local/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/include"

Now we will add `/usr/include` to `LD_LIBRARY_PATH` and get the updated
library path.

``` r
new_path <- paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", "/usr/include")
Sys.setenv("LD_LIBRARY_PATH" = new_path)
Sys.getenv("LD_LIBRARY_PATH")
```

    ## [1] "/usr/local/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/local/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/include:/usr/include"

## Session info

Time built.

    ## [1] "2022-12-27 02:35:30 UTC"

Session info.

    ## R version 4.2.2 (2022-10-31)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 22.04.1 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ##  [1] beepr_1.3       forcats_0.5.2   stringr_1.5.0   dplyr_1.0.10   
    ##  [5] purrr_0.3.5     readr_2.1.3     tidyr_1.2.1     tibble_3.1.8   
    ##  [9] ggplot2_3.4.0   tidyverse_1.3.2
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.2.0    xfun_0.35           haven_2.5.1        
    ##  [4] gargle_1.2.1        colorspace_2.0-3    vctrs_0.5.1        
    ##  [7] generics_0.1.3      htmltools_0.5.4     yaml_2.3.6         
    ## [10] utf8_1.2.2          rlang_1.0.6         pillar_1.8.1       
    ## [13] withr_2.5.0         glue_1.6.2          DBI_1.1.3          
    ## [16] dbplyr_2.2.1        modelr_0.1.10       readxl_1.4.1       
    ## [19] audio_0.1-10        lifecycle_1.0.3     munsell_0.5.0      
    ## [22] gtable_0.3.1        cellranger_1.1.0    rvest_1.0.3        
    ## [25] evaluate_0.19       knitr_1.41          tzdb_0.3.0         
    ## [28] fastmap_1.1.0       fansi_1.0.3         broom_1.0.2        
    ## [31] scales_1.2.1        backports_1.4.1     googlesheets4_1.0.1
    ## [34] jsonlite_1.8.4      fs_1.5.2            hms_1.1.2          
    ## [37] digest_0.6.31       stringi_1.7.8       grid_4.2.2         
    ## [40] cli_3.4.1           tools_4.2.2         magrittr_2.0.3     
    ## [43] crayon_1.5.2        pkgconfig_2.0.3     ellipsis_0.3.2     
    ## [46] xml2_1.3.3          reprex_2.0.2        googledrive_2.0.0  
    ## [49] lubridate_1.9.0     timechange_0.1.1    assertthat_0.2.1   
    ## [52] rmarkdown_2.19      httr_1.4.4          rstudioapi_0.14    
    ## [55] R6_2.5.1            compiler_4.2.2
