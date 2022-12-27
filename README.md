Learning R
================

- <a href="#learning-r" id="toc-learning-r">Learning R</a>
  - <a href="#vectors" id="toc-vectors">Vectors</a>
  - <a href="#lists" id="toc-lists">Lists</a>
  - <a href="#objects" id="toc-objects">Objects</a>
  - <a href="#general" id="toc-general">General</a>
  - <a href="#useful-plots" id="toc-useful-plots">Useful plots</a>
  - <a href="#useful-tips" id="toc-useful-tips">Useful tips</a>
    - <a href="#getting-help" id="toc-getting-help">Getting help</a>
  - <a href="#hacks" id="toc-hacks">Hacks</a>
    - <a href="#library-paths" id="toc-library-paths">Library paths</a>
    - <a href="#variables-and-objects"
      id="toc-variables-and-objects">Variables and objects</a>
  - <a href="#session-info" id="toc-session-info">Session info</a>

# Learning R

The three core features of R are object-orientation, vectorisation, and
its functional programming style.

> “To understand computations in R, two slogans are helpful:
>
> - Everything that exists is an object.
> - Everything that happens is a function call.”
>
> –John Chambers

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

## Vectors

R is a vectorised language and what this means is that you can perform
operations on vectors without having to iterate through each element. A
vector is simply “a single entity consisting of a collection of things”
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
vector isn’t the same length as the left vector but is a multiple, R
performs a procedure called “recycling” that will re-use the right
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

## Lists

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

## Objects

[Base types](https://adv-r.hadley.nz/base-types.html).

## General

Assign a data frame column `NULL` to delete it.

``` r
my_df <- data.frame(
  a = 1:3,
  b = 4:6,
  c = c(6, 6, 6)
)

my_df$c <- NULL

my_df
```

    ##   a b
    ## 1 1 4
    ## 2 2 5
    ## 3 3 6

Include an additional directory (`/packages`) to look for and install R
packages.

``` r
.libPaths('/packages')
```

Use `identical` to check whether two objects are exactly equal. Most
times it should suffice to just use `all.equal`.

``` r
first <- 1:5
second <- c(1, 2, 3, 4, 5)

# this is false because first is a vector of integers
# and second is a vector of numerics
identical(first, second)
```

    ## [1] FALSE

``` r
all.equal(first, second)
```

    ## [1] TRUE

Set `scipen` (default is 0), which is a penalty to be applied when
deciding to print numeric values in fixed or exponential notation, to
determine when to print in exponential notation. (`.Options` contains
all other options settings.)

``` r
options(scipen=0)
10e4
```

    ## [1] 1e+05

``` r
options(scipen=1)
10e4
```

    ## [1] 100000

Use `system.time()` to measure how long a block of codes takes to
execute.

``` r
system.time(
  for (i in 1:100000000){}
)
```

    ##    user  system elapsed 
    ##   1.226   0.000   1.226

The `with` function evaluates an expression with data.

``` r
my_df <- data.frame(
  a=1:10,
  b=11:20,
  c=21:30
)
wanted <- with(my_df, a > 5 & c > 27)
my_df[wanted, ]
```

    ##     a  b  c
    ## 8   8 18 28
    ## 9   9 19 29
    ## 10 10 20 30

The `which` function is a very useful for returning indicates that are
`TRUE` and works with matrices.

``` r
my_mat <- matrix(1:9, nrow=3, byrow = TRUE)

# note that the results are ordered by col
which(my_mat > 5, arr.ind = TRUE)
```

    ##      row col
    ## [1,]   3   1
    ## [2,]   3   2
    ## [3,]   2   3
    ## [4,]   3   3

The `match` function can be used with vectors to return the indexes of
matching items and an `NA` is no match was found.

``` r
x <- c('b', 'c', 'a', 'd')
y <- letters[1:3]

match(x, y)
```

    ## [1]  2  3  1 NA

You can use `match` to subset and order a data frame.

``` r
my_df <- data.frame(
  a = 1:10,
  b = letters[1:10]
)

x <- c(2, 10, 5, 6)
x_match <- match(x, my_df$a)

my_df[x_match, ]
```

    ##     a b
    ## 2   2 b
    ## 10 10 j
    ## 5   5 e
    ## 6   6 f

Use the `complete.cases` function to list observations that have no
missing values, i.e. NA values.

``` r
my_df <- data.frame(
  a = 1:3,
  b = c(4, NA, 6),
  c = 7:9
)

complete.cases(my_df)
```

    ## [1]  TRUE FALSE  TRUE

Use `commandArgs` to accept command line arguments without having to
install an external package like `optparse`.

``` r
args <- commandArgs(TRUE)
```

## Useful plots

Visualise a table.

``` r
mosaicplot(table(ChickWeight$Time, ChickWeight$Diet), main = "Timepoint versus diet")
```

![](img/mosaicplot-1.png)<!-- -->

## Useful tips

A lot of R books are free to read; check out the
[bookdown](https://bookdown.org/) page to see some of the best R books.

R has four special values:

1.  `NA` - used for representing missing data.
2.  `NULL` - represents not having a value and unlike `NA`, it is its
    own object and cannot be used in a vector.
3.  `Inf`/`-Inf` - used for representing numbers too big for R (see
    below).
4.  `NaN` - used for storing results that are not a number.

Check the `.Machine` variable to find out the numerical characteristics
of the machine R is running on, such as the largest double or integer
and the machine’s precision.

``` r
noquote(unlist(format(.Machine)))
```

    ##                double.eps            double.neg.eps               double.xmin 
    ##              2.220446e-16              1.110223e-16             2.225074e-308 
    ##               double.xmax               double.base             double.digits 
    ##             1.797693e+308                         2                        53 
    ##           double.rounding              double.guard         double.ulp.digits 
    ##                         5                         0                       -52 
    ##     double.neg.ulp.digits           double.exponent            double.min.exp 
    ##                       -53                        11                     -1022 
    ##            double.max.exp               integer.max               sizeof.long 
    ##                      1024                2147483647                         8 
    ##           sizeof.longlong         sizeof.longdouble            sizeof.pointer 
    ##                         8                        16                         8 
    ##            longdouble.eps        longdouble.neg.eps         longdouble.digits 
    ##              1.084202e-19              5.421011e-20                        64 
    ##       longdouble.rounding          longdouble.guard     longdouble.ulp.digits 
    ##                         5                         0                       -63 
    ## longdouble.neg.ulp.digits       longdouble.exponent        longdouble.min.exp 
    ##                       -64                        15                    -16382 
    ##        longdouble.max.exp 
    ##                     16384

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

Show all the functions of a package.

``` r
ls("package:stringr")
```

    ##  [1] "%>%"               "boundary"          "coll"             
    ##  [4] "fixed"             "fruit"             "invert_match"     
    ##  [7] "regex"             "sentences"         "str_c"            
    ## [10] "str_conv"          "str_count"         "str_detect"       
    ## [13] "str_dup"           "str_ends"          "str_equal"        
    ## [16] "str_escape"        "str_extract"       "str_extract_all"  
    ## [19] "str_flatten"       "str_flatten_comma" "str_glue"         
    ## [22] "str_glue_data"     "str_interp"        "str_length"       
    ## [25] "str_like"          "str_locate"        "str_locate_all"   
    ## [28] "str_match"         "str_match_all"     "str_order"        
    ## [31] "str_pad"           "str_rank"          "str_remove"       
    ## [34] "str_remove_all"    "str_replace"       "str_replace_all"  
    ## [37] "str_replace_na"    "str_sort"          "str_split"        
    ## [40] "str_split_1"       "str_split_fixed"   "str_split_i"      
    ## [43] "str_squish"        "str_starts"        "str_sub"          
    ## [46] "str_sub_all"       "str_sub<-"         "str_subset"       
    ## [49] "str_to_lower"      "str_to_sentence"   "str_to_title"     
    ## [52] "str_to_upper"      "str_trim"          "str_trunc"        
    ## [55] "str_unique"        "str_view"          "str_view_all"     
    ## [58] "str_which"         "str_width"         "str_wrap"         
    ## [61] "word"              "words"

Search is useful to list the search path, i.e. where R will look, for R
objects such as functions.

``` r
search()
```

    ##  [1] ".GlobalEnv"        "package:beepr"     "package:forcats"  
    ##  [4] "package:stringr"   "package:dplyr"     "package:purrr"    
    ##  [7] "package:readr"     "package:tidyr"     "package:tibble"   
    ## [10] "package:ggplot2"   "package:tidyverse" "package:stats"    
    ## [13] "package:graphics"  "package:grDevices" "package:utils"    
    ## [16] "package:datasets"  "package:methods"   "Autoloads"        
    ## [19] "package:base"

### Getting help

Get help on a class.

``` r
?"numeric-class"
```

Get information on a package.

``` r
library(help="stringr")
```

Finding out what methods are available for a class.

``` r
methods(class="lm")
```

    ##  [1] add1           alias          anova          case.names     coerce        
    ##  [6] confint        cooks.distance deviance       dfbeta         dfbetas       
    ## [11] drop1          dummy.coef     effects        extractAIC     family        
    ## [16] formula        fortify        hatvalues      influence      initialize    
    ## [21] kappa          labels         logLik         model.frame    model.matrix  
    ## [26] nobs           plot           predict        print          proj          
    ## [31] qr             residuals      rstandard      rstudent       show          
    ## [36] simulate       slotsFromS3    summary        variable.names vcov          
    ## see '?methods' for accessing help and source code

Search the help pages.

``` r
help.search("cross tabulate")
```

Search for function containing keyword.

``` r
apropos("mutate")
```

    ## [1] "mutate"       "mutate_"      "mutate_all"   "mutate_at"    "mutate_each" 
    ## [6] "mutate_each_" "mutate_if"

## Hacks

There are probably better ways to do the following, which is why I have
labelled them as hacks, so follow at your own peril.

### Library paths

Some R packages require libraries not included in the default library
path. Use `Sys.setenv` to include additional library paths. First we’ll
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

### Variables and objects

Sometimes you want to create objects with values stored in variables.
This can be achieved using `assign()`.

``` r
my_varname <- 'one_to_ten'
my_values <- 1:10
assign(my_varname, my_values)

one_to_ten
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

Likewise, sometimes you want to store an object’s name into a variable.
This can be achieved using `substitute` (returns the parse tree for an
unevaluated expression) and `deparse` (turns unevaluated expressions
into character strings).

``` r
obj_to_string <- function(x){
   deparse(substitute(x))
}

my_obj_name <- 1984
my_var <- obj_to_string(my_obj_name)

my_var
```

    ## [1] "my_obj_name"

To evaluating a string, use `parse` (returns an unevaluated expression)
with a `text` argument specifying the character vector and `eval`
(evaluates an unevaluated expression).

``` r
eval(parse(text = my_var))
```

    ## [1] 1984

## Session info

This README was generated by running `readme.Rmd` in RStudio Server.

    ## [1] "2022-12-27 05:48:06 UTC"

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
    ## [28] fastmap_1.1.0       fansi_1.0.3         highr_0.9          
    ## [31] broom_1.0.2         scales_1.2.1        backports_1.4.1    
    ## [34] googlesheets4_1.0.1 jsonlite_1.8.4      fs_1.5.2           
    ## [37] hms_1.1.2           digest_0.6.31       stringi_1.7.8      
    ## [40] grid_4.2.2          cli_3.4.1           tools_4.2.2        
    ## [43] magrittr_2.0.3      crayon_1.5.2        pkgconfig_2.0.3    
    ## [46] ellipsis_0.3.2      xml2_1.3.3          reprex_2.0.2       
    ## [49] googledrive_2.0.0   lubridate_1.9.0     timechange_0.1.1   
    ## [52] assertthat_0.2.1    rmarkdown_2.19      httr_1.4.4         
    ## [55] rstudioapi_0.14     R6_2.5.1            compiler_4.2.2
