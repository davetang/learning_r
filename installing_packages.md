Installing R packages
================

- [Notes on installing R packages](#notes-on-installing-r-packages)
- [Dependencies](#dependencies)
- [Session info](#session-info)

## Notes on installing R packages

The function `install.packages` from the {utils} packages can install
packages from repositories or local files.

Packages are installed to `.libPaths` by default.

``` r
.libPaths()
```

    ## [1] "/usr/local/lib/R/site-library" "/usr/local/lib/R/library"

Install the dependencies required to render this document.

``` r
my_packages <- c("rmarkdown", "knitr")

sapply(my_packages, function(x){
  if(!require(x, character.only = TRUE)){
    install.packages(x, quiet = TRUE)
  }
})
```

    ## Loading required package: rmarkdown

    ## Loading required package: knitr

    ## $rmarkdown
    ## NULL
    ## 
    ## $knitr
    ## NULL

Use a specific [mirror](https://cran.r-project.org/mirrors.html).

``` r
if(!require(remotes)){
  install.packages("remotes", repos = "https://cran.ism.ac.jp/", quiet = TRUE)
}
```

    ## Loading required package: remotes

``` r
packageVersion("remotes")
```

    ## [1] '2.4.2.1'

Use the {remotes} package to install a specific version of a package. If
the package is available on CRAN, look at the “Old sources:” section to
find older version.

``` r
remotes::install_version("beepr", version = "1.1", repos = "https://cran.ism.ac.jp/", quiet = TRUE)
packageVersion("beepr")
```

    ## [1] '1.1'

Update {beepr} by using `install.packages`.

``` r
install.packages("beepr", repos = "https://cran.ism.ac.jp/", quiet = TRUE)
packageVersion("beepr")
```

    ## [1] '1.3'

## Dependencies

List available packages at CRAN-like repositories using
`available.packages`.

``` r
avail_pack <- available.packages(repos = "https://cran.ism.ac.jp/")
str(avail_pack)
```

    ##  chr [1:20396, 1:17] "A3" "AalenJohansen" "AATtools" "ABACUS" "abasequence" ...
    ##  - attr(*, "dimnames")=List of 2
    ##   ..$ : chr [1:20396] "A3" "AalenJohansen" "AATtools" "ABACUS" ...
    ##   ..$ : chr [1:17] "Package" "Version" "Priority" "Depends" ...

[DESCRIPTION](https://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file)
of {ggplot2}.

``` r
names(avail_pack['ggplot2', ])
```

    ##  [1] "Package"               "Version"               "Priority"             
    ##  [4] "Depends"               "Imports"               "LinkingTo"            
    ##  [7] "Suggests"              "Enhances"              "License"              
    ## [10] "License_is_FOSS"       "License_restricts_use" "OS_type"              
    ## [13] "Archs"                 "MD5sum"                "NeedsCompilation"     
    ## [16] "File"                  "Repository"

Dependencies of {ggplot2}.

> The “Depends” field gives a comma-separated list of package names
> which this package depends on. Those packages will be attached before
> the current package when library or require is called. Each package
> name may be optionally followed by a comment in parentheses specifying
> a version requirement. The comment should contain a comparison
> operator, whitespace and a valid version number, e.g. ‘MASS (\>=
> 3.1-20)’.

``` r
avail_pack["ggplot2", "Depends"]
```

    ## [1] "R (>= 3.3)"

Imports of {ggplot2}.

> The “Imports” field lists packages whose namespaces are imported from
> (as specified in the NAMESPACE file) but which do not need to be
> attached. Namespaces accessed by the ‘::’ and ‘:::’ operators must be
> listed here, or in ‘Suggests’ or ‘Enhances’ (see below). Ideally this
> field will include all the standard packages that are used, and it is
> important to include S4-using packages (as their class definitions can
> change and the DESCRIPTION file is used to decide which packages to
> re-install when this happens). Packages declared in the ‘Depends’
> field should not also be in the ‘Imports’ field. Version requirements
> can be specified and are checked when the namespace is loaded.

``` r
avail_pack["ggplot2", "Imports"]
```

    ## [1] "cli, glue, grDevices, grid, gtable (>= 0.1.1), isoband,\nlifecycle (> 1.0.1), MASS, mgcv, rlang (>= 1.1.0), scales (>=\n1.2.0), stats, tibble, vctrs (>= 0.5.0), withr (>= 2.5.0)"

## Session info

This document was generated by rendering `installing_packages.Rmd` in
the RStudio Server instance created by `start_rstudio.sh`.

    ## [1] "2024-02-13 04:12:47 UTC"

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
    ## other attached packages:
    ## [1] remotes_2.4.2.1 knitr_1.45      rmarkdown_2.25 
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.3.2  fastmap_1.1.1   cli_3.6.2       tools_4.3.2    
    ##  [5] htmltools_0.5.7 yaml_2.3.8      xfun_0.42       digest_0.6.34  
    ##  [9] rlang_1.1.3     evaluate_0.23