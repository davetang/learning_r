Learning R
================

-   [Introduction](#introduction)
    -   [Vectors](#vectors)
    -   [Lists](#lists)
    -   [Functions](#functions)
        -   [Function components](#function-components)
        -   [Lexical scoping](#lexical-scoping)
        -   [Lazy evaluation](#lazy-evaluation)
        -   [dot-dot-dot](#dot-dot-dot)
        -   [Exiting a function](#exiting-a-function)
        -   [Function forms](#function-forms)
    -   [Objects](#objects)
    -   [Modeling example](#modeling-example)
        -   [R formula](#r-formula)
    -   [General](#general)
    -   [Useful plots](#useful-plots)
    -   [Useful tips](#useful-tips)
        -   [Getting help](#getting-help)
    -   [Hacks](#hacks)
        -   [Library paths](#library-paths)
        -   [Variables and objects](#variables-and-objects)
    -   [Session info](#session-info)

# Introduction

The three core features of R are object-orientation, vectorisation, and
its functional programming style.

> “To understand computations in R, two slogans are helpful:
>
> -   Everything that exists is an object.
> -   Everything that happens is a function call.”
>
> –John Chambers

Install packages if missing and load.

``` r
.libPaths('/packages')
my_packages <- c('tidyverse', 'modeldata')

for (my_package in my_packages){
   if(!require(my_package, character.only = TRUE)){
      install.packages(my_package, '/packages')
   }
  library(my_package, character.only = TRUE)
}
theme_set(theme_bw())
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

## Functions

Notes from [Advanced R](https://adv-r.hadley.nz/functions.html).

Two important ideas about functions in R need to be understood:

1.  Functions can be broken down into three components: arguments, body,
    and environment
2.  Functions are objects, just as vectors are objects

R functions are objects in their own right, a language property often
called “first-class functions”.

### Function components

A function has three parts:

1.  The `formals()`, which are the list of arguments that control how
    you call the function.
2.  The `body()`, which is the code inside the function.
3.  The `environment()`, which is the data structure that determines the
    namespace.

The environment is based on where you define the function.

``` r
f02 <- function(x, y){
  # comment
  x + y
}

formals(f02)
```

    ## $x
    ## 
    ## 
    ## $y

``` r
body(f02)
```

    ## {
    ##     x + y
    ## }

``` r
environment(f02)
```

    ## <environment: R_GlobalEnv>

Functions contain any number of additional `attributes()` as with all
objects in R. One attribute used by base R is `srcref`, which points to
the source code used to create the function.

``` r
attr(f02, "srcref")
```

    ## function(x, y){
    ##   # comment
    ##   x + y
    ## }

However primitive functions do not have the three components (they
return `NULL`) and call C code directly.

``` r
sum
```

    ## function (..., na.rm = FALSE)  .Primitive("sum")

Primitive functions have either type `builtin` or type `special` but
have class `function`.

``` r
class(f02)
```

    ## [1] "function"

``` r
class(sum)
```

    ## [1] "function"

``` r
class(`[`)
```

    ## [1] "function"

``` r
typeof(f02)
```

    ## [1] "closure"

``` r
typeof(sum)
```

    ## [1] "builtin"

``` r
typeof(`[`)
```

    ## [1] "special"

### Lexical scoping

Scoping is the act of finding the value associated with a name. R uses
lexical scoping, which means it looks up the values of names based on
how a function is defined and not by how it is called. Lexical in this
context means that the scoping rules use a parse-time, rather than a
run-time, structure. R’s lexical scoping follows four primary rules:

1.  Name masking
2.  Functions versus variables
3.  A fresh start - each time you invoke a function, it starts fresh
4.  Dynamic lookup

The basic principle of lexical scoping is that names defined inside a
function mask names defined outside a function. If a name is not defined
inside a function, R looks one level up (all the way up to the global
environment). Lexical scoping determines where, but not when to look for
values. *R looks for values when the function is run and not when the
function is created*.

### Lazy evaluation

Function arguments are only evaluated if accessed, i.e. lazily
evaluated. This is a nice feature because it allows the inclusion of
potentially expensive computations in function arguments that will only
be evaluated if necessary.

Lazy evaluation is powered by a data structure called a **promise**,
which has three components:

1.  An expression, like `x + y`, which gives rise to the delayed
    computation.
2.  An environment where the expression should be evaluated, i.e. the
    environment where the function is called.
3.  A value, which is computed and cached the first time a promise is
    accessed when the expression is evaluated in the specified
    environment.

### dot-dot-dot

Functions can have a special argument `...`, which is pronounced
dot-dot-dot. In other programming languages, this type of argument is
often called `varargs` (variable arguments) and a function that uses it
is said to be variadic.

``` r
i01 <- function(y, z) {
  list(y = y, z = z)
}

i02 <- function(x, ...) {
  i01(...)
}

str(i02(x = 1, y = 2, z = 3))
```

    ## List of 2
    ##  $ y: num 2
    ##  $ z: num 3

The `...` is useful when a function takes a function as an argument: you
can pass additional arguments to that function. The downside of using
`...` is that when arguments are used to pass arguments to another
function, it is sometimes not clear to the user. Also a misspelled
argument will not raise an error and this makes it easy for typos to go
unnoticed.

### Exiting a function

Most functions exit in one of two ways:

1.  They either return a value, indicating success. There are two ways a
    function can return a value:
    1.  Implicitly, where the last evaluated expression is returned.
    2.  Explicitly by using `return()`.
2.  They throw an error, indicating failure.

Most functions return visibly, meaning that the result is printed when
evaluated in an interactive context. The automatic printing can be
prevented by using `invisible()` but the return value still exists.

If a function cannot complete its assigned task, it should throw an
error with `stop()`, which immediately terminates the execution of the
function. `on.exit()` can be used to run some code regardless of how a
function exits; always set `add = TRUE` when using `on.exit()` because
if you don’t each call to `on.exit()` will overwrite the previous exit
handler.

### Function forms

Function calls come in four varieties:

1.  **prefix**: the function name comes before its arguments,
    e.g. `sum(1:5)`. These constitute the majority of function calls in
    R
2.  **infix**: the function name comes in between its arguments,
    e.g. `x + y`. Infix forms are used for many mathematical operators
    and for user-defined functions that begin and end with `%`.
3.  **replacement**: functions that replace values by assignment,
    e.g. `names(my_df) <- c('a', 'b', 'c')`.
4.  **special**: functions like `[[`, `if`, and `for` that do not have a
    consistent structure.

All functions can be written in prefix form.

``` r
x <- 1900
y <- 84
x + y
```

    ## [1] 1984

``` r
`+`(x, y)
```

    ## [1] 1984

``` r
df <- data.frame(a = 1, b = 2, c= 3)
`names<-`(df, c("x", "y", "z"))
```

    ##   x y z
    ## 1 1 2 3

``` r
for(i in 1:3) print(i)
```

    ## [1] 1
    ## [1] 2
    ## [1] 3

``` r
`for`(i, 1:3, print(i))
```

    ## [1] 1
    ## [1] 2
    ## [1] 3

## Objects

[Base types](https://adv-r.hadley.nz/base-types.html).

## Modeling example

Notes from [Tidy Modeling with R](https://www.tmwr.org/base-r.html).

Load `crickets` data set that contains the relationship between the
ambient temperature and the rate of cricket chirps per minute for two
species.

``` r
data(crickets, package = "modeldata")
head(crickets)
```

    ## # A tibble: 6 × 3
    ##   species           temp  rate
    ##   <fct>            <dbl> <dbl>
    ## 1 O. exclamationis  20.8  67.9
    ## 2 O. exclamationis  20.8  65.1
    ## 3 O. exclamationis  24    77.3
    ## 4 O. exclamationis  24    78.7
    ## 5 O. exclamationis  24    79.4
    ## 6 O. exclamationis  24    80.4

Plot.

``` r
ggplot(
  crickets, 
  aes(x = temp, y = rate, color = species, pch = species, lty = species)
) + 
  geom_point(size = 2) + 
  geom_smooth(method = lm, se = FALSE, alpha = 0.5) + 
  scale_color_brewer(palette = "Paired") +
  labs(x = "Temperature (C)", y = "Chirp Rate (per minute)")
```

    ## `geom_smooth()` using formula = 'y ~ x'

![](img/crickets_plot-1.png)<!-- -->

For an inferential model, we might have specified the following null
hypotheses prior to seeing the data:

-   Temperature has no effect on the chirp rate
-   There are no differences between the species’ chirp rate.

The `lm()` function is commonly used to fit an ordinary linear model.
Arguments to this function are a model formula and the data frame that
contains the data. The formula is *symbolic*; the simple formula below
specifies that the chirp rate is the outcome and the temperature is the
predictor.

``` r
rate ~ temp
```

    ## rate ~ temp

If the time of day was also recorded in a column called `time`, the
following formula does not add the time and temperature values together
but the formula symbolically represents that temperature and time should
be added as separate *main effects* to the model. A main effect is a
model term that contains a single predictor variable.

``` r
rate ~ temp + time
```

    ## rate ~ temp + time

We can add the species to the model in the same way but since species is
not a quantitative variable, an *indicator variable* (also known as a
dummy variable) is used in place of the original qualitative value. The
model formula will automatically encode `species` as a numeric by adding
a new column that has a value of zero and one for the two species.

``` r
rate ~ temp + species
```

    ## rate ~ temp + species

The model formula `rate ~ temp + species` creates a model with different
y-intercepts for each species; the slopes of the regression lines could
be different for each species as well. To accommodate this structure, an
interaction term can be added to the model. This can be specified in a
few different ways and the most basic uses the colon.

``` r
rate ~ temp + species + temp:species
```

    ## rate ~ temp + species + temp:species

``` r
# A shortcut can be used to expand all interactions containing
# interactions with two variables:
rate ~ (temp + species)^2
```

    ## rate ~ (temp + species)^2

``` r
# Another shortcut to expand factors to include all possible
# interactions (equivalent for this example):
rate ~ temp * species
```

    ## rate ~ temp * species

The model formula also has other nice features:

-   *In-line* functions can be used, e.g. to use the natural log of the
    temperature, we can use the formula `rate ~ log(temp)`
-   R has many functions that are useful inside formulas,
    e.g. `poly(x, 3)` adds linear, quadratic, and cubic terms for `x` to
    the model as main effects.
-   The period shortcut is available for data sets with many predictors.
    The period represents main effects for all of the columns that are
    not on the left-hand side of the tilde.

Use a two-way interaction model.

``` r
interaction_fit <- lm(rate ~ (temp + species)^2, data = crickets)

interaction_fit
```

    ## 
    ## Call:
    ## lm(formula = rate ~ (temp + species)^2, data = crickets)
    ## 
    ## Coefficients:
    ##           (Intercept)                   temp       speciesO. niveus  
    ##               -11.041                  3.751                 -4.348  
    ## temp:speciesO. niveus  
    ##                -0.234

Now we will recompute the model without the interaction term to assess
whether the interaction term is necessary using the `anova()` method.

``` r
main_effect_fit <- lm(rate ~ temp + species, data = crickets)

anova(main_effect_fit, interaction_fit)
```

    ## Analysis of Variance Table
    ## 
    ## Model 1: rate ~ temp + species
    ## Model 2: rate ~ (temp + species)^2
    ##   Res.Df    RSS Df Sum of Sq     F Pr(>F)
    ## 1     28 89.350                          
    ## 2     27 85.074  1    4.2758 1.357 0.2542

This statistical test generates a p-value of 0.25, which implies that
there is a lack of evidence against the null hypothesis that the
interaction term is not needed by the model.

The `summary()` method can be used to inspect the coefficients, standard
errors, and p-values of each model term.

``` r
summary(main_effect_fit)
```

    ## 
    ## Call:
    ## lm(formula = rate ~ temp + species, data = crickets)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -3.0128 -1.1296 -0.3912  0.9650  3.7800 
    ## 
    ## Coefficients:
    ##                   Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)       -7.21091    2.55094  -2.827  0.00858 ** 
    ## temp               3.60275    0.09729  37.032  < 2e-16 ***
    ## speciesO. niveus -10.06529    0.73526 -13.689 6.27e-14 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 1.786 on 28 degrees of freedom
    ## Multiple R-squared:  0.9896, Adjusted R-squared:  0.9888 
    ## F-statistic:  1331 on 2 and 28 DF,  p-value: < 2.2e-16

The chirp rate for each species increases by 3.6 chirps as the
temperature increases by a single degree. This term shows strong
statistical sifnificance as evidenced by the p-value. The species term
has a value of -10.07, which indicates that, across all temperature
values, *O. niveus* has a chirp rate that is about 10 fewer chirps per
minute than *O. exclamationis*. The species effect is also associated
with a very small p-value.

The only issue in this analysis is the intercept value that indicates
that at 0 degrees Celsius, there are negative chirps per minute for both
species. The data only goes as low as 17.2 degrees Celsius and therefore
the conclusions should be limited to the observed temperature range.

If we needed to estimate the chirp rate at a temperature that was not
observed in the experiment, we could use the `predict()` method, which
takes the model object and a data frame of new values for prediction.

``` r
new_values <- data.frame(species = "O. exclamationis", temp = 15:20)
predict(main_effect_fit, new_values)
```

    ##        1        2        3        4        5        6 
    ## 46.83039 50.43314 54.03589 57.63865 61.24140 64.84415

### R formula

The R model formula is used by many modeling packages and it usually
serves multiple purposes:

-   The formula defines the columns that the model uses.
-   The standard R machinery uses the formula to encode the columns into
    an appropriate format, e.g. create indicator variables.
-   The roles of the columns are defined by the formula.

For example, the following formula indicates that there are two
predictors and the model should contain their main effects and the
two-way interactions.

``` r
rate ~ (temp + species)^2
```

    ## rate ~ (temp + species)^2

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
    ##   1.451   0.000   1.453

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

    ##  [1] "%>%"             "boundary"        "coll"            "fixed"          
    ##  [5] "fruit"           "invert_match"    "regex"           "sentences"      
    ##  [9] "str_c"           "str_conv"        "str_count"       "str_detect"     
    ## [13] "str_dup"         "str_ends"        "str_extract"     "str_extract_all"
    ## [17] "str_flatten"     "str_glue"        "str_glue_data"   "str_interp"     
    ## [21] "str_length"      "str_locate"      "str_locate_all"  "str_match"      
    ## [25] "str_match_all"   "str_order"       "str_pad"         "str_remove"     
    ## [29] "str_remove_all"  "str_replace"     "str_replace_all" "str_replace_na" 
    ## [33] "str_sort"        "str_split"       "str_split_fixed" "str_squish"     
    ## [37] "str_starts"      "str_sub"         "str_sub<-"       "str_subset"     
    ## [41] "str_to_lower"    "str_to_sentence" "str_to_title"    "str_to_upper"   
    ## [45] "str_trim"        "str_trunc"       "str_view"        "str_view_all"   
    ## [49] "str_which"       "str_wrap"        "word"            "words"

Search is useful to list the search path, i.e. where R will look, for R
objects such as functions.

``` r
search()
```

    ##  [1] ".GlobalEnv"        "package:modeldata" "package:forcats"  
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
    ## [31] qqnorm         qr             residuals      rstandard      rstudent      
    ## [36] show           simulate       slotsFromS3    summary        variable.names
    ## [41] vcov          
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

    ## [1] "/usr/local/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/local/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server"

Now we will add `/usr/include` to `LD_LIBRARY_PATH` and get the updated
library path.

``` r
new_path <- paste0(Sys.getenv("LD_LIBRARY_PATH"), ":", "/usr/include")
Sys.setenv("LD_LIBRARY_PATH" = new_path)
Sys.getenv("LD_LIBRARY_PATH")
```

    ## [1] "/usr/local/lib/R/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/local/lib/R/lib:/lib:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-11-openjdk-amd64/lib/server:/usr/include"

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

    ## [1] "2023-01-04 06:22:51 UTC"

Session info.

    ## R version 4.2.0 (2022-04-22)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 20.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3
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
    ##  [1] modeldata_1.0.1 forcats_0.5.2   stringr_1.4.1   dplyr_1.0.10   
    ##  [5] purrr_0.3.5     readr_2.1.3     tidyr_1.2.1     tibble_3.1.8   
    ##  [9] ggplot2_3.4.0   tidyverse_1.3.2
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] lubridate_1.9.0     lattice_0.20-45     assertthat_0.2.1   
    ##  [4] digest_0.6.30       utf8_1.2.2          R6_2.5.1           
    ##  [7] cellranger_1.1.0    backports_1.4.1     reprex_2.0.2       
    ## [10] evaluate_0.17       highr_0.9           httr_1.4.4         
    ## [13] pillar_1.8.1        rlang_1.0.6         googlesheets4_1.0.1
    ## [16] readxl_1.4.1        rstudioapi_0.14     Matrix_1.5-1       
    ## [19] rmarkdown_2.17      labeling_0.4.2      splines_4.2.0      
    ## [22] googledrive_2.0.0   munsell_0.5.0       broom_1.0.1        
    ## [25] compiler_4.2.0      modelr_0.1.9        xfun_0.34          
    ## [28] pkgconfig_2.0.3     mgcv_1.8-41         htmltools_0.5.3    
    ## [31] tidyselect_1.2.0    fansi_1.0.3         crayon_1.5.2       
    ## [34] tzdb_0.3.0          dbplyr_2.2.1        withr_2.5.0        
    ## [37] grid_4.2.0          nlme_3.1-160        jsonlite_1.8.3     
    ## [40] gtable_0.3.1        lifecycle_1.0.3     DBI_1.1.3          
    ## [43] magrittr_2.0.3      scales_1.2.1        cli_3.4.1          
    ## [46] stringi_1.7.8       farver_2.1.1        fs_1.5.2           
    ## [49] xml2_1.3.3          ellipsis_0.3.2      generics_0.1.3     
    ## [52] vctrs_0.5.0         RColorBrewer_1.1-3  tools_4.2.0        
    ## [55] glue_1.6.2          hms_1.1.2           fastmap_1.1.0      
    ## [58] yaml_2.3.6          timechange_0.1.1    colorspace_2.0-3   
    ## [61] gargle_1.2.1        rvest_1.0.3         knitr_1.40         
    ## [64] haven_2.5.1
