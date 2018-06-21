suppressMessages(suppressWarnings(library(CVXR)))

lad <- function(X, y, yerr = NA, l1_regularizer = 0., maxiter = 50,
                rtol = 1e-4, eps = 1e-6) {
  X <- as.matrix(X)
  y <- as.array(y)

  if (is.na(yerr)) {
    yerr <- 1.
  } else {
    yerr <- as.vector(yerr) / sqrt(2.)
  }

  X <- X / yerr
  y <- y / yerr

  p <- ncol(X)
  beta <- Variable(p)
  beta_star <- solve_l2_l2(X, y, beta, l1_regularizer)
  n <- 1
  while (n <= maxiter) {
    reg_factor <- norm(beta_star, '1')
    l1_factor <- as.vector(eps + sqrt(abs(y - X %*% beta_star)))

    X <- X / l1_factor
    y <- y / l1_factor

    beta_tmp <- solve_l2_l2(X, y, beta, l1_regularizer / reg_factor)
    rel_err <- norm(beta_star - beta_tmp, '1') / max(1., reg_factor)

    if (rel_err < rtol)
      break
    n <- n + 1
  }

  return(beta_star)
}

solve_l2_l2 <- function(X, y, beta, lambda) {
  l2_l2 <- sum((y - X %*% beta) ^ 2) + lambda * sum(beta ^ 2)
  solution <- solve(Problem(Minimize(l2_l2)))
  return (as.matrix(solution$getValue(beta)))
}
