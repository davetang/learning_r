#' Generate a confusion matrix based on case numbers
#'
#' @param TP Number of true positives
#' @param FP Number of false positives
#' @param FN Number of false negatives
#' @param TN Number of true negatives
#' @param pos Label for positive class
#' @param neg Label for negative class
#'
#' @return A list
#'
#' @examples
#' confusion_matrix(TP=100, TN=50, FN=5, FP=10)
#' confusion_matrix(TP=120, TN=170, FN=40, FP=70)

confusion_matrix <- function(TP, FP, FN, TN, pos = "yes", neg = "no"){
  dat <- data.frame(
    n = 1:(TP+FP+FN+TN),
    truth = c(rep(pos, TP+FN), rep(neg, TN+FP)),
    pred = c(rep(pos, TP), rep(neg, FN), rep(neg, TN), rep(pos, FP))
  )
  list(dat = dat, cm = table(dat$truth, dat$pred))
}
