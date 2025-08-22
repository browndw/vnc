#' Counts of the phrase "witch hunt" aggregated from Google Books
#'
#' Gives the usage of "witch hunt" in each decade for which there is Google
#' Books data. The data is lemmatized (including both singular and plural) and case
#' insensitive (including, for example, "witch hunt" and "WITCH HUNTS").
#'
#' @format A data frame containing 17 observations of 4 variables:
#' \describe{
#' \item{decade}{Decade}
#' \item{token_count}{Number of uses of "witch hunt" and variants}
#' \item{total_count}{Total number of tokens in Google Books corpus in this decade}
#' \item{counts_permil}{Uses of "witch hunt" per million tokens}
#' }
#' @source Google Books Ngram Viewer Datasets, at
#'   <https://storage.googleapis.com/books/ngrams/books/datasetsv3.html>

"witch_hunt"
