test_that("vnc_clust works correctly with valid inputs", {
  
  # Create test data
  time_seq <- 1990:1999
  values_seq <- c(0.1, 0.2, 0.15, 0.25, 0.3, 0.28, 0.35, 0.4, 0.38, 0.45)
  
  # Test basic functionality with sd
  hc_sd <- vnc_clust(time_seq, values_seq, distance_measure = "sd")
  
  expect_s3_class(hc_sd, "hclust")
  expect_equal(length(hc_sd$labels), length(time_seq))
  expect_equal(hc_sd$labels, time_seq)  # labels are integers, not characters
  expect_equal(length(hc_sd$height), length(time_seq) - 1)
  expect_equal(length(hc_sd$order), length(time_seq))
  expect_equal(nrow(hc_sd$merge), length(time_seq) - 1)
  expect_equal(ncol(hc_sd$merge), 2)
  
  # Test basic functionality with cv
  hc_cv <- vnc_clust(time_seq, values_seq, distance_measure = "cv")
  
  expect_s3_class(hc_cv, "hclust")
  expect_equal(length(hc_cv$labels), length(time_seq))
  expect_equal(hc_cv$labels, time_seq)  # labels are integers, not characters
  
  # Test that different distance measures give different results
  expect_false(identical(hc_sd$height, hc_cv$height))
  
  # Test with witch_hunt data (if available)
  data("witch_hunt", package = "vnc", envir = environment())
  if (exists("witch_hunt")) {
    # Filter to complete decades for testing
    wh_filtered <- witch_hunt[witch_hunt$decade >= 1900 & witch_hunt$decade <= 1990, ]
    if (nrow(wh_filtered) >= 3) {
      hc_wh <- vnc_clust(wh_filtered$decade, wh_filtered$counts_permil)
      expect_s3_class(hc_wh, "hclust")
    }
  }
})

test_that("vnc_clust handles edge cases correctly", {
  
  # Test minimum case (3 time points)
  time_min <- c(1, 2, 3)
  values_min <- c(0.1, 0.2, 0.3)
  hc_min <- vnc_clust(time_min, values_min)
  
  expect_s3_class(hc_min, "hclust")
  expect_equal(length(hc_min$height), 2)
  
  # Test with zeros
  time_zero <- 1:5
  values_zero <- c(0, 0, 0.1, 0, 0)
  hc_zero <- vnc_clust(time_zero, values_zero)
  
  expect_s3_class(hc_zero, "hclust")
  expect_true(all(is.finite(hc_zero$height)))
  
  # Test with identical values
  values_identical <- rep(0.5, 5)
  hc_identical <- vnc_clust(1:5, values_identical)
  
  expect_s3_class(hc_identical, "hclust")
  expect_equal(unique(hc_identical$height), 0)  # All heights should be 0
})

test_that("vnc_clust error handling works correctly", {
  
  # Test uneven time sequence
  uneven_time <- c(1, 2, 4, 5)
  values <- c(0.1, 0.2, 0.3, 0.4)
  
  expect_error(vnc_clust(uneven_time, values), 
               "It appears that your time series contains gaps or is not evenly spaced")
  
  # Test mismatched lengths
  time_seq <- 1:5
  values_short <- c(0.1, 0.2, 0.3)
  
  expect_error(vnc_clust(time_seq, values_short),
               "Your time and values vectors must be the same length")
  
  # Test with NA values in time
  time_na <- c(1, 2, NA, 4)
  values_na <- c(0.1, 0.2, 0.3, 0.4)
  
  expect_error(vnc_clust(time_na, values_na))
  
  # Test invalid distance measure
  expect_error(vnc_clust(1:5, c(0.1, 0.2, 0.3, 0.4, 0.5), distance.measure = "invalid"))
})

test_that("vnc_clust distance measures work correctly", {
  
  # Create test data where sd and cv should give different results
  time_seq <- 1:6
  # Values where mean changes significantly to test cv vs sd
  values_seq <- c(0.01, 0.02, 0.03, 1.0, 1.1, 1.2)
  
  hc_sd <- vnc_clust(time_seq, values_seq, distance_measure = "sd")
  hc_cv <- vnc_clust(time_seq, values_seq, distance_measure = "cv")
  
  # They should produce different clustering results
  expect_false(identical(hc_sd$height, hc_cv$height))
  
  # Both should be valid hclust objects
  expect_s3_class(hc_sd, "hclust")
  expect_s3_class(hc_cv, "hclust")
  
  # Heights should be non-negative
  expect_true(all(hc_sd$height >= 0))
  expect_true(all(hc_cv$height >= 0))
})
