#' Calculate different tissue specificity metrics
#'
#' Code for metrics adapted from https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5444245/#sup1
#'
#' @param x Vector of expression values
#' @param metric Tissue specificity metric (tau, tsi, gini, hg, spm)
#'
#' @return A double
#'
#' @examples
#' tissue_specificity(rnorm(n = 100, mean = 30, sd = 10), "tau")

tissue_specificity <- function(x, metric){
  if (metric == "tau") {
    x <- (1-(x/max(x)))
    res <- sum(x, na.rm=TRUE)
    return(res/(length(x)-1))
  } else if (metric == "tsi") {
    return(max(x) / sum(x))
  } else if (metric == "gini") {
    # code is from the reldist package by Mark S. Handcock
    # https://cran.r-project.org/web/packages/reldist/index.html
    weights <- rep(1, length = length(x))
    ox <- order(x)
    x <- x[ox]
    weights <- weights[ox]/sum(weights)
    p <- cumsum(weights)
    nu <- cumsum(weights * x)
    n <- length(nu)
    nu <- nu/nu[n]
    return(sum(nu[-1] * p[-n]) - sum(nu[-n] * p[-1]))
  } else if (metric == "hg") {
    p <- x / sum(x)
    res <- -sum(p*log2(p), na.rm=TRUE)
    return(1 - (res/log2(length(p))))
  } else if (metric == "spm") {
    res <- x^2/sum(x^2)
    return(max(res))
  } else {
    stop(paste0("Unknown metric: ", metric))
  }
}