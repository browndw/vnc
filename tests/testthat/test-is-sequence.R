test_that("is_sequence works correctly", {
  
  # Test valid sequences
  expect_true(is_sequence(1:10))
  expect_true(is_sequence(c(2, 4, 6, 8, 10)))
  expect_true(is_sequence(seq(0, 1, by = 0.1)))
  expect_true(is_sequence(c(1990, 2000, 2010, 2020)))
  
  # Test invalid sequences (should return FALSE)
  expect_false(is_sequence(c(1, 2, 4, 5)))  # uneven spacing
  expect_false(is_sequence(c(1, 2, 3, NA, 5)))  # contains NA
  expect_false(is_sequence(c(1, 2, 3, Inf)))  # contains Inf
  expect_false(is_sequence(c(1, 2, 3, -Inf)))  # contains -Inf
  expect_false(is_sequence(c(5)))  # single element
  expect_false(is_sequence(c()))  # empty vector
  expect_false(is_sequence(c(1, 1, 1, 1)))  # zero difference
  
  # Test edge cases
  expect_true(is_sequence(c(1, 2)))  # minimum valid sequence
  expect_false(is_sequence(c(1, 1)))  # two identical values
  
  # Test with tolerance
  slightly_uneven <- c(1, 2, 3.0001, 4)
  expect_true(is_sequence(slightly_uneven, tol = 0.01))
  expect_false(is_sequence(slightly_uneven, tol = 0.00001))
  
  # Test with negative numbers
  expect_true(is_sequence(c(-5, -3, -1, 1, 3)))
  expect_true(is_sequence(c(-10, -5, 0, 5, 10)))
  
  # Test with decimals
  expect_true(is_sequence(c(1.5, 2.5, 3.5, 4.5)))
  expect_false(is_sequence(c(1.1, 2.2, 3.4, 4.4)))  # uneven spacing
})
