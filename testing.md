R unit testing
================

- [Introduction](#introduction)
  - [Initial setup](#initial-setup)
  - [Creating a test](#creating-a-test)
  - [Running tests](#running-tests)
    - [Micro-iteration](#micro-iteration)
    - [Mezzo-iteration](#mezzo-iteration)
    - [Macro-iteration](#macro-iteration)
  - [Test organisation](#test-organisation)
  - [Expectations](#expectations)
    - [Testing for equality](#testing-for-equality)
    - [Testing errors](#testing-errors)
- [Session info](#session-info)

# Introduction

Notes from the [R Packages
book](https://r-pkgs.org/testing-basics.html).

## Initial setup

To use testthat with your package, run:

    usethis::use_testthat(3)

This will:

1.  Create a `tests/testthat` directory.

2.  Add testthat to the `Suggests` field in the `DESCRIPTION` and
    specify testthat 3e in the `Config/testthat/edition` field. The
    updated `DESCRIPTION` fields might look like:

    Suggests: testthat (\>= 3.0.0) Config/testthat/edition: 3

3.  Create a file `tests/testthat.R` that runs all your tests when
    `R CMD check` runs. For a package named “pkg”, the contents of this
    file will be something like:

    library(testthat) library(pkg)

    test_check(“pkg”)

Do not edit `tests/testthat.R` manually. It is run during `R CMD check`
(and, therefore, `devtools::check())`, but is not used in most other
test-running scenarios (such as `devtools::test()` or
`devtools::test_active_file()`). If you want to do something that
affects all of your tests, there is almost always a better way than
modifying the boilerplate `tests/testthat.R` script.

This initial setup is usually something you do once per package.

## Creating a test

As you define functions in your packages in `R/`, you add the
corresponding tests to `.R` files in `tests/testthat`. It is strongly
recommended that the organisation of test files match the organisation
of `R/` files.

For example if a `foofy()` function (and its friends and helpers) are
defined in `R/foofy.R`, their tests should reside in
`tests/testthat/test-foofy.R`.

Even if you have different conventions for file organisation and naming,
note that testthat tests **must** reside in files inside
`tests/testthat/` and these file names **must** begin with `test`. The
test file name is displayed in testthat output, which provides helpful
context.

usethis offers a helpful pair of functions for creating or toggling
between files:

- `usethis::use_r()`
- `usethis::use_test()`

Either one can be called with a file (base) name in order to create a
new file and open it for editing.

Create and open `R/foofy.R`.

    use_r("foofy")

Create and open `tests/testthat/test-blarg.R`.

    use_test("blarg")

These two function has some convenience features that make them useful
in many common situations:

- When determining the target file, they can deal with the presence or
  absence of the `.R` extension and the `test-` prefix.
  - `use_r("foofy.R")` and `use_r("foofy")` are the same.
  - `use_test("test-blarg.R")`, `use_test("blarg.R")`, and
    `use_test("blarg")` are the same.
- If the target file already exists, it is open for editing. Otherwise
  the target is created and then opened for editing.

Furthermore, in RStudio, if `R/foofy.R` is the active file in the source
pane, calling `use_test()` with no arguments will create and/or open the
companion test file. This works the other way around too with `use_r()`.

When `use_test()` creates a new test file, it inserts an example test:

    test_that("multiplication works", {
       expect_equal(2 * 2, 4)
    })

- A test file holds one or more `test_that()` tests.
- Each test describes what it is testing such as whether multiplication
  works.
- Each test has one or more expectations using `expect_equal()`

## Running tests

Tests can be run at various scales depending on the development cycle.
For example when working on a specific function, testing will be
performed at the level of individual tests. As the code matures, testing
will be performed on entire test files and eventually the entire test
suite.

### Micro-iteration

This is the interactive phase where a function is created, refined, and
tested. `devtools::load_all()` will be used often and individual
expectations or whole tests are executed interactively in the console.
Note that `load_all()` attaches testthat allowing you to test your
functions and to execute the individual tests and expectations.

An example workflow could be:

1.  Tweak the `foofy()` function and then re-load it

    devtools::load_all()

2.  Interactively explore and refine expectations and tests

    expect_equal(foofy(…), EXPECTED_OUTPUT) test_that(“foofy does good
    things”, {…})

### Mezzo-iteration

To execute an entire file’s list of associated tests use
`testthat::test_file()`.

    testthat::test_file("tests/testthat/test-foofy.R")

In RStudio, if the target test file is the active file, you can click on
“Run Tests”. There is also a useful function,
`devtools::test_active_file()` that infers the target test file from the
active file.

### Macro-iteration

The entire test suite can be run using `devtools::test()`; this is
mapped to Ctrl/Cmd + Shift + T in RStudio.

    devtools::test()

Then eventually using `devtools::check()`; this is mapped to Ctrl/Cmd +
Shift + E in RStudio.

    devtools::check()

## Test organisation

Recall that a test file resides in `tests/testthat` and that its names
must start with `test`. Below is an example of a test
(`tests/testthat/test-dup.r`) from the `stringr` package.

``` r
test_that("basic duplication works", {
  expect_equal(str_dup("a", 3), "aaa")
  expect_equal(str_dup("abc", 2), "abcabc")
  expect_equal(str_dup(c("a", "b"), 2), c("aa", "bb"))
  expect_equal(str_dup(c("a", "b"), c(2, 3)), c("aa", "bbb"))
})

test_that("0 duplicates equals empty string", {
  expect_equal(str_dup("a", 0), "")
  expect_equal(str_dup(c("a", "b"), 0), rep("", 2))
})

test_that("uses tidyverse recycling rules", {
  expect_error(str_dup(1:2, 1:3), class = "vctrs_error_incompatible_size")
})
```

Contained in the file are a typical mix of tests:

- “basic duplication works” tests typical usage of `str_dup()`.
- “0 duplicates equals empty string” probes a specific edge case.
- “uses tidyverse recycling rules” checks that malformed input results
  in a specific kind of error.

Tests are organised hierarchically: **expectations** are grouped into
**tests**, which are organised in **files**:

- A **file** holds multiple related tests. In the example, the file
  `tests/testthat/test-dup.r` has all of the tests for the code in
  `R/dup.r`.

- A **test** groups together multiple expectations to test the output
  from a simple function, a range of possibilities for a single
  parameter from a more complicated function, or tightly related
  functionality from across multiple functions. This is why they are
  sometimes called **unit** tests. Each test should cover a single unit
  of functionality. A test is created with `test_that(desc, code)`. It
  is common to write a description that reads naturally. A test failure
  report includes this description, which is why you want a concise
  statement of the test’s purpose, e.g. a specific behaviour.

- An **expectation** is the atom of testing. It describes the expected
  result of a computation: Does it have the right value and right class?
  Does it produce an error when it should? An expectation automates
  visual checking of results in the console. Expectations are functions
  that start with `expect_`.

You’d want to arrange things such that, when a test fails, you will know
what is wrong and where in your code to look for the problem. This
motivates all our recommendations regarding file organisation, file
naming, and the test description. Finally, try to avoid putting too many
expectations in one test - it is better to have more smaller tests than
fewer larger tests.

## Expectations

An expectation is the finest level of testing. It makes a binary
assertion about whether or not an object has the properties you expect.
This object is usually the return value from a function in your package.

All expectations have a similar structure:

- They start with `expect_`.
- They have two main arguments:
  1.  The actual result.
  2.  What you expect.
- If the actual and expected results do not agree, testthat throws an
  error.
- Some expectations have additional arguments that control the finer
  points of comparing an actual and expected result.

While you will normally put expectations inside tests inside files, you
can also run them directly. This makes it easy to explore expectations
interactively. There are more than [40
expectations](https://testthat.r-lib.org/reference/) in the testthat
package.

### Testing for equality

`expect_equal()` checks for equality, with some reasonable amount of
numeric tolerance.

``` r
expect_equal(10, 10)
expect_equal(10, 10L)
expect_equal(10, 10 + 1e-7)
expect_equal(10, 11)
#> Error: 10 (`actual`) not equal to 11 (`expected`).
#>
#>   `actual`: 10
#> `expected`: 11
```

`expect_identical()` tests for exact equivalence.

``` r
expect_equal(10, 10 + 1e-7)
expect_identical(10, 10 + 1e-7)
#> Error: 10 (`actual`) not identical to 10 + 1e-07 (`expected`).
#>
#>   `actual`: 10.0000000
#> `expected`: 10.0000001

expect_equal(2, 2L)
expect_identical(2, 2L)
#> Error: 2 (`actual`) not identical to 2L (`expected`).
#>
#> `actual` is a double vector (2)
#> `expected` is an integer vector (2)
```

### Testing errors

Use `expect_error()` to check whether an expression throws an error. It
is the most

# Session info

This document was generated by rendering `testing.Rmd` using
`./rmd_to_md.sh`.

    ## [1] "2023-11-24 01:18:38 UTC"

Session info.

    ## R version 4.3.2 (2023-10-31)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Ubuntu 22.04.3 LTS
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
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.3.2    fastmap_1.1.1     cli_3.6.1         tools_4.3.2      
    ##  [5] htmltools_0.5.6.1 rstudioapi_0.15.0 yaml_2.3.7        rmarkdown_2.25   
    ##  [9] knitr_1.45        xfun_0.41         digest_0.6.33     rlang_1.1.1      
    ## [13] evaluate_0.23
