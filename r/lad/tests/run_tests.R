library(testthat)
source("../lad.R")
test_results <- test_dir(".", reporter = "summary")
