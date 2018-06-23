\name{lad}
\alias{lad}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
L1 regularized linear least squares
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
lad(X, y, yerr = NA, l1_regularizer = 0, maxiter = 50, rtol = 1e-04, eps = 1e-06)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{X}{
      The design matrix
}
  \item{y}{
      The vector of observables
}
  \item{yerr}{
      The error bars on the observables
}
  \item{l1_regularizer}{
      The regularizer factor
}
  \item{maxiter}{
      Max. number of iterations for the majorization-minimization
      algorithm
}
  \item{rtol}{
      Relative tolerance to stop the MM iterations
}
  \item{eps}{
      Small value to avoid division by zero
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{

  n <- 10000
  beta_true <- as.matrix(c(3, 10))
  X <- matrix(stats::rnorm(n), nrow = n)
  X <- cbind(X, array(1, c(nrow(X))))
  y <- X %*% beta_true + matrix(stats::rnorm(n), nrow = n)
  beta_lad <- lad(X, y, l1_regularizer=.5)

## The function is currently defined as
function (X, y, yerr = NA, l1_regularizer = 0, maxiter = 50, 
    rtol = 1e-04, eps = 1e-06) 
{
    X <- as.matrix(X)
    y <- as.array(y)
    if (is.na(yerr)) {
        yerr <- 1
    }
    else {
        yerr <- as.vector(yerr)/sqrt(2)
    }
    X <- X/yerr
    y <- y/yerr
    p <- ncol(X)
    beta <- solve(t(X) \%*\% X + diag(l1_regularizer, p)) \%*\% t(X) \%*\% 
        y
    k <- 1
    while (k <= maxiter) {
        reg_factor <- norm(beta, "1")
        l1_factor <- as.vector(eps + sqrt(abs(y - X \%*\% beta)))
        X <- X/l1_factor
        y <- y/l1_factor
        beta_k <- solve(t(X) \%*\% X + diag(l1_regularizer/reg_factor, 
            p)) \%*\% t(X) \%*\% y
        rel_err <- norm(beta - beta_k, "1")/max(1, reg_factor)
        if (rel_err < rtol) 
            break
        beta <- beta_k
        k <- k + 1
    }
    return(beta)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
