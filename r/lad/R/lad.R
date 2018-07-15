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
  l1_regularizer <- diag(l1_regularizer, p)
  beta <- solve_ls(X, y, l1_regularizer)
  reg_factor <- norm(beta, '1')
  k <- 1
  while (k <= maxiter) {
    l1_factor <- as.vector(eps + sqrt(abs(y - X %*% beta)))
    beta_k <- solve_ls(X/l1_factor, y/l1_factor, l1_regularizer/reg_factor)
    rel_err <- norm(beta - beta_k, '1') / max(1., reg_factor)

    if (rel_err < rtol)
      break

    beta <- beta_k
    reg_factor <- norm(beta, '1')
    k <- k + 1
  }
  return (beta)
}

solve_ls <- function(X, y, w) {
  return (solve(t(X) %*% X + w) %*% t(X) %*% y)
}

lad_polyfit <- function(x, y, order = 1, ...){
  # constructs Vandermonde's matrix
  X <- array(1, c(nrow(x)))
  for (i in 1:order) {
    X <- cbind(x ^ i , X)
  }
  return (lad(X, y, ...))
}
