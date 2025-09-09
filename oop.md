Object-Oriented Programming in R
================

- [Introduction](#introduction)
  - [Base types](#base-types)
    - [Numeric type](#numeric-type)
  - [S3](#s3)
  - [Classes](#classes)
    - [Constructors](#constructors)
    - [Validators](#validators)
  - [Session info](#session-info)

# Introduction

Notes from the [Advanced R](https://adv-r.hadley.nz/oo.html).

Everything that exists in R is an object but this does not mean that
everything is object-oriented. In R there are **base objects** and **OO
objects** and we can use `is.object()` or `sloop::otype()` to tell which
is which.

``` r
is.object(1:10)
```

    ## [1] FALSE

``` r
sloop::otype(1:10)
```

    ## [1] "base"

``` r
is.object(mtcars)
```

    ## [1] TRUE

``` r
sloop::otype(mtcars)
```

    ## [1] "S3"

Technically, the difference between base and OO objects is that OO
objects have a “class” attribute.

``` r
attr(1:10, "class")
```

    ## NULL

``` r
attr(mtcars, "class")
```

    ## [1] "data.frame"

The `class()` function is safe to apply to S3 and S4 objects but returns
misleading results when applied to base objects. It is safer to use
`sloop::s3_class()`, which returns the implicit class that the S3 and S4
systems will use to pick methods.

``` r
x <- matrix(1:4, nrow = 2)
class(x)
```

    ## [1] "matrix" "array"

``` r
sloop::s3_class(x)
```

    ## [1] "matrix"  "integer" "numeric"

## Base types

While only OO objects have a class attribute, every object has a **base
type**.

``` r
typeof(1:10)
```

    ## [1] "integer"

``` r
typeof(mtcars)
```

    ## [1] "list"

Base types do not form an OOP system because functions that behave
differently for different base types are primarily written in C code
that uses switch statements. This means that only R-core can create new
types, and creating a new type is a lot of work because every switch
statement needs to be modified to handle a new case.

### Numeric type

R uses numeric to mean three slightly different things:

1.  In some places numeric is used as an alias for the double type.
2.  In the S3 and S4 systems, numeric is used as a shorthand for either
    integer or double type, and is used when picking methods:

``` r
sloop::s3_class(1)
```

    ## [1] "double"  "numeric"

``` r
sloop::s3_class(1L)
```

    ## [1] "integer" "numeric"

3.  `is.numeric()` tests for objects that *behave* like numbers. For
    example, factors have type “integer” but do not behave like numbers.

``` r
typeof(factor("x"))
```

    ## [1] "integer"

``` r
is.numeric(factor("x"))
```

    ## [1] FALSE

## S3

An S3 object is a base type with at least a `class` attribute. As an
example, consider the factor. Its base type is the integer vector and it
has a `class` attribute of “factor” and a `levels` attribute that stores
the possible levels.

``` r
f <- factor(c("a", "b", "c"))

typeof(f)
```

    ## [1] "integer"

``` r
attributes(f)
```

    ## $levels
    ## [1] "a" "b" "c"
    ## 
    ## $class
    ## [1] "factor"

You can get the underlying base type by using `unclass()`, which strips
the class attribute, causing it to lose its special behaviour.

``` r
unclass(f)
```

    ## [1] 1 2 3
    ## attr(,"levels")
    ## [1] "a" "b" "c"

An S3 object behaves differently from its underlying base type whenever
it is passed to a **generic** (short for generic function). The easiest
way to tell if a function is a generic is to use `sloop::ftype()` and
look for “generic” in the output.

``` r
ftype(print)
```

    ## [1] "S3"      "generic"

``` r
ftype(str)
```

    ## [1] "S3"      "generic"

``` r
ftype(unclass)
```

    ## [1] "primitive"

A generic function defines an interface, which uses a different
implementation depending on the class of an argument (almost always the
first argument).

``` r
print(f)
```

    ## [1] a b c
    ## Levels: a b c

``` r
# stripping class reverts to integer behaviour
print(unclass(f))
```

    ## [1] 1 2 3
    ## attr(,"levels")
    ## [1] "a" "b" "c"

The generic is a middleman: its job is to define the interface (i.e. the
arguments) then find the right implementation for the job. The
implementation for a specific class is called a **method**, and the
generic finds that method by performing **method dispatch**.

You can use `sloop::s3_dispatch()` to see the process of method
dispatch.

``` r
sloop::s3_dispatch(print(f))
```

    ## => print.factor
    ##  * print.default

Note that S3 methods are functions with a special naming scheme
`generic.class()`. For example, the `factor` method for the `print()`
generic is called `print.factor()`. **You should never call the method
directly, but instead rely on the generic to find it for you**.

Generally, you can identify a method by the presence of `.` in the
function name but use `sloop::ftype()` to confirm.

``` r
ftype(t.test)
```

    ## [1] "S3"      "generic"

``` r
ftype(t.data.frame)
```

    ## [1] "S3"     "method"

**You can not see the source code for most S3 methods by typing their
names unlike most functions. That’s because S3 methods are not usually
exported: they live only inside the package, and are not available from
the global environment**. Use `sloop::s3_get_method()` to get the method
code.

``` r
sloop::s3_get_method(weighted.mean.Date)
```

    ## function (x, w, ...) 
    ## .Date(weighted.mean(unclass(x), w, ...))
    ## <bytecode: 0x55af73a39330>
    ## <environment: namespace:stats>

## Classes

S3 has no formal definition of a class: to make an object an instance of
a class, you simply **set the class attribute**. You can do that during
creation with `structure()`, or after with `class<-()`.

``` r
# Create and assign class in one step
x <- structure(list(), class = "my_class")

# Create, then set class
x <- list()
class(x) <- "my_class"
```

You can determine the class of an S3 object with `class(x)` and see if
an object is an instance of a class using `inherits(x, "classname")`.

``` r
class(x)
```

    ## [1] "my_class"

``` r
inherits(x, "my_class")
```

    ## [1] TRUE

``` r
inherits(x, "your_class")
```

    ## [1] FALSE

The class name can be any string, but Hadley recommends using only
letters and `_`. Avoid `.` because it can be confused with the `.`
separator between a generic name and a class name. When using a class in
a package, it is recommended that the package name be included with the
class name. That ensures you won’t accidentally clash with a class
defined by another package.

S3 has no checks for correctness which means you can change the class of
existing objects.

``` r
mod <- lm(log(mpg) ~ log(disp), data = mtcars)
class(mod)
```

    ## [1] "lm"

``` r
class(mod) <- "Date"
class(mod)
```

    ## [1] "Date"

When creating a class, it is recommended that these three functions are
provided:

- A low-level **constructor**, `new_myclass()`, that efficiently creates
  new objects with the correct structure.
- A **validator**, `validate_myclass()`, that performs more
  computationally expensive checks to ensure that the object has correct
  values.
- A user-friendly **helper**, `myclass()`, that provides a convenient
  way for others to create objects of your class.

For simple classes a validator is not necessary and the helper can be
skipped if the class is for internal use only, but a constructors should
always be provided.

### Constructors

S3 doesn’t provide a formal definition of a class, so it has no built-in
way to ensure that all objects of a given class have the same structure
(i.e. the same base type and the same attributes with the same types).
Instead, you must enforce a consistent structure by using a
**constructor**.

The constructor should follow three principles:

1.  Be called `new_myclass()`.
2.  Have one argument for the base object, and one for each attribute.
3.  Check the type of the base object and the types of each attribute.

We’ll get started with a constructor for the simplest S3 class: `Date`.
A `Date` is just a double with a single attribute: its `class` is
“Date”.

``` r
new_Date <- function(x = double()) {
   stopifnot(is.double(x))
   structure(x, class = "Date")
}

new_Date(c(-1, 0, 1))
```

    ## [1] "1969-12-31" "1970-01-01" "1970-01-02"

The purpose of constructors is to help you, the developer. That means
you can keep them simple, and you don’t need to optimise error messages
for public consumption. If you expect users to also create objects, you
should create a friendly helper function, called `class_name`.

A slightly more complicated constructor is that for `difftime`, which is
used to represent time differences. It is again built on a double, but
has a `units` attribute that must take one of a small set of values.

``` r
new_difftime <- function(x = double(), units = "secs"){
  stopifnot(is.double(x))
  units <- match.arg(units, c("secs", "mins", "hours", "days", "weeks"))
  
  structure(
    x,
    class = "difftime",
    units = units
  )
}

new_difftime(c(1, 10, 3600), "secs")
```

    ## Time differences in secs
    ## [1]    1   10 3600

``` r
new_difftime(52, "weeks")
```

    ## Time difference of 52 weeks

The constructor is a developer function: it will be called in many
places, by an experienced user. That means it is OK to trade a little
safety in return for performance, and you should avoid potentially
time-consuming checks in the constructor.

### Validators

More complicated classes require more complicated checks for validity.
Take factors, for example. A constructor only checks that types are
correct, making it possible to create malformed factors.

``` r
new_factor <- function(x = integer(), levels = character()){
  stopifnot(is.integer(x))
  stopifnot(is.character(levels))
  
  structure(
    x,
    levels = levels,
    class = "factor"
  )
}

new_factor(1:5, "a")
```

    ## Error in as.character.factor(x): malformed factor

Rather than encumbering the constructor with complicated checks, it’s
better to put them in a separate function. Doing so allows you to
cheaply create new objects when you know that the values are correct,
and easily re-use the checks in other places.

``` r
validate_factor <- function(x){
  values <- unclass(x)
  levels <- attr(x, "levels")
  
  if (!all(!is.na(values) & values > 0)){
    stop(
      "All `x` values must be non-missing and greater than zero",
      call. = FALSE
    )
  }
  
  if (length(levels) < max(values)){
    stop(
      "There must be at least as many `levels` as possible values in `x`",
      call. = FALSE
    )
  }
  
  x
}

validate_factor(new_factor(1:5, "a"))
```

    ## Error: There must be at least as many `levels` as possible values in `x`

``` r
validate_factor(new_factor(0:1, "a"))
```

    ## Error: All `x` values must be non-missing and greater than zero

The validator function is called primarily for its side-effects
(throwing an error if the object is invalid) so you’d expect it to
invisibly return its primary input. However, it is useful for validation
methods to return visibly too.

## Session info

This document was generated by rendering `oop.Rmd` using `rmd_to_md.sh`.

    ## [1] "2025-09-09 03:40:44 UTC"

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
    ## [1] sloop_1.0.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] digest_0.6.37     codetools_0.2-20  fastmap_1.2.0     xfun_0.52        
    ##  [5] magrittr_2.0.3    knitr_1.50        htmltools_0.5.8.1 rmarkdown_2.29   
    ##  [9] lifecycle_1.0.4   cli_3.6.5         vctrs_0.6.5       compiler_4.5.0   
    ## [13] purrr_1.0.4       tools_4.5.0       evaluate_1.0.3    yaml_2.3.10      
    ## [17] rlang_1.1.6
