#' Generate confusion matrix rates/metrics
#'
#' @param tab Confusion matrix of class table
#' @param pos Name of the positive label
#' @param neg Name of the negative label
#' @param truth Where the truth/known set is stored, `row` or `col`
#' @param sig_fig The number of significant digits to use when calculating the rates/metrics
#'
#' @return A list
#'
#' @examples
#' generate_example <- function(){
#'   dat <- data.frame(
#'     n = 1:165,
#'     truth = c(rep("no", 60), rep("yes", 105)),
#'     pred = c(rep("no", 50), rep("yes", 10), rep("no", 5), rep("yes", 100))
#'   )
#'   table(dat$truth, dat$pred)
#' }
#' table_metrics(generate_example(), 'yes', 'no', 'row')

table_metrics <- function(tab, pos, neg, truth, sig_fig = 3){
  if(class(tab) != "table")
    stop("Input is not a table", call. = FALSE)
  if(all(c(pos, neg) %in% colnames(tab)) != TRUE)
    stop("One or more labels not found in table", call. = FALSE)
  if(truth == "row"){
    FP <- tab[neg, pos]
    FN <- tab[pos, neg]
    all_pos <- sum(tab[pos, ])
    all_neg <- sum(tab[neg, ])
    all_pos_pred <- sum(tab[, pos])
    all_neg_pred <- sum(tab[, neg])
  } else if(truth == "col"){
    FP <- tab[pos, neg]
    FN <- tab[neg, pos]
    all_pos <- sum(tab[, pos])
    all_neg <- sum(tab[, neg])
    all_pos_pred <- sum(tab[pos, ])
    all_neg_pred <- sum(tab[neg, ])
  } else {
    stop("truth should be row or col", call. = FALSE)
  }
  total <- sum(tab)
  TP <- tab[pos, pos]
  TN <- tab[neg, neg]
  l_ <- list(
    accuracy = signif((TP+TN)/total, digits = sig_fig),
    misclassifcation_rate = signif((FP+FN)/total, digits = sig_fig),
    error_rate = signif((FP+FN)/total, digits = sig_fig),
    true_positive_rate = signif(TP/all_pos, digits = sig_fig),
    sensitivity = signif(TP/all_pos, digits = sig_fig),
    recall = signif(TP/all_pos, digits = sig_fig),
    false_positive_rate = signif(FP/all_neg, digits = sig_fig),
    true_negative_rate = signif(TN/all_neg, digits = sig_fig),
    specificity = signif(TN/all_neg, digits = sig_fig),
    precision = signif(TP/all_pos_pred, digits = sig_fig),
    prevalance = signif(all_pos/total, digits = sig_fig)
  )
  l_$f1_score <- 2 * (l_$precision * l_$recall) / (l_$precision + l_$recall)
  return(l_)
}
