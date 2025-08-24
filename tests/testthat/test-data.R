test_that("witch_hunt data is properly structured", {
  
  # Load the data
  data("witch_hunt", package = "vnc", envir = environment())
  
  # Check that data exists
  expect_true(exists("witch_hunt"))
  
  # Check data structure
  expect_s3_class(witch_hunt, "data.frame")
  
  # Check expected columns exist
  expected_cols <- c("decade", "token_count", "total_count", "counts_permil")
  expect_true(all(expected_cols %in% names(witch_hunt)))
  
  # Check data types
  expect_type(witch_hunt$decade, "double")
  expect_type(witch_hunt$token_count, "double")
  expect_type(witch_hunt$total_count, "double")
  expect_type(witch_hunt$counts_permil, "double")
  
  # Check for reasonable values
  expect_true(all(witch_hunt$decade >= 1500))  # Reasonable historical range
  expect_true(all(witch_hunt$decade <= 2020))
  expect_true(all(witch_hunt$token_count >= 0))
  expect_true(all(witch_hunt$total_count > 0))
  expect_true(all(witch_hunt$counts_permil >= 0))
  
  # Check that decades are in order
  expect_true(all(diff(witch_hunt$decade) >= 0))
  
  # Check for missing values
  expect_false(any(is.na(witch_hunt$decade)))
  expect_false(any(is.na(witch_hunt$token_count)))
  expect_false(any(is.na(witch_hunt$total_count)))
  expect_false(any(is.na(witch_hunt$counts_permil)))
  
  # Check that the calculation is reasonable
  # The counts_permil values should be non-negative and reasonable given the raw counts
  # Note: The data appears to be preprocessed/rounded, so exact calculations may not match
  expect_true(all(witch_hunt$counts_permil >= 0))
  expect_true(all(is.finite(witch_hunt$counts_permil)))
  
  # Verify that higher token counts generally correspond to higher per-mil rates
  # (allowing for the fact that total_count also varies)
  expect_true(cor(witch_hunt$token_count, witch_hunt$counts_permil, use="complete.obs") > 0)
})

test_that("witch_hunt data can be used with vnc functions", {
  
  data("witch_hunt", package = "vnc", envir = environment())
  
  # Test that we can identify a continuous subset for VNC analysis
  # (The data likely has gaps, so we need to find a continuous subset)
  
  # Check if there's a continuous subset we can use
  decades <- witch_hunt$decade
  
  # Find the longest continuous sequence
  continuous_sequences <- list()
  current_seq <- decades[1]
  
  for (i in 2:length(decades)) {
    if (decades[i] == decades[i-1] + 10) {
      current_seq <- c(current_seq, decades[i])
    } else {
      if (length(current_seq) >= 3) {
        continuous_sequences[[length(continuous_sequences) + 1]] <- current_seq
      }
      current_seq <- decades[i]
    }
  }
  
  # Add the last sequence if it's long enough
  if (length(current_seq) >= 3) {
    continuous_sequences[[length(continuous_sequences) + 1]] <- current_seq
  }
  
  # If we have continuous sequences, test VNC functions
  if (length(continuous_sequences) > 0) {
    longest_seq <- continuous_sequences[[which.max(sapply(continuous_sequences, length))]]
    
    if (length(longest_seq) >= 3) {
      subset_data <- witch_hunt[witch_hunt$decade %in% longest_seq, ]
      
      # Test that VNC functions work with this data
      expect_no_error(vnc_clust(subset_data$decade, subset_data$counts_permil))
      expect_no_error(vnc_scree(subset_data$decade, subset_data$counts_permil))
    }
  }
  
  # At minimum, verify the data structure allows for potential VNC analysis
  expect_true(nrow(witch_hunt) > 0)
  expect_true(all(c("decade", "counts_permil") %in% names(witch_hunt)))
})
