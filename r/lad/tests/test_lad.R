library(testthat)
library(lad)

n <- 10000
beta_true <- as.matrix(c(3, 10))
x <- matrix(stats::rnorm(n), nrow = n)
X <- cbind(x, array(1, c(nrow(x))))
y <- X %*% beta_true + matrix(stats::rnorm(n), nrow = n)

test_that("test_lad", {
  beta_lad <- lad(X, y, l1_regularizer=.5)
  expect_equal(all.equal(beta_true, beta_lad, tol = 1e-2), TRUE)
})

test_that("test_lad_polyfit", {
  beta_lad <- lad_polyfit(x, y, l1_regularizer=.5)
  expect_equal(all.equal(beta_true, beta_lad, tol = 1e-2,
                         check.attributes = FALSE), TRUE)
})


test_that("test_lad_polyfit_noise_free", {
  order <- 15
  beta_true <- as.matrix(seq(0, order, by=1))
  x <- as.matrix(seq(-1, 1, length=n), nrow = n)
  X <- array(1, c(nrow(x)))
  for (i in 1:order) {
    X <- cbind(x ^ i , X)
  }
  y <- X %*% beta_true

  beta_lad <- lad_polyfit(x, y, order = order)
  expect_equal(all.equal(beta_true, beta_lad, tol = 1e-4,
                         check.attributes = FALSE), TRUE)
})
