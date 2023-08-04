Conditions
================

  - [Introduction](#introduction)
      - [Signalling conditions](#signalling-conditions)
          - [Errors](#errors)
          - [Warnings](#warnings)
          - [Messages](#messages)
      - [Session info](#session-info)

# Introduction

Notes from [Advanced R](https://adv-r.hadley.nz/conditions.html).

The **condition** system provides a paired set of tools that allow the
author of a function to indicate that something unusual is happening,
and the user of that function to deal with it. The function author
**signals** conditions with functions like:

  - `stop()` for errors,
  - `warning()` for warnings, and
  - `message()` for messages,

then the function user can handle them with functions like `tryCatch()`
and `withCallingHandlers()`.

Understanding the condition system is important because you’ll often
need to play both roles: signalling conditions from the functions you
create, and handle conditions signalled by the functions you call.

R offers a very powerful condition system based on ideas from Common
Lisp. Like R’s approach to Object-Oriented Programming, it is rather
different to currently popular programming languages so it is easy to
misunderstand.

## Signalling conditions

There are three conditions that you can signal in code: errors,
warnings, and messages.

  - Errors are the most severe; they indicate that there is no way for a
    function to continue and execution must stop.

  - Warnings fall somewhat in between errors and message, and typically
    indicate that something has gone wrong but the function has been
    able to at least partially recover.

  - Messages are the mildest; they are way of informing users that some
    action has been performed on their behalf.

There is a final condition that can only be generated interactively: an
interrupt, which indicates that the user has interrupted execution.

Conditions are usually displayed prominently, in a bold font or coloured
red, depending on the R interface. You can tell them apart because
errors always start with “Error”, warnings with “Warning” or “Warning
message”, and messages with nothing.

### Errors

In base R, errors are signalled, or **thrown**, by `stop()`.

``` r
f <- function() g()
g <- function() h()
h <- function() stop("This is an error!")

f()
```

    ## Error in h(): This is an error!

By default, the error message includes the call, but this is typically
not useful (and recapitulates information that you can easily get from
`traceback()`), so Hadley recommends using `call. = FALSE`.

``` r
h <- function() stop("This is an error!", call. = FALSE)
f()
```

    ## Error: This is an error!

The rlang equivalent to `stop()`, `rlang::abort()`, does this
automatically.

``` r
h <- function() abort("This is an error!")
f()
```

    ## Error in `h()`:
    ## ! This is an error!

The best error messages tell you what is wrong and point you in the
right direction to fix the problem. Writing good error messages is hard
because errors usually occur when the user has a flawed mental model of
the function. As a developer, it’s hard to imagine how the user might be
thinking incorrectly about your function, and thus it’s hard to write a
message that will steer the user in the correction direction. See the
[tidyverse style guide](https://style.tidyverse.org/error-messages.html)
for some general principles.

### Warnings

Warnings, signalled by `warning()`, are weaker that errors: they signal
that something has gone wrong, but the code has been able to recover and
continue. Unlike errors, you can have multiple warnings from a single
function call.

``` r
fw <- function() {
   cat("1\n")
   warning("W1")
   cat("2\n")
   warning("W2")
   cat("3\n")
   warning("W3")
}
```

By default, warnings are cached and printed only when control returns to
the top level.

``` r
fw()
```

    ## 1

    ## Warning in fw(): W1

    ## 2

    ## Warning in fw(): W2

    ## 3

    ## Warning in fw(): W3

You can control this behaviour with the `warn` option:

  - To make warnings appear immediately, set `options(warn = 1)`.

  - To turn warnings into errors, set `options(warn = 2)`. This is
    usually the easiest way to debug a warning, as once it’s an error
    you can use tools like `traceback()` to find the source.

  - Restore the default behaviour with `options(warn = 0)`.

Like `stop()`, `warning()` also has a call argument. It is slightly more
useful (since warnings are often more distant from their source), but
Hadley still recommends suppressing it with `call. = FALSE`. The
equivalent in rlang is `rlang::warn()` and it suppresses the `call.` by
default.

Warnings occupy a somewhat challenging place between messages (“you
should know about this”) and errors (“you must fix this\!”). In general,
**be restrained**, as warnings are easy to miss if there’s a lot of
other output, and you don’t want your function to recover too easily
from clearly invalid input.

There are only a couple of cases where using a warning is clearly
appropriate:

  - When you **deprecate** a function you want to allow older code to
    continue to work (so ignoring the warning is OK) but you want to
    encourage the user to switch to a new function.

  - When you are reasonably certain you can recover from a problem: If
    you were 100% certain that you could fix the problem, you wouldn’t
    need any message; if you were more uncertain that you could
    correctly fix the issue, you’d throw an error.

### Messages

Messages, signalled by `message()`, are informational; use them to tell
the user that you’ve done something on their behalf. Good messages are a
balancing act: you want to provide just enough information so the user
knows what’s going on, but not so much that they’re overwhelmed.

`message()` are displayed immediately and do not have a `call.`
argument.

``` r
fm <- function() {
   cat("1\n")
   message("M1")
   cat("2\n")
   message("M2")
   cat("3\n")
   message("M3")
}

fm()
```

    ## 1

    ## M1

    ## 2

    ## M2

    ## 3

    ## M3

Good places to use a message are:

  - When a default argument requires some non-trivial amount of
    computation and you want to tell the user what value was used. For
    example, ggplot2 reports the number of bins used if you don’t supply
    a `binwidth`.

  - In functions that are called primarily for their side-effects which
    would otherwise be silent. For example, when writing files to disk,
    calling a web API, or writing to a database, it’s useful to provide
    regular status messages telling the user what’s going on.

  - When you are about to start a long running process with no
    intermediate output. A progress bar is better but a message is a
    good place to start.

  - When writing a package, you sometimes want to display a message when
    your package is loaded (i.e. in `.onAttach()`); here you must use
    `packageStartupMessage()`.

Generally any function that produces a message should have some way to
suppress it, like a `quiet = TRUE` argument. It is possible to suppress
all messages with `suppressMessages()` but it is nice to provide finer
grained control.

The `cat()` function is closely related and it terms of usage and
result, they appear quite similar.

``` r
cat("Hi!\n")
```

    ## Hi!

``` r
message("Hi!")
```

    ## Hi!

However, the *purposes* of `cat()` and `message()` are different. Use
`cat()` **when the primary role of the function is to print to the
console**, like `print()` or `str()` methods. Use `message()` as a
**side-channel to print to the console when the primary purpose of the
function is something else**. In other words, `cat()` is for when the
user *asks* for something to be printed and `message()` is for when the
developer *elects* to print something.

## Session info

This document was generated by rendering `oop.Rmd` using `rmd_to_md.sh`.

    ## [1] "2023-08-04 01:41:45 UTC"

Session info.

    ## R version 4.3.0 (2023-04-21)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 22.04.2 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0
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
    ## [1] rlang_1.1.1
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.3.0  fastmap_1.1.1   cli_3.6.1       tools_4.3.0    
    ##  [5] htmltools_0.5.5 rstudioapi_0.14 yaml_2.3.7      rmarkdown_2.22 
    ##  [9] knitr_1.43      xfun_0.39       digest_0.6.31   evaluate_0.21
