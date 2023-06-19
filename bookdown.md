# bookdown book

Notes from reading [bookdown: Authoring Books and Technical Documents with R
Markdown](https://bookdown.org/yihui/bookdown/).

## Overview

**bookdown** is an R package for writing books, course handouts, study notes,
etc. They do not even have to be lengthy documents as many **bookdown** features
apply to single R Markdown documents too. For my notes, I will just refer to
the document to be rendered as a book.

The aim of **bookdown** is to simplify the entire process of writing a book. It
is built on top of R Markdown but has added features like:

* Multi-page HTML
* Numbering and cross-referencing figures/tables/sections/equations
* Inserting parts/appendices
* Creating elegant and appealing HTML book pages

The combination of R, Markdown, and Pandoc makes it possible to go from one
simple source format (R Markdown) to multiple possible output formats (PDF,
HTML, EPUB, Word, etc.).

In summary, **bookdown** helps you turn R Markdown book chapters into a beautiful
book.

## Getting started

1. Download, clone, or fork the
[bookdown-demo](https://github.com/rstudio/bookdown-demo) GitHub repository.
2. Install the **bookdown** package on RStudio.

    install.packages("bookdown")

3. Open `bookdown-demo.Rproj` in RStudio.
4. Open `index.Rmd` and click `Knit`.

## Usage

A typical **bookdown** book:

* Contains multiple chapters, with one R Markdown file for one chapter.
* Each R Markdown file must start immediately with the chapter title using the
  first-level heading, e.g., `# Chapter Title`.
* All R Markdown files must be encoded in UTF-8.

Below are example files.

* index.Rmd

```r
# Preface {-}

In this book, we will introduce an interesting
method.
```

* 01-intro.Rmd

```r
# Introduction

This chapter is an overview of the methods that
we propose to solve an **important problem**.
```

* 02-literature.Rmd

```r
# Literature

Here is a review of existing methods.
```

* 03-method.Rmd

```r
# Methods

We describe our methods in this chapter.
```

* 04-application.Rmd

```r
# Applications

Some _significant_ applications are demonstrated
in this chapter.

## Example one

## Example two
```

* 05-summary.Rmd

```r
# Final Words

We have finished a nice book.
```

By default, **bookdown** merges all Rmd files by the order of filenames, e.g.,
`01-intro.Rmd` will appear before `02-literature.Rmd`. Filenames that start
with an underscore `_` are skipped. If `index.Rmd` exists, it will always be
treated as the first file when merging all Rmd files.

A config file called `_bookdown.yml` can be used to define a different order.

    rmd_files: ["index.Rmd", "abstract.Rmd", "intro.Rmd"]

The chapter files do not have to be R Markdown but can be plain Markdown files
(`.md`).

Major output formats include:

* `bookdown::pdf_book`
* `bookdown::gitbook`
* `bookdown::html_book`
* `bookdown::epub_book`

There is a `bookdown::render_book()` function that is similar to
`rmarkdown::render()` but was designed to render multiple Rmd documents into a
book using the output format functions.

```r
bookdown::render_book("foo.Rmd", "bookdown::gitbook")
bookdown::render_book("foo.Rmd", "bookdown::pdf_book")
bookdown::render_book("foo.Rmd", bookdown::gitbook(lib_dir = "libs"))
bookdown::render_book("foo.Rmd", bookdown::pdf_book(keep_tex = TRUE))
```

There are two rendering approaches:

1. Merge all chapters into one Rmd file and knitting, known as Merge and Knit
   (M-K), and is the default
2. Knit each chapter in a separate R session and merge the Markdown output of
   all chapters, known as Knit and Merge (K-M)
