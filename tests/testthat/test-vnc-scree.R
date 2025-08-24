test_that("vnc_scree works correctly with valid inputs", {
  
  # Create test data
  time_seq <- 1990:1999
  values_seq <- c(0.1, 0.2, 0.15, 0.25, 0.3, 0.28, 0.35, 0.4, 0.38, 0.45)
  
  # Test that function runs without error
  expect_no_error(vnc_scree(time_seq, values_seq, distance_measure = "sd"))
  expect_no_error(vnc_scree(time_seq, values_seq, distance_measure = "cv"))
  
  # Test with default distance measure
  expect_no_error(vnc_scree(time_seq, values_seq))
  
  # Test minimum case (3 time points)
  time_min <- c(1, 2, 3)
  values_min <- c(0.1, 0.2, 0.3)
  expect_no_error(vnc_scree(time_min, values_min))
})

test_that("vnc_scree error handling works correctly", {
  
  # Test uneven time sequence
  uneven_time <- c(1, 2, 4, 5)
  values <- c(0.1, 0.2, 0.3, 0.4)
  
  expect_error(vnc_scree(uneven_time, values), 
               "It appears that your time series contains gaps or is not evenly spaced")
  
  # Test mismatched lengths - note the typo in the original error message
  time_seq <- 1:5
  values_short <- c(0.1, 0.2, 0.3)
  
  expect_error(vnc_scree(time_seq, values_short),
               "Your time and values vectors must be the same length")
  
  # Test with NA values in time
  time_na <- c(1, 2, NA, 4)
  values_na <- c(0.1, 0.2, 0.3, 0.4)
  
  expect_error(vnc_scree(time_na, values_na))
})

test_that("vnc_scree handles edge cases correctly", {
  
  # Test with zeros
  time_zero <- 1:5
  values_zero <- c(0, 0, 0.1, 0, 0)
  expect_no_error(vnc_scree(time_zero, values_zero))
  
  # Test with identical values
  values_identical <- rep(0.5, 5)
  expect_no_error(vnc_scree(1:5, values_identical))
  
  # Test different distance measures produce plots
  time_seq <- 1:6
  values_seq <- c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6)
  
  expect_no_error(vnc_scree(time_seq, values_seq, distance_measure = "sd"))
  expect_no_error(vnc_scree(time_seq, values_seq, distance_measure = "cv"))
})

# Note: Testing plot output is challenging in automated tests
# The main goal is to ensure the function runs without error
# and handles edge cases appropriately
