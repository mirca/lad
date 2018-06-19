source("lad.R")

n <- 1
m <- 450

set.seed(0)
beta_true <- as.matrix(c(5, 1))
X <- matrix(stats::rnorm(m * n), nrow = m, ncol = n)
X <- cbind(X, array(1, c(nrow(X))))
y_true <- X %*% beta_true
eps <- matrix(stats::rnorm(m), nrow = m)
factor <- 10*stats::rbinom(m, size = 1, prob = .1)
y <- y_true + factor + eps

beta_lad <- lad(X, y, yerr = sd(y), l1_regularizer = 1.)

d1 <- data.frame(X = X[,1], y = y)
d2 <- data.frame(X = X[,1], yHat = X %*% beta_lad)

library(ggplot2)
ggplot() +
    geom_point(data = d1, mapping = aes(x = X, y = y)) +
    geom_line(data = d2, mapping = aes(x = X, y = yHat))
