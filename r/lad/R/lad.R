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
  beta <- solve(t(X) %*% X + diag(l1_regularizer, p)) %*% t(X) %*% y
  reg_factor <- norm(beta, '1')
  lambda <- diag(l1_regularizer / reg_factor, p)
  Lk <- lambda
  k <- 1
  while (k <= maxiter) {
    l1_factor <- as.vector(eps + sqrt(abs(y - X %*% beta)))

    Xnorm <- X / l1_factor

    beta_k <- solve(t(Xnorm) %*% Xnorm + Lk) %*% t(Xnorm) %*% (y / l1_factor)
    rel_err <- norm(beta - beta_k, '1') / max(1., reg_factor)

    if (rel_err < rtol)
      break

    beta <- beta_k
    reg_factor <- norm(beta, '1')
    Lk <- lambda / reg_factor
    k <- k + 1
  }
  return (beta)
}

lad_polyfit <- function(x, y, order = 1, ...){
  # constructs Vandermonde's matrix
  X <- array(1, c(nrow(x)))
  for (i in 1:order) {
    X <- cbind(x ^ i , X)
  }
  return (lad(X, y, ...))
}
