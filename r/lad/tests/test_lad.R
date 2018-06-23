library(testthat)
library(lad)

test_that("test least absolute deviations", {
  n <- 10000
  beta_true <- as.matrix(c(3, 10))
  X <- matrix(stats::rnorm(n), nrow = n)
  X <- cbind(X, array(1, c(nrow(X))))
  y <- X %*% beta_true + matrix(stats::rnorm(n), nrow = n)
  beta_lad <- lad(X, y, l1_regularizer=.5)
  expect_equal(all.equal(beta_true, beta_lad, tol=1e-2), TRUE)
})
