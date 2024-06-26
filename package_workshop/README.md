# R package workshop
2024-04-06

- [TL;DR](#tldr)
- [Introduction](#introduction)
- [Getting started](#getting-started)
  - [DESCRIPTION](#description)
  - [License](#license)
  - [Functions](#functions)
  - [Checking your package](#checking-your-package)
  - [Documenting our function](#documenting-our-function)
  - [Testing](#testing)
  - [Dependencies](#dependencies)
  - [Other documentation](#other-documentation)
    - [Package help file](#package-help-file)
    - [Vignettes](#vignettes)
    - [README](#readme)
    - [Package website](#package-website)
  - [Versioning](#versioning)
  - [Building, installing, and
    releasing](#building-installing-and-releasing)
    - [Building](#building)
    - [CRAN](#cran)
    - [Bioconductor](#bioconductor)
    - [rOpenSci](#ropensci)
    - [Code sharing websites](#code-sharing-websites)
  - [Advanced topics](#advanced-topics)
    - [Including datasets](#including-datasets)
    - [Designing objects](#designing-objects)
    - [Integrating other languages](#integrating-other-languages)
    - [Metaprogramming](#metaprogramming)
  - [Good practices and advice](#good-practices-and-advice)
    - [Design advice](#design-advice)
    - [Coding style](#coding-style)
    - [Version control](#version-control)
    - [Continuous integration](#continuous-integration)
  - [Resources](#resources)
- [Session information](#session-information)

# TL;DR

Install packages, check whether the system is ready to build packages,
initialise package, add license, create file to hold functions, and
check for issues.

``` r
pkgs <- c("devtools", "usethis", "roxygen2", "testthat", "knitr", "ggplot2", "rlang")
install.packages(pkgs, Ncpus = 2)
pkgbuild::check_build_tools()

usethis::create_package(path = '/tmp/mypkg')
usethis::use_mit_license("Dave Tang")
usethis::use_r("colours")
devtools::document()
usethis::use_testthat()
usethis::use_test("colours")
devtools::test()
devtools::check()
```

# Introduction

This [R package
workshop](https://combine-australia.github.io/r-pkg-dev/) was created by
COMBINE, an association for Australian students in bioinformatics,
computational biology, and related fields. It is licensed under a
[Creative Commons Attribution 4.0 International (CC BY 4.0)
license](https://creativecommons.org/licenses/by/4.0/).

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

# Getting started

To begin building a package, we need a package name; names can only
consist of letters, numbers and dots (.) and must start with a letter.
While all of these are allowed it is generally best to stick to just
lowercase letters. Having a mix of lower and upper case letters can be
hard for users to remember (is it RColorBrewer or Rcolorbrewer or
rcolorbrewer?). For this workshop, we are going to use {mypkg}.

To create a template for our package, use `usethis::create_package()`.

``` r
usethis::create_package(path = '/tmp/mypkg')
```

Several files get created.

``` bash
ls -R /tmp/mypkg
```

    /tmp/mypkg:
    DESCRIPTION
    mypkg.Rproj
    NAMESPACE
    R

    /tmp/mypkg/R:

- `DESCRIPTION` contains the metadata for your package.
- `NAMESPACE` describes the functions in our package; it should not be
  manually edited.
- `mypkg.Rproj` is a RStudio project file.
- `R` is the directory that will hold all our R code.

These files are the minimal amount that is required for a package but we
will create other files as we go along. Some other useful (hidden) files
have also been created by {usethis}:

- `.gitignore` is useful if you use `git` for version control.
- `.Rbuildignore` is used to mark files that are in the directory but
  aren’t really part of the package and shouldn’t be included when we
  build it. Most of the time you won’t need to worry about this as
  {usethis} will edit it for you.

## DESCRIPTION

The `DESCRIPTION` file is one of the most important parts of a package.
It contains all the metadata about the package, things like what the
package is called, what version it is, a description, who the authors
are, what other packages it depends on, etc.

``` bash
cat /tmp/mypkg/DESCRIPTION
```

    Package: mypkg
    Title: What the Package Does (One Line, Title Case)
    Version: 0.0.0.9000
    Authors@R: 
        person("First", "Last", , "first.last@example.com", role = c("aut", "cre"),
               comment = c(ORCID = "YOUR-ORCID-ID"))
    Description: What the package does (one paragraph).
    License: `use_mit_license()`, `use_gpl3_license()` or friends to pick a
        license
    Encoding: UTF-8
    Roxygen: list(markdown = TRUE)
    RoxygenNote: 7.3.1

- The `Title` should be a single line in Title Case that explains what
  your package is.
- The `Description` is a paragraph which goes into a bit more detail
  about what the package does.

The `Authors@R` field shows an example of how to define an author. You
can see that the example person has been assigned the author (“aut”) and
creator (“cre”) roles. There must be at least one author and one creator
for every package (they can be the same person) and the creator must
have an email address. Other roles include:

- `cre`: the creator or maintainer of the package, the person who should
  be contacted when there are problems
- `aut`: authors, people who have made significant contributions to the
  package
- `ctb`: contributors, people who have made smaller contributions
- `cph`: copyright holder, useful if this is someone other than the
  creator (such as their employer)

## License

The software license describes how our code can be used and without one
people must assume that it can’t be used at all! For this example we
will use the MIT license which basically says the code can be used for
any purpose and doesn’t come with any warranties. There are templates
for some of the most common licenses included in {usethis}.

``` r
usethis::use_mit_license("Dave Tang")
```

## Functions

Use `usethis::use_r()` to create an empty file in `R` to hold our
function about colours.

``` r
usethis::use_r("colours")
```

There are no rules about how to organise your functions into different
files but in general similar functions should be grouped together into
the same file with a clear name. Putting all functions into a single
file is not ideal but neither is having a separate file for each
function. A good rule of thumb is that if you are finding it hard to
locate a function you might need to move it to a new file.

The example for this workshop is a function that takes the red, green
and blue values for a colour and returns a given number of shades. Save
the function below into `R/colours.R`.

``` r
make_shades <- function(colour, n, lighter = TRUE) {
  # Convert the colour to RGB
  colour_rgb <- grDevices::col2rgb(colour)[, 1]
  
  # Decide if we are heading towards white or black
  if (lighter) {
    end <- 255
  } else {
    end <- 0
  }
  
  # Calculate the red, green and blue for the shades
  # we calculate one extra point to avoid pure white/black
  red   <- seq(colour_rgb[1], end, length.out = n + 1)[1:n]
  green <- seq(colour_rgb[2], end, length.out = n + 1)[1:n]
  blue  <- seq(colour_rgb[3], end, length.out = n + 1)[1:n]
  
  # Convert the RGB values to hex codes
  shades <- grDevices::rgb(red, green, blue, maxColorValue = 255)
  
  return(shades)
}
```

Usually when we write a new function we load it by copying the code to
the console or sourcing the R file. When we are developing a package we
want to try and keep our environment empty so that we can be sure we are
only working with objects inside the package. Instead we can load
functions using `devtools::load_all()`.

## Checking your package

The `devtools::check()` function runs a series of checks to make sure
your package is working correctly. It is highly recommended that you run
`devtools::check()` often and follow its advice to fix any problems.

``` r
devtools::check()
```

You will see all the different types of checks that {devtools} has run
but the most important section is at the end where it tells you how many
errors, warnings, and notes there are.

- Errors happen when your code has broken and failed one of the checks.
  If errors are not fixed your package will not work correctly.
- Warnings are slightly less serious but should also be addressed. Your
  package will probably work without fixing them but it is highly
  advised that you do.
- Notes are advice rather than problems. It can be up to you whether or
  not to address them but there is usually a good reason to.

Often the failed checks come with hints about how to fix them but
sometimes they can be hard to understand.

## Documenting our function

The {roxygen2} package makes it easy to document our function by writing
some special comments at the start of our function. This has the extra
advantage of keeping the documentation with the code which make it
easier to keep it up to date.

If you are using RStudio, open the “Code” menu and select “Insert
Roxygen skeleton”, which will create the template shown below. The
parameters were automatically generated.

``` r
#' Title
#'
#' @param colour 
#' @param n 
#' @param lighter 
#'
#' @return
#' @export
#'
#' @examples
```

Roxygen comments all start with `#'`. The first line is the title of the
function followed by a blank line. Next is a paragraph that provides a
more detailed description of the function.

The next section describes the parameters for the function marked by the
`@param` field.

The next field is `@return`, which is used to describe what the function
returns. This is usually fairly short but you should provide enough
detail to make sure that the user knows what they are getting back.

The next field is `@export` and is a bit different because it doesn’t
add documentation to the help file but instead modifies the `NAMESPACE`
file. Adding `@export` tells {Roxygen} that this is a function that we
want to be available to the user. When we build the documentation,
{Roxygen} will then add the correct information to the `NAMESPACE` file.
If we had an internal function that wasn’t meant to be used by the user
we would leave out `@export`.

The last field in the skeleton is `@examples` and is where we put some
short examples showing how the function can be used. These will be
placed in the help file and can be run using `example("function")`.

``` r
#' Make shades
#'
#' Given a colour make n lighter or darker shades
#' 
#' @param colour The colour to make shades of
#' @param n The number of shades to make
#' @param lighter Whether to make lighter (TRUE) or darker (FALSE) shades
#'
#' @return A vector of n colour hex codes
#' @export
#'
#' @examples
#' # Five lighter shades
#' make_shades("goldenrod", 5)
#' # Five darker shades
#' make_shades("goldenrod", 5, lighter = FALSE)
```

There are other useful fields such as `@author` (specify the function
author), `@references` (any associated references) and `@seealso` (links
to related functions).

Use `devtools::document()` to build the documentation.

``` r
devtools::document()
```

## Testing

Unit tests are checks to make sure that a function works in the way that
we expect. The examples in the documentation act like informal unit
tests because they are run as part of the checking process but it is
better to have something more rigorous.

One approach to writing unit tests is what is known as “test driven
development”. The idea is to write the tests before you write a
function. This way you know exactly what a function is supposed to do
and what problems there might be. While this is a good principal it can
take a lot of advance planning.

A more common approach could be called “bug-driven testing”. For this
approach whenever we come across a bug we write a test for it before we
fix it, that way the same bug should never happen a again. When combined
with some tests for obvious problems this is a good compromise between
testing for every possible outcome and not testing at all.

For example, let’s see what happens when we ask `make_shades()` for a
negative number of shades.

``` r
make_shades("goldenrod", -1)
```

    Error in seq(colour_rgb[1], end, length.out = n + 1)[1:n]: only 0's may be mixed with negative subscripts

Before we make any changes to the function let’s design some tests to
make sure we get what we expect. There are a few ways to write unit
tests for R packages but we are going to use the {testthat} package. We
can set everything up with {usethis}.

``` r
usethis::use_testthat()
```

A `tests/` directory will be created to hold all our tests. There is
also a `tests/testthat.R` file which looks like this:

``` r
# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

library(testthat)
library(mypkg)

test_check("mypkg")
```

The above script makes sure that our tests are run with
`devtools::check()`. To open a new test file use `usethis::use_test()`.

``` r
usethis::use_test("colours")
```

`use_test("colours")` creates `tests/testthat/test-colours.R`, which
matches up with the R files but with `test-` as the prefix. This test
file comes with a small example that shows how to use {testthat}.

``` r
test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
```

Each set of tests starts with the `test_that()` function. This function
has two arguments, a description and the code with the tests that we
want to run. Inside the code section we see an expect function. This
function also has two parts, the thing we want to test and what we
expect it to be. There are different functions for different types of
expectations.

For our test we want to use the `expect_error()` function, because that
is what we expect.

``` r
test_that("n is at least 1", {
  expect_error(make_shades("goldenrod", -1),
               "n must be at least 1")
  expect_error(make_shades("goldenrod", 0),
               "n must be at least 1")
})
```

To run our tests we use `devtools::test()`. We will see that both of our
tests failed. The first test fails because the error message is wrong
and the second one because there is no error. Now that we have some
tests and we know they check the right things we can modify our function
to check the value of `n` and give the correct error.

Let’s add some code to check the value of n. We will update the
documentation as well so the user knows what values can be used.

``` r
#' Make shades
#'
#' Given a colour make \code{n} lighter or darker shades
#'
#' @param colour The colour to make shades of
#' @param n The number of shades to make, at least 1
#' @param lighter Whether to make lighter (\code{TRUE}) or darker (\code{FALSE})
#' shades
#'
#' @return A vector of \code{n} colour hex codes
#' @export
#'
#' @examples
#' # Five lighter shades
#' make_shades("goldenrod", 5)
#' # Five darker shades
#' make_shades("goldenrod", 5, lighter = FALSE)
make_shades <- function(colour, n, lighter = TRUE) {
  
  # Check the value of n
  if (n < 1) {
    stop("n must be at least 1")
  }
  
  # Convert the colour to RGB
  colour_rgb <- grDevices::col2rgb(colour)[, 1]
  
  # Decide if we are heading towards white or black
  if (lighter) {
    end <- 255
  } else {
    end <- 0
  }
  
  # Calculate the red, green and blue for the shades
  # we calculate one extra point to avoid pure white/black
  red <- seq(colour_rgb[1], end, length.out = n + 1)[1:n]
  green <- seq(colour_rgb[2], end, length.out = n + 1)[1:n]
  blue <- seq(colour_rgb[3], end, length.out = n + 1)[1:n]
  
  # Convert the RGB values to hex codes
  shades <- grDevices::rgb(red, green, blue, maxColorValue = 255)
  
  return(shades)
}
```

These kinds of checks for parameter inputs are an important part of a
function that is going to be used by other people (or future you). They
make sure that all the input is correct before the function tries to do
anything and avoids confusing error messages. However they can be fiddly
and repetitive to write. If you find yourself writing lots of these
checks two packages that can make life easier by providing functions to
do it for you are {checkmate} and {assertthat}.

In the code above we have used the `stop()` function to raise an error.
If we wanted to give a warning we would use `warning()` and if just
wanted to give some information to the user we would use `message()`.
Using `message()` instead of `print()` or `cat()` is important because
it means the user can hide the messages using `suppressMessages()` (or
`suppressWarnings()` for warnings). Now if we try our tests again they
should pass.

If you want to see what parts of your code need testing you can run the
`devtools::test_coverage()` function (you will need to install the {DT}
and {covr} packages first). This function uses the {covr} package to
make a report showing which lines of your code are covered by tests.

## Dependencies

The `make_shades()` function produces shades of a colour but it would be
good to see what those look like. Below is a new function called
`plot_colours()` that can visualise them for us using {ggplot2}. Add the
following function to `colours.R`.

``` r
#' Plot colours
#'
#' Plot a vector of colours to see what they look like
#' 
#' @param colours Vector of colour to plot
#'
#' @return A ggplot2 object
#' @export
#'
#' @examples
#' shades <- make_shades("goldenrod", 5)
#' plot_colours(shades)
plot_colours <- function(colours) {
  plot_data <- data.frame(Colour = colours)
  
  ggplot(plot_data,
         aes(x = .data$Colour, y = 1, fill = .data$Colour,
             label = .data$Colour)) +
    geom_tile() +
    geom_text(angle = "90") +
    scale_fill_identity() +
    theme_void()
}
```

If we run `devtools::check()`, we’ll get the error:

    Error in ggplot(plot_data, aes(x = .data$Colour, y = 1, fill = .data$Colour,  : 
        could not find function "ggplot"

Just like when we export a function in our package we need to make it
clear when we are using functions in another package. To do this we can
use `usethis::use_package()`.

``` r
usethis::use_package("ggplot2")
```

This will add {ggplot2} to the `Imports` field in `DESCRIPTION`. If we
look in `DESCRIPTION` we will see the following line:

    Imports:
        ggplot2

Those two lines tell us that our package uses functions in {ggplot2}.
There are three main types of dependencies.

1.  `Imports` is the most common. This means that we use functions from
    these packages and they must be installed when our package is
    installed.
2.  The next most common is `Suggests`. These are packages that we use
    in developing our package (such as {testthat} which is already
    listed here) or packages that provide some additional, optional
    functionality. Suggested packages aren’t usually installed so we
    need to do a check before we use them. The output of
    `usethis::use_package()` will give you an example if you add a
    suggested package.
3.  The third type of dependency is `Depends`. If you depend on a
    package it will be loaded whenever your package is loaded. Depends
    shouldn’t usually be used unless your package closely complements
    another package. An example of when Depends is necessary is if you
    package mainly operates on an object defined by another package.

Should you use a dependency? Deciding which packages (and how many) to
depend on is a difficult and philosophical choice. Using functions from
other packages can save you time and effort in development but it might
make it more difficult to maintain your package. Some things you might
want to consider before depending on a package are:

- How much of the functionality of the package do you want to use?
- Could you easily reproduce that functionality?
- How well maintained is the package?
- How often is it updated? Packages that change a lot are more likely to
  break your code.
- How many dependencies of it’s own does that package have?
- Are you users likely to have the package installed already?

Packages like {ggplot2} are good choices for dependencies because they
are well maintained, don’t change too often, are commonly used and
perform a single task so you are likely to use many of the functions.

Now if we change the `plot_colours` function to use the {ggplot2}
namespace, we will get no more errors when we run `devtools::check()`
but a note.

``` r
#' Plot colours
#'
#' Plot a vector of colours to see what they look like
#' 
#' @param colours Vector of colour to plot
#'
#' @return A ggplot2 object
#' @export
#'
#' @examples
#' shades <- make_shades("goldenrod", 5)
#' plot_colours(shades)
plot_colours <- function(colours) {
  plot_data <- data.frame(Colour = colours)
  
  ggplot2::ggplot(plot_data,
                  ggplot2::aes(x = .data$Colour, y = 1, fill = .data$Colour,
                               label = .data$Colour)) +
    ggplot2::geom_tile() +
    ggplot2::geom_text(angle = "90") +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void()
}
```

To deal with the note, we need to import the {rlang} package.

``` r
usethis::use_package("rlang")
```

Writing `rlang::.data` wouldn’t be very attractive or readable. When we
want to use a function in another package without `::` we need to
explicitly import it. Just like when we exported our functions we do
this using a {Roxygen} comment.

``` r
#' Plot colours
#'
#' Plot a vector of colours to see what they look like
#' 
#' @param colours Vector of colour to plot
#'
#' @return A ggplot2 object
#' @export
#'
#' @importFrom rlang .data
#' 
#' @examples
#' shades <- make_shades("goldenrod", 5)
#' plot_colours(shades)
plot_colours <- function(colours) {
  plot_data <- data.frame(Colour = colours)
  
  ggplot2::ggplot(plot_data,
                  ggplot2::aes(x = .data$Colour, y = 1, fill = .data$Colour,
                               label = .data$Colour)) +
    ggplot2::geom_tile() +
    ggplot2::geom_text(angle = "90") +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void()
}
```

If we used `rlang::.data` in multiple functions in our package it might
make sense to only import it once. It doesn’t matter where we put the
`@importFrom` line (or how many times) it will still be added once to
NAMESPACE. This means we can put all import in a central location. The
advantage of this is that they only appear once and are all in one place
but it makes it harder to know which of our functions have which imports
and remove them if they are no longer needed. Which approach you take is
up to you.

## Other documentation

### Package help file

Users can find out about our functions using `?function-name` but what
if they want to find out about the package itself? There is some
information in the DESCRIPTION but that can be hard to access. We can
add a help file for the package using `usethis::use_package_doc()`.

``` r
usethis::use_package_doc()
```

This command will create `'R/mypkg-package.R'`, which contains the
following:

``` r
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
```

When we run `devtools::document()` a new .Rd file will be created and we
can view the contents using `?mypkg`. The information here has been
automatically pulled from the `DESCRIPTION` file so we only need to
update it in one place.

### Vignettes

The documentation we have written so far explains how individual
functions work in detail but it doesn’t show what the package does as a
whole. Vignettes are short tutorials that explain what the package is
designed for and how different functions can be used together. There are
different ways to write vignettes but usually they are R Markdown files.
We can create a vignette with `usethis::use_vignette()`. There can be
multiple vignettes but it is common practice to start with one that
introduces the whole package.

``` r
usethis::use_vignette("mypkg")
```

This will create `vignettes/mypkg.Rmd` that you can use to create a
tutorial for your package.

To see what the vignette looks like run `devtools::build_vignettes()`.
Asking {devtools} to build the vignette rather than rendering it in
another way (such as the Knit button in RStudio) makes sure that we are
using the development version of the package rather than any version
that is installed.

``` r
devtools::build_vignettes()
```

This creates `doc/` that contains the rendered vignette. If you want to
use any other packages in your vignette that the package doesn’t already
depend on you need to add them as a suggested dependency.

### README

If you plan on sharing the source code rather than the built package it
is useful to have a `README` file to explain what the package is, how to
install and use it, how to contribute, etc. We can create a template
with `usethis::use_readme_md()` (if we wanted to and R Markdown file
with R code and output we might use `usethis::use_readme_rmd()`
instead).

``` r
usethis::use_readme_rmd()
```

This will create `README.Rmd` and will be used to render `README.md`.

There are the comments near the top that mention badges and you might
have seen badges (or shields) on `README` files in code repositories
before. There are several {usethis} functions for adding badges. For
example we can mark this package as been at the experimental stage using
`usethis::use_lifecycle_badge()`.

``` r
usethis::use_lifecycle_badge("experimental")
```

### Package website

If you have a publicly available package it can be useful to have a
website displaying the package documentation. It gives your users
somewhere to go and helps your package appear in search results. Luckily
this is easily achieved using the {pkgdown} package. If you have it
installed you can set it up with {usethis}.

``` r
usethis::use_pkgdown()
```

## Versioning

Whenever you reach a milestone it is good to update the package version.
Having a good versioning system is important when it comes to things
like solving user issues. Version information is recorded in the
`DESCRIPTION` file. This version number follows the format
major.minor.patch.dev. The different parts of the version represent
different things:

- major - A significant change to the package that would be expected to
  break users code. This is updated very rarely when the package has
  been redesigned in some way.
- minor - A minor version update means that new functionality has been
  added to the package. It might be new functions to improvements to
  existing functions that are compatible with most existing code.
- patch - Patch updates are bug fixes. They solve existing issues but
  don’t do anything new.
- dev - Dev versions are used during development and this part is
  missing from release versions. For example you might use a dev version
  when you give someone a beta version to test. A package with a dev
  version can be expected to change rapidly or have undiscovered issues.

To increase the package version use `usethis::use_version()`.

``` r
usethis::use_version()
```

    Current version is 0.0.0.9000.
    What should the new version be? (0 to exit) 

    1: major --> 1.0.0
    2: minor --> 0.1.0
    3: patch --> 0.0.1
    4:   dev --> 0.0.0.9001

Whenever we update the package version we should record what changes
have been made. We do this is a `NEWS.md` file.

``` r
usethis::use_news_md()
```

This will create ‘NEWS.md’ and we can modify this file to record what
changes have been made.

## Building, installing, and releasing

If you want to start using your package in other projects the simplest
thing to do is to run `devtools::install()`. This will install your
package in the same way as any other package so that it can be loaded
with `library()`. However this will only work on the computer you are
developing the package on. If you want to share the package with other
people (or other computers you work on) there are a few different
options.

### Building

One way to share your package is to manually transfer it to somewhere
else. But rather then copying the development directory what you should
share is a pre-built package archive. Running `devtools::build()` will
bundle up your package into a `.tar.gz` file without any of the extra
bits required during development. This archive can then be transferred
to wherever you need it and installed using
`install.packages("mypkg.tar.gz", repos = NULL)` or
`R CMD INSTALL mypkg.tar.gz` on the command line. While this is fine if
you just want to share the package with yourself or a few people you
know, it doesn’t work if you want it to be available to the general
community.

### CRAN

The most common repository for public R packages is the Comprehensive R
Archive Network (CRAN). This is where packages are usually downloaded
from when you use `install.packages()`. Compared to similar repositories
for other programming languages, getting your package accepted to CRAN
means meeting a series of requirements. While this makes the submission
process more difficult it gives users confidence that your package is
reliable and will work on multiple platforms. It also makes your package
much easier to install for most users and makes it more discoverable.

See [Releasing to CRAN](https://r-pkgs.org/release.html) in the R
packages book, [Getting your R package on
CRAN](https://kbroman.org/pkg_primer/pages/cran.html), and [Checklist
for CRAN
submissions](https://cran.r-project.org/web/packages/submission_checklist.html)
for more information.

### Bioconductor

If your package is designed for analysing biological data you might want
to submit it to [Bioconductor](https://www.bioconductor.org/) rather
than CRAN. While Bioconductor has a smaller audience, it is more
specialised and is often the first place researchers in the life
sciences look. Building a Bioconductor package also means that you can
take advantage of the extensive ecosystem of existing objects and
packages for handling biological data types.

While there are lots of advantages to having your package on
Bioconductor the coding style is slightly different to what is often
used for CRAN packages. If you think you might want to submit your
package to Bioconductor in the future check out
<https://contributions.bioconductor.org/develop-overview.html>.

### rOpenSci

[rOpenSci](https://ropensci.org/) is not a package repository as such
but an organisation that reviews and improves R packages. Packages that
have been accepted by rOpenSci should meet a certain set of standards.
By submitting your package to rOpenSci you will get it reviewed by
experienced programmers who can offer suggestions on how to improve it.
If you are accepted you will receive assistance with maintaining your
package and it will be promoted by the organisation. Have a look at
their [submission page](https://github.com/ropensci/software-review) for
more details.

### Code sharing websites

Uploading your package to a code sharing website such as GitHub,
Bitbucket or GitLab offers a good compromise between making your package
available and going through an official submission process. This is a
particularly good option for packages that are still in early
development and are not ready to be submitted to one of the major
repositories. Making your package available on one of these sites also
gives it a central location for people to ask questions and submit
issues. Code sharing websites are usually accessed through the Git
version control system. If you are unfamiliar with using `git` on the
command line there are functions in {usethis} that can run the commands
for you from R.

To set up Git, first we need to configure our details.

``` r
usethis::use_git_config(user.name = "Your Name", user.email = "your@email.com")
```

The email address should be the same one you used to sign up to GitHub.
Now we can set up Git in our package repository.

``` r
usethis::use_git()
```

The next step is to link the directory on your computer with a
repository on GitHub. First we need to create a special access token.
The following command will open a GitHub website.

``` r
usethis::use_github()
```

Click the “Generate token” button on the webpage and then copy the code
on the next page. As it says you can only view this once so be careful
to copy it now and don’t close the page until you are finished. When you
have the code follow the rest of the instructions from usethis.

``` r
usethis::edit_r_environ()
```

Edit the file to look something like this (with your code).

    GITHUB_PAT=YOUR_CODE_GOES_HERE

Save it then restart R by clicking the Session menu and selecting
Restart R.

Copying that code and adding it to your `.Renviron` gives R on the
computer you are using access to your GitHub repositories. If you move
to a new computer you will need to do this again. Now that we have
access to GitHub we can create a repository for our packages.

``` r
usethis::use_github()
```

Respond to the prompts from {usethis} about the method for connecting to
GitHub and the title and description for the repository. When everything
is done a website should open with your new package repository. Another
thing this function does is add some extra information to the
description that lets people know where to find your new website.

    URL: https://github.com/user/mypkg
    BugReports: https://github.com/user/mypkg/issues

Now that your package is on the internet anyone can install it using the
`install_github()` function in the {remotes} package (which should
already be installed as a dependency of {devtools}). All you need to
give it is the name of the user and repository.

``` r
remotes::install_github("user/mypkg")
```

If you are familiar with Git you can install from a particular branch,
tag or commit by adding that after @.

``` r
remotes::install_github("user/mypkg@branch_name")
remotes::install_github("user/mypkg@tag_id")
remotes::install_github("user/mypkg@commit_sha")
```

After you make improvements to your package you will probably want to
update the version that is online. To do this you need to learn a bit
more about git. Jenny Bryan’s “[Happy Git with
R](https://happygitwithr.com/) tutorial is a great place to get started
but the (very) quick steps in RStudio are:

1.  Open the Git pane (it will be with Environment, History etc.)
2.  Click the check box next to each of the listed files
3.  Click the Commit button
4.  Enter a message in the window that opens and click the Commit button
5.  Click the Push button with the green up arrow

Refresh the GitHub repository website and you should see the changes you
have made.

## Advanced topics

Most of the following topics are covered in Hadley Wickham’s [Advanced R
book](https://adv-r.hadley.nz/).

### Including datasets

It can be useful to include small datasets in your R package which can
be used for testing and examples in your vignettes. You may also have
reference data that is required for your package to function. If you
already have the data as an object in R it is easy to add it to your
package with `usethis::use_data()`. The `usethis::use_data_raw()`
function can be used to write a script that reads a raw data file,
manipulates it in some way and adds it to the package with
`usethis::use_data()`. This is useful for keeping a record of what you
have done to the data and updating the processing or dataset if
necessary.

See the [Data section of R packages](https://r-pkgs.org/data.html) for
more details about including data in your package.

### Designing objects

If you work with data types that don’t easily fit into a table or matrix
you may find it convenient to design specific objects to hold them.
Objects can also be useful for holding the output of functions such as
those that fit models or perform tests. R has several different object
systems.

The S3 system is the simplest and probably the most commonly used.
Packages in the Bioconductor ecosystem make use of the more formal S4
system. If you want to learn more about designing R objects a good place
to get started is the [Object-oriented programming
chapter](https://adv-r.hadley.nz/oo.html) of Hadley Wickham’s Advanced R
book. Other useful guides include Nicholas Tierney’s [A Simple Guide to
S3 Methods](https://arxiv.org/abs/1608.07161) and Stuart Lee’s [S4: a
short guide for the
perplexed](https://stuartlee.org/2019/07/09/s4-short-guide/).

### Integrating other languages

If software for completing a task already exists but is in another
language it might make sense to write an R package that provides an
interface to the existing implementation rather than re-implementing it
from scratch. Here are some of the R packages that help you integrate
code from other languages:

- Rcpp (C++) <https://www.rcpp.org/>
- reticulate (Python) <https://rstudio.github.io/reticulate/>
- RStan (Stan) <https://mc-stan.org/users/interfaces/rstan>
- rJava (Java) <https://www.rforge.net/rJava/>

Another common reason to include code from another language is to
improve performance. While it is often possible to make code faster by
re-considering how things are done within R, sometimes there is no
alternative. The {Rcpp} package makes it very easy to write snippets of
C++ code that is called from R. Depending on what you are doing moving
even very small bits of code to C++ can have big impacts on performance.
Using {Rcpp} can also provide access to existing C libraries for
specialised tasks.

The [Rewriting R code in C++](https://adv-r.hadley.nz/rcpp.html) section
of Advanced R explains when and how to use {Rcpp}. You can find other
resources including a gallery of examples on the [official Rcpp
website](https://www.rcpp.org/).

### Metaprogramming

Metaprogramming refers to code that reads and modifies other code. This
may seem like an obscure topic but it is important in R because of its
relationship to non-standard evaluation (another fairly obscure topic).
You may not have heard of non-standard evaluation before but it is
likely you have used it. This is what happens whenever you provide a
function with a bare name instead of a string or a variable.
Metaprogramming particularly becomes relevant to package development if
you want to have functions that make use of packages in the Tidyverse
such as {dplyr}, {tidyr}, and {purrr}. The
[Metaprogramming](https://adv-r.hadley.nz/metaprogramming.html) chapter
of Advanced R covers the topic in more detail.

## Good practices and advice

This section contains some general advice about package development. It
may be opinionated in places so decide which things work for you.

### Design advice

- Compatibility - Make your package compatible with how your users
  already work. If there are data structure that are commonly used,
  write your functions to work with those rather than having to convert
  between formats.
- Ambition - It’s easy to get carried away with trying to make a package
  that does everything but try to start with whatever is most
  important/novel. This will give you a useful package as quickly and
  easily as possible and make it easier to maintain in the long run. You
  can always add more functionality later if you need to.
- Messages - Try to make your errors and messages as clear as possible
  and other advice about how to fix them. This can often mean writing a
  check yourself rather than relying on a default message from somewhere
  else.
- Check input - If there are restrictions on the values parameters can
  take, check them at the beginning of your functions. This prevents
  problems as quickly as possible and means you can assume values are
  correct in the rest of the function.
- Useability - Spend time to make your package as easy to use as
  possible. Users won’t know that your code is faster or produces better
  results if they can’t understand how to use your functions. This
  includes good documentation but also things like having good default
  values for parameters.
- Naming - Be obvious and consistent in how you name functions and
  parameters. This makes it easier for users to guess what they are
  without looking at the documentation. One option is to have a
  consistent prefix to function names (like {usethis} does) which makes
  it obvious which package they come from and avoids clashes with names
  in other packages.

### Coding style

Unlike some other languages, R is very flexible in how your code can be
formatted. Whatever coding style you prefer it is important to be
consistent. This makes your code easier to read and makes it easier for
other people to contribute to it. It is useful to document what coding
style you are using. The easiest way to do this is to adopt a existing
style guide such as those created for the
[Tidyverse](https://style.tidyverse.org/) or
[Google](https://google.github.io/styleguide/Rguide.html) or by [Jean
Fan](https://jef.works/R-style-guide/). If you are interested in which
styles people actually use, check out this analysis presented at [useR!
2019](https://github.com/chainsawriot/rstyle). When contributing to
other people’s projects, it is important (and polite) to conform to
their coding style rather than trying to impose your own.

If you want to make sure the style of your package is consistent there
are some packages that can help you do that. The {lintr} package will
flag any style issues (and a range of other programming issues) while
the {styler} package can be used to reformat code files. The
{goodpractice} package can also be used to analyse your package and
offer advice. If you are more worried about problems with the text parts
of your package (documentation and vignettes) then you can activate
spell checking with `usethis::use_spell_check()`.

### Version control

There are three main ways to keep tracks of changes to your package:

- Don’t keep track
- Save files with different versions
- Use a version control system (VCS)

While it can be challenging at first to get your head around Git (or
another VCS), it is highly recommended and worth the effort, both for
packages and your other programming projects. Here are something of the
big benefits of having your package in Git:

- You have a complete record of every change that has been made to the
  package
- It is easy to go back if anything breaks or you need an old version
  for something
- Because of this you don’t have to worry about breaking things and it
  is easier to experiment
- Much easier to merge changes from collaborators who might want to
  contribute to your package
- Access to a variety of platforms and services built around this
  technology, for example installing your package, hosting a package
  website and continuous integration

### Continuous integration

Continuous integration services can be used to automatically check your
package on multiple platforms whenever you make a significant change to
your package. They can be linked to your repository on code sharing
websites like GitHub and whenever you push a new version they will run
the checks for you. This is similar to what CRAN and Bioconductor do for
their packages but we doing it yourself you can be more confident that
you won’t run into issues when you submit your package to them. If your
package isn’t on one of the major repositories it helps give your users
confidence that it will be reliable. Use the `usethis::use_CI_SERVICE()`
function to set up CI.

## Resources

This section has links to additional resources on package development.

- [Writing R
  extensions](https://cran.r-project.org/doc/manuals/R-exts.html)
- [Bioconductor Package
  Guidelines](https://contributions.bioconductor.org/index.html)
- [rOpenSci Packages: Development, Maintenance, and Peer
  Review](https://devguide.ropensci.org/)
- [Developing Packages with the RStudio
  IDE](https://support.posit.co/hc/en-us/articles/200486488-Developing-Packages-with-the-RStudio-IDE)
- [Building, Testing, and Distributing
  Packages](https://support.posit.co/hc/en-us/articles/200486508-Building-Testing-and-Distributing-Packages)
- [Writing R Package
  Documentation](https://support.posit.co/hc/en-us/articles/200532317-Writing-R-Package-Documentation)
- [R Packages](https://r-pkgs.org/)
- [Advanced R](https://adv-r.hadley.nz/index.html)
- [Advanced R Course](https://privefl.github.io/advr38book/)
- [Writing an R package from scratch
  (Updated)](https://r-mageddon.netlify.app/post/writing-an-r-package-from-scratch/)
- [R package primer](https://kbroman.org/pkg_primer/)
- [R Package Development
  Pictorial](https://www.mjdenny.com/R_Package_Pictorial.html)
- [Developing R packages](https://github.com/jtleek/rpackages)
- [Instructions for creating your own R
  package](https://web.mit.edu/insong/www/pdf/rpackage_instructions.pdf)
- [R Forwards Package
  Workshop](https://github.com/forwards/workshops/tree/main/Chicago2019)
- [Write your own R package](https://stat545.com/package-overview.html)
- [How to develop good R packages (for open
  science)](https://masalmon.eu/2017/12/11/goodrpackages/)
- [Tidyverse style guide](https://style.tidyverse.org/)
- [Google’s R Style
  Guide](https://google.github.io/styleguide/Rguide.html)
- [Jean Fan’s R Style Guide](https://jef.works/R-style-guide/)
- [The evolution of R programming
  styles](https://github.com/chainsawriot/rstyle)

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
