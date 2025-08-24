#' Test the "evenness" of a sequence.
#'
#' A sequence is "even" if it contains no `NA` or infinite values, and the
#' interval between each successive element is (approximately) identical.
#'
#' @param x A vector of integers or numbers.
#' @param tol Tolerance to use when checking that sequence steps are identical
#' @return Logical (whether the sequence is even)
#' @examples
#' # Even sequence
#' is_sequence(c(1, 2, 3, 4, 5))
#' 
#' # Uneven sequence
#' is_sequence(c(1, 3, 5, 7, 9))
#' 
#' # Sequence with gaps
#' is_sequence(c(1, 2, 4, 5, 6))
#' @export
is_sequence <- function(x, tol = sqrt(.Machine$double.eps)) {
  if (anyNA(x) || any(is.infinite(x)) || length(x) <= 1 ||
        diff(x[1:2]) == 0) {
    return(FALSE)
  }
  diff(range(diff(x))) <= tol
}


#' Conduct variability-based neighbor clustering
#'
#' The idea is to use hierarchical clustering to aid "bottom up" periodization
#' of language change. The functions below are built on their original code
#' here:
#' http://global.oup.com/us/companion.websites/fdscontent/uscompanion/us/static/
#' companion.websites/nevalainen/Gries-Hilpert_web_final/vnc.individual.html
#' However, rather than producing a plot, this function returns an "hclust"
#' object. The advantage, is that an "hclust" object can be used to produce not
#' only base R dendrograms, but can be passed to other functions for more
#' detailed and controlled plotting.
#'
#' @param time A vector of sequential time intervals like years or decades
#' @param values A vector containing normalized frequency counts
#' @param distance_measure Indicating whether the standard deviation or
#'   coefficient of variation should be used in distance calculations
#' @return An hclust object
#' @references Gries and Hilpert (2012).
#'   "Variability-based neighbor clustering: A bottom-up approach to
#'   periodization in historical linguistics",
#'   in Terttu Nevalainen, and Elizabeth Closs Traugott (eds), *The Oxford
#'   Handbook of the History of English*.
#'   \doi{10.1093/oxfordhb/9780199922765.013.0014}
#' @examples
#' \dontrun{
#' # Load example data
#' data(witch_hunt)
#' 
#' # First filter to complete decades only (evenly spaced sequence)
#' wh_complete <- witch_hunt[witch_hunt$decade %in% seq(1800, 2000, 10), ]
#' 
#' # Perform clustering
#' hc <- vnc_clust(wh_complete$decade, wh_complete$counts_permil)
#' plot(hc)
#' }
#' @importFrom stats sd
#' @export
vnc_clust <- function(time, values, distance_measure = c("sd", "cv")) {
  distance_measure <- match.arg(distance_measure)

  if (!is_sequence(time)) {
    stop("It appears that your time series contains gaps or is not ",
         "evenly spaced.")
  }
  if (length(time) != length(values)) {
    stop("Your time and values vectors must be the same length.")
  }

  input <- as.vector(values)
  years <- as.vector(time)
  names(input) <- years

  data_collector <- list()
  data_collector[["0"]] <- input
  position_collector <- list()
  position_collector[[1]] <- 0
  overall_distance <- 0
  number_of_steps <- length(input) - 1
  for (i in seq_len(number_of_steps)) {
    difference_checker <- numeric()
    for (j in seq_len(length(unique(names(input))) - 1)) {
      first_name <- unique(names(input))[j]
      second_name <- unique(names(input))[(j + 1)]
      pooled_sample <- input[names(input) %in% c(first_name, second_name)]
      if (distance_measure == "sd") {
        difference_checker[j] <- ifelse(sum(pooled_sample) == 0, 0,
                                        sd(pooled_sample))
      }
      if (distance_measure == "cv") {
        difference_checker[j] <- ifelse(sum(pooled_sample) == 0, 0,
                                        sd(pooled_sample) / mean(pooled_sample))
      }
    }
    pos_to_be_merged <- which.min(difference_checker)
    distance <- min(difference_checker)
    overall_distance <- overall_distance + distance
    lower_name <- unique(names(input))[pos_to_be_merged]
    higher_name <- unique(names(input))[(pos_to_be_merged + 1)]
    new_mean_age <- round(
      mean(as.numeric(names(input)[names(input) %in%
                                     c(lower_name, higher_name)])),
      4
    )
    position_collector[[(i + 1)]] <- which(names(input) == lower_name |
                                             names(input) == higher_name)
    names(input)[names(input) %in% c(lower_name, higher_name)] <-
      as.character(new_mean_age)
    data_collector[[(i + 1)]] <- input
    names(data_collector)[(i + 1)] <- distance
  }
  hc_build <- data.frame(start = unlist(lapply(position_collector, min)),
                         end = unlist(lapply(position_collector, max)))

  idx <- seq_len(nrow(hc_build))

  y <- lapply(idx, function(i) {
    match(hc_build$start[seq_len(i - 1)], hc_build$start[i])
  })
  z <- lapply(idx, function(i) {
    match(hc_build$end[seq_len(i - 1)], hc_build$end[i])
  })

  merge1 <- lapply(y, function(x) {
    ifelse(!all(is.na(x)), max(which(x == 1), na.rm = TRUE) - 1, NA)
  })

  merge2 <- lapply(z, function(x) {
    ifelse(!all(is.na(x)), max(which(x == 1), na.rm = TRUE) - 1, NA)
  })

  hc_build$merge1 <- lapply(idx, function(i) {
    min(merge1[[i]], merge2[[i]], na.rm = FALSE)
  })
  hc_build$merge2 <- suppressWarnings(lapply(idx, function(i) {
    max(merge1[[i]], merge2[[i]], na.rm = TRUE)
  }))
  hc_build$merge2 <- replace(hc_build$merge2, hc_build$merge2 == -Inf, NA)

  hc_build$merge1 <- ifelse(is.na(hc_build$merge1) == TRUE &
                              is.na(hc_build$merge2) == TRUE,
                            -hc_build$start, hc_build$merge1)
  hc_build$merge2 <- ifelse(is.na(hc_build$merge2) == TRUE,
                            -hc_build$end, hc_build$merge2)

  to_merge <- lapply(idx, function(i) {
    -setdiff(unlist(hc_build[i, 1:2]), unlist(hc_build[2:(i - 1), 1:2]))
  })

  hc_build$merge1 <- ifelse(is.na(hc_build$merge1) == TRUE,
                            to_merge, hc_build$merge1)

  hc_build <- hc_build[-1, ]

  height <- cumsum(as.numeric(names(data_collector[2:length(data_collector)])))
  order <- seq_along(data_collector)

  m <- matrix(c(unlist(hc_build$merge1), unlist(hc_build$merge2)),
              nrow = length(hc_build$merge1))
  hc <- list()
  hc$merge <- m
  hc$height <- height
  hc$order <- order
  hc$labels <- years
  class(hc) <- "hclust"
  return(hc)
}

#' Produce a scree plot based on the VNC algorithm
#'
#' @param time A vector of sequential time intervals like years or decades
#' @param values A vector containing normalized frequency counts
#' @param distance_measure Indicating whether the standard deviation or
#'   coefficient of variation should be used in distance calculations
#' @return A scree plot
#' @examples
#' \dontrun{
#' # Load example data
#' data(witch_hunt)
#' 
#' # First filter to complete decades only (evenly spaced sequence)
#' wh_complete <- witch_hunt[witch_hunt$decade %in% seq(1800, 2000, 10), ]
#' 
#' # Create scree plot
#' vnc_scree(wh_complete$decade, wh_complete$counts_permil)
#' }
#' @export
#' @importFrom graphics grid text
vnc_scree <- function(time, values, distance_measure = c("sd", "cv")) {

  if (missing(distance_measure)) distance_measure <- "sd"

  if (!is_sequence(time)) {
    stop("It appears that your time series contains gaps or is not ",
         "evenly spaced.")
  }
  if (length(time) != length(values)) {
    stop("Your time and values vectors must be the same length.")
  }

  input <- as.vector(values)
  years <- as.vector(time)
  names(input) <- years

  data_collector <- list()
  data_collector[["0"]] <- input
  position_collector <- list()
  position_collector[[1]] <- 0
  overall_distance <- 0
  number_of_steps <- length(input) - 1
  for (i in seq_len(number_of_steps)) {
    difference_checker <- numeric()
    for (j in seq_len(length(unique(names(input))) - 1)) {
      first_name <- unique(names(input))[j]
      second_name <- unique(names(input))[(j + 1)]
      pooled_sample <- input[names(input) %in% c(first_name, second_name)]
      if (distance_measure == "sd") {
        difference_checker[j] <- ifelse(sum(pooled_sample) == 0, 0,
                                        sd(pooled_sample))
      }
      if (distance_measure == "cv") {
        difference_checker[j] <- ifelse(sum(pooled_sample) == 0, 0,
                                        sd(pooled_sample) / mean(pooled_sample))
      }
    }
    pos_to_be_merged <- which.min(difference_checker)
    distance <- min(difference_checker)
    overall_distance <- overall_distance + distance
    lower_name <- unique(names(input))[pos_to_be_merged]
    higher_name <- unique(names(input))[(pos_to_be_merged + 1)]
    new_mean_age <- round(
      mean(as.numeric(names(input)[names(input) %in%
                                     c(lower_name, higher_name)])),
      4
    )
    position_collector[[(i + 1)]] <- which(names(input) == lower_name |
                                             names(input) == higher_name)
    names(input)[names(input) %in% c(lower_name, higher_name)] <-
      as.character(new_mean_age)
    data_collector[[(i + 1)]] <- input
    names(data_collector)[(i + 1)] <- distance
  }
  plot(rev(names(data_collector)) ~ seq_along(years), main = "'Scree' plot",
       xlab = "Clusters", ylab = "Distance in standard deviations",
       type = "n")
  grid()
  text(seq_along(years)[-length(years)],
       as.numeric(rev(names(data_collector)))[-length(years)],
       labels = round(
         as.numeric(rev(names(data_collector))), 2
       )[-length(years)],
       cex = 0.8)

}
