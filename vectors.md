Vectors
================

- [Introduction](#introduction)
  - [Atomic vectors](#atomic-vectors)
    - [Scalars](#scalars)
    - [Missing values](#missing-values)
    - [Testing and coercion](#testing-and-coercion)
  - [Attributes](#attributes)
    - [Getting and setting](#getting-and-setting)
    - [Names](#names)
    - [Dimensions](#dimensions)
  - [S3 atomic vectors](#s3-atomic-vectors)
    - [Factors](#factors)
    - [Dates](#dates)
    - [Date-times](#date-times)
    - [Durations](#durations)
  - [Session info](#session-info)

# Introduction

The most important family of data types in base R are vectors (from
Advanced R). All the other data types are known as “node” types, which
include things like functions and environments. You are most likely to
come across this highly technical term when using `gc()`: the “N” in
`Ncells` stands for nodes and the “V” in `Vcells` stands for vectors.

Vectors come in two flavours:

1.  atomic vectors and
2.  lists.

They differ in terms of their elements’ types: for atomic vectors, all
elements must have the same type; for lists, elements can have different
types. While not a vector, `NULL` is closely related to vectors and
often serves the role of a generic zero length vector.

Every vector can also have **attributes**, which you can think of as a
named list of arbitrary metadata. Two attributes are particularly
important:

1.  the **dimension** attribute turns vectors into matrices and arrays
    and
2.  the **class** attribute powers the S3 object system.

## Atomic vectors

There are four primary types of atomic vectors:

1.  logical,
2.  integer,
3.  double, and
4.  character (which contains strings).

Collectively integer and double vectors are known as numeric vectors.
There are two rare types: complex and raw.

### Scalars

Each of the four primary types has a special syntax to create an
individual value, AKA a scalar (a vector of length one):

- Logicals can be written in full (`TRUE` or `FALSE`) or abbreviated
  (`T` or `F`)
- Doubles can be specified in decimal, scientific, or hexadecimal form.
  There are three special values unique to doubles: `Inf`, `-Inf`, and
  `NaN` (not a number). These are special values defined by the floating
  point standard.
- Integers are written similarly to doubles but must be followed by `L`
  (Long integer) and can not contain fractional values
- Strings are surrounded by `"` or `'` and special characters are
  escaped with `\`.

You can determine the type of a vector with `typeof()` and its length
with `length()`.

### Missing values

R represents missing or unknown values with the special sentinel value
`NA`. Missing values tend to be infectious as most computations
involving a missing value will return another missing values. There are
only a few exceptions to this rule and these occur when some identity
holds for all possible inputs.

Propagation ofmissingness leads to a common mistake when determining
which values in a vector are missing.

``` r
x <- c(NA, 5, NA, 10)
x == NA
```

    ## [1] NA NA NA NA

The result is correct because there’s no reason to believe that **one
missing value has the same value as another**, i.e., since `NA` is an
unknown value, we can’t subset using `NA` and if we do everything is
unknown.

For testing if there are `NA`’s, use `is.na()`.

``` r
x <- c(NA, 5, NA, 10)
is.na(x)
```

    ## [1]  TRUE FALSE  TRUE FALSE

### Testing and coercion

Generally, you can **test** if a vector is of a given type with an
`is.*()` function, but these functions need to be used with care.

`is.logical()`, `is.integer()`, `is.double()`, and `is.character()` do
what you might expect, which is they test if a vector is a logical,
integer, double, or character.

Avoid `is.vector()`, `is.atomic()`, and `is.numeric()` because they
don’t test if you have a vector, atomic vector, or numeric vector. You
will need to read the documentation carefully to figure out what they
actually do.

For atomic vectors, type is a property of the entire vector: all
elements must be the same type. When you attempt to combine different
types they will be **coerced** in a fixed order:

character -\> double -\> integer -\> logical

For example, combining a character and an integer yields a character:

``` r
str(c("a", 1L))
```

    ##  chr [1:2] "a" "1"

Coercion often happens automatically and most mathematical functions
(`+`, `log`, `abs`, etc.) will coerce to numeric. This coercion is
particularly useful for logical vectors because `TRUE` becomes and
`FALSE` becomes 0.

Generally, you can deliberately coerce by using an `as.*()` function,
like `as.logical()`, `as.integer()`, `as.double()`, or `as.character()`.
Failed coercion of strings generates a warning and a missing value.

``` r
as.integer(c("1", "1.5", "a"))
```

    ## Warning: NAs introduced by coercion

    ## [1]  1  1 NA

## Attributes

You might have noticed that the set of atomic vectors does not include a
number of important data structures like matrices, arrays, factors, or
datetimes. These types are built on top of atomic vectors by adding
attributes.

### Getting and setting

You can think of attributes as name-value pairs that attach metadata to
an object. Attributes behave like named lists but are actually
pairlists; pairlists are functionally indistinguishable from lists but
are profoundly different under the hood.

Individual attributes can be:

1.  retrieved and modified with `attr()`,

``` r
a <- 1:3
# attr(x, which) <- value
# where which is a non-empty character string specifying which attribute is to be accessed.
attr(a, "x") <- "abcdef"
attr(a, "x")
```

    ## [1] "abcdef"

2.  retrieved en masse with `attributes()`, and

``` r
attr(a, "y") <- 4:6
str(attributes(a))
```

    ## List of 2
    ##  $ x: chr "abcdef"
    ##  $ y: int [1:3] 4 5 6

3.  set en masse with `structure()`.

``` r
a <- structure(
  1:3,
  x = "abcdef",
  y = 4:6
)

a
```

    ## [1] 1 2 3
    ## attr(,"x")
    ## [1] "abcdef"
    ## attr(,"y")
    ## [1] 4 5 6

``` r
class(a)
```

    ## [1] "integer"

``` r
str(attributes(a))
```

    ## List of 2
    ##  $ x: chr "abcdef"
    ##  $ y: int [1:3] 4 5 6

Attributes should generally be thought of as ephemeral. For example,
most attributes are lost by most operations.

``` r
attributes(a[1])
```

    ## NULL

There are only two attributes that are routinely preserved:

1.  **names** - a character vector giving each element a name
2.  **dim** - short for dimensions, an integer vector, used to turn
    vectors into matrices or arrays

To preserve other attributes, you will need to create your own S3 class.

### Names

You can name a vector in three ways:

1.  when creating it:

``` r
x <- c(a = 1, b = 2, c = 3)
x
```

    ## a b c 
    ## 1 2 3

2.  by assigning a character vector to `names()`:

``` r
x <- 1:3
names(x) <- c('a', 'b', 'c')
x
```

    ## a b c 
    ## 1 2 3

3.  inline with `setNames()`:

``` r
x <- setNames(1:3, c('a', 'b', 'c'))
x
```

    ## a b c 
    ## 1 2 3

Avoid using `attr(x, "names")` as it requires more typing and is less
readable than `names(x)`.

``` r
x <- 1:3
attr(x, 'names') <- c('a', 'b', 'c')
x
```

    ## a b c 
    ## 1 2 3

You can remove names from a vector by using `unname(x)` or
`names(x) <- NULL`.

To be useful with character subsetting, names should be unique and
non-missing, but this is not enforced by R. Depending on how the names
are set, missing names may be either “” or `NA_character_`. If all names
are missing, `names()` will return `NULL`.

### Dimensions

Adding a `dim` attribute to a vector allows it to behave like a
2-dimensional **matrix** or a multi-dimensional **array**. Matrices and
arrays are primarily mathematical and statistical tools, not programming
tools. Their most important feature is multidimensional subsetting.

You can create matrices and arrays with `matrix()` and `array()`, or by
using the assignment form of `dim()`.

Using `matrix()` and two scalar arguments that specify the row and
column sizes

``` r
a <- matrix(1:6, nrow = 2, ncol = 3)
a
```

    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6

``` r
class(a)
```

    ## [1] "matrix" "array"

Using a vector argument to describe all dimensions.

``` r
b <- array(1:12, c(2, 3, 4))
b
```

    ## , , 1
    ## 
    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6
    ## 
    ## , , 2
    ## 
    ##      [,1] [,2] [,3]
    ## [1,]    7    9   11
    ## [2,]    8   10   12
    ## 
    ## , , 3
    ## 
    ##      [,1] [,2] [,3]
    ## [1,]    1    3    5
    ## [2,]    2    4    6
    ## 
    ## , , 4
    ## 
    ##      [,1] [,2] [,3]
    ## [1,]    7    9   11
    ## [2,]    8   10   12

Modify an object in place by setting `dim()`:

``` r
d <- 1:6
dim(d) <- c(3, 2)
d
```

    ##      [,1] [,2]
    ## [1,]    1    4
    ## [2,]    2    5
    ## [3,]    3    6

``` r
class(d)
```

    ## [1] "matrix" "array"

Many of the functions for working with vectors have generalisations for
matrices and arrays:

| Vector            | Matrix                     | Array            |
|-------------------|----------------------------|------------------|
| `names()`         | `rownames()`, `colnames()` | `dimnames()`     |
| `length()`        | `nrow()`, `ncol()`         | `dim()`          |
| `c()`             | `rbind()`, `cbind()`       | `abind::abind()` |
| \-                | `t()`                      | `aperm()`        |
| `is.null(dim(x))` | `is.matrix()`              | `is.array()`     |

A vector without a `dim` attribute set is often thought of as
1-dimensional, but actually has `NULL` dimensions. You can also have
matrices with a single row or column, or arrays with a single dimension.
They may print similarly, but will behave differently. The differences
aren’t too important but it’s useful to know they exist in case you get
strange output from a function. As always, use `str()` to reveal the
differences.

## S3 atomic vectors

One of the most important vector attributes is `class`, which underlies
the S3 object system. Having a class attribute turns an object into an
**S3 object**, which means it will behave differently from a regular
vector when passed to a **generic** function.

Every S3 object is built on top of a base type, and often stores
additional information in other attributes. There are four important S3
vectors used in base R:

1.  Categorical data, where values come from a fixed set of levels
    recorded in **factor** vectors
2.  Dates (with day resolution), which are recorded in **Date** vectors
3.  Date-times (with second or sub-second resolution), which are stored
    in **POSIXct** vectors
4.  Durations, which are stored in **difftime** vectors

### Factors

A factor is a vector that can contain only predefined values. It is used
to store categorical data. Factors are built on top of an integer vector
with two attributes:

1.  a `class` “factor”, which makes it behave differently from regular
    integer vectors, and
2.  `levels`, which defines the set of allowed values.

``` r
x <- factor(c('a', 'b', 'b', 'a'))
x
```

    ## [1] a b b a
    ## Levels: a b

``` r
typeof(x)
```

    ## [1] "integer"

``` r
attributes(x)
```

    ## $levels
    ## [1] "a" "b"
    ## 
    ## $class
    ## [1] "factor"

Factors are useful when you know the set of possible values but they’re
not all present in a given dataset. In contrast to a character vector,
when you tabulate a factor, you’ll get counts of all categories
including the unobserved ones.

``` r
sex_char <- rep('m', 3)

sex_factor <- factor(sex_char, levels = c('m', 'f'))

table(sex_char)
```

    ## sex_char
    ## m 
    ## 3

``` r
table(sex_factor)
```

    ## sex_factor
    ## m f 
    ## 3 0

**Ordered** factors are a minor variation of factors. In general, they
behave like regular factors but the order of the levels is meaningful
like low, medium, and high; this property is automatically leveraged by
some modelling and visualisation functions.

``` r
grade <- ordered(c('b', 'b', 'a', 'a'), levels = c('c', 'b', 'a'))
grade
```

    ## [1] b b a a
    ## Levels: c < b < a

In base R you tend to encounter factors very frequently because many
base R functions automatically convert character vectors to factors.
This is sub-optimal because there is no way for those functions to know
the set of all possible levels or their correct order: the levels are a
property of theory or experimental design, not of the data. Instead, use
the argument `stringsAsFactors = FALSE` to suppress this behaviour (this
is the default nowadays), and then manually convert character vectors to
factors using your knowledge of the “theoretical” data.

While factors look like (and often behave list) character vectors, they
are built on top of integers. So be careful when treating them like
strings. Some string methods will automatically coerce factors to
strings, others will throw an error, and still others will use the
underlying integer values. For this reason, it is usually best to
explicitly convert factors to character vectors if you need string-like
behaviour.

### Dates

Date vectors are built on top of double vectors. They have class “Date”
and no other attributes.

``` r
today <- Sys.Date()
typeof(today)
```

    ## [1] "double"

``` r
attributes(today)
```

    ## $class
    ## [1] "Date"

The value of the double (which can be seen by stripping the class),
represents the number of days since 1970-01-01.

``` r
date <- as.Date("1970-02-01")
unclass(date)
```

    ## [1] 31

### Date-times

Base R provides two ways of storing date-time information, POSIXct and
POSIXlt. POSIX is short for Portable Operating System Interface, which
is a family of cross-platform standards. “ct” stands for calendar time
and “lt” for local time. Here we’ll focus on POSIXct, because it’s the
simplest, is built on top of an atomic vector, and is most appropriate
for use in data frames. POSIXct vectors are built on top of double
vectors, where the value represents the number of seconds since
1970-01-01.

``` r
now_ct <- as.POSIXct("2024-06-07 18:00", tz = "UTC")
now_ct
```

    ## [1] "2024-06-07 18:00:00 UTC"

``` r
typeof(now_ct)
```

    ## [1] "double"

``` r
attributes(now_ct)
```

    ## $class
    ## [1] "POSIXct" "POSIXt" 
    ## 
    ## $tzone
    ## [1] "UTC"

The `tzone` attribute controls only how the date-time is formatted; it
does not control the instant of time represented by the vector.

``` r
structure(now_ct, tzone = "Asia/Tokyo")
```

    ## [1] "2024-06-08 03:00:00 JST"

``` r
structure(now_ct, tzone = "Australia/Perth")
```

    ## [1] "2024-06-08 02:00:00 AWST"

### Durations

Durations, which represent the amount of time between pairs of dates or
date-times, are stored in difftimes. Difftimes are built on top of
doubles, and have a units attribute that determines how the integer
should be interpreted.

``` r
one_week_1 <- as.difftime(1, units = "weeks")
one_week_1
```

    ## Time difference of 1 weeks

``` r
typeof(one_week_1)
```

    ## [1] "double"

``` r
attributes(one_week_1)
```

    ## $class
    ## [1] "difftime"
    ## 
    ## $units
    ## [1] "weeks"

``` r
one_week_2 <- as.difftime(7, units = "days")
one_week_2
```

    ## Time difference of 7 days

``` r
typeof(one_week_2)
```

    ## [1] "double"

``` r
attributes(one_week_2)
```

    ## $class
    ## [1] "difftime"
    ## 
    ## $units
    ## [1] "days"

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
