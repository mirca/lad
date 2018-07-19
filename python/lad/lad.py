import tensorflow as tf
import math
import numpy as np


__all__ = ['lad', 'lad_polyfit']


def lad(X, y, yerr=None, l1_regularizer=0., cov=False, maxiter=50, rtol=1e-4,
        eps=1e-4, session=None):
    """
    Linear least absolute deviations with L1 norm regularization using
    Majorization-Minimization. See [1] for a similar mathematical derivation.

    Parameters
    ----------
    X : (n, m)-matrix
        Design matrix.
    y : (n, 1) matrix
        Vector of observations.
    yerr : (n, 1) matrix
        Vector of standard deviations on the observations.
    l1_regularizer : float
        Factor to control the importance of the L1 regularization.
    cov : boolean
        Whether or not to return the covariance matrix of the best fitted
        coefficients. Standard errors on the coefficients can be computed
        as the square root of the diagonal of the covariance matrix.
    maxiter : int
        Maximum number of iterations of the majorization-minimization algorithm.
        If maxiter equals zero, then this function returns the Weighted
        Least-Squares coefficients.
    rtol : float
        Relative tolerance on the coefficients used as an early stopping
        criterion. If |x_{k+1} - x_{k}|/max(1, |x_{k}|) < rtol,
        where |x| is the L1-norm of x, the algorithm stops.
    eps : float
        Increase this value if tensorflow raises an exception
        saying that the Cholesky decomposition was not successful.
    session : tf.Session object
        A tensorflow.Session object.

    Returns
    -------
    x : (m, 1) matrix
        Vector of coefficients that minimizes the least absolute deviations
        with L1 regularization.
    cov : (m, m) matrix
        Covariance matrix of ``x``.

    References
    ----------
    [1] Phillips, R. F. Least absolute deviations estimation via the EM algorithm. Statistics and Computing, 12, 281-285, 2002.
    """

    if yerr is not None:
        whitening_factor = yerr/math.sqrt(2.)
    else:
        whitening_factor = 1.

    # converts inputs to tensors
    X_tensor = tf.convert_to_tensor((X.T / whitening_factor).T, dtype=tf.float64)
    y_tensor = tf.reshape(tf.convert_to_tensor(y / whitening_factor,
                                               dtype=tf.float64), (-1, 1))
    eps = tf.convert_to_tensor(eps, dtype=tf.float64)
    one = tf.constant(1., dtype=tf.float64)

    with session or tf.Session() as session:
        # solves the L2 norm with L2 regularization problem
        # and use its solution as initial value for the MM algorithm
        x = tf.matrix_solve_ls(X_tensor, y_tensor, l2_regularizer=l1_regularizer)
        n = 0
        while n < maxiter:
            reg_factor = tf.norm(x, ord=1)
            l1_factor = tf.maximum(eps,
                                   tf.sqrt(tf.abs(y_tensor - tf.matmul(X_tensor, x))))
            # solve the reweighted least squares problem with L2 regularization
            xo = tf.matrix_solve_ls(X_tensor/l1_factor, y_tensor/l1_factor,
                                    l2_regularizer=l1_regularizer/reg_factor)
            # compute stopping criterion
            rel_err = tf.norm(x - xo, ord=1) / tf.maximum(one, reg_factor)
            # update
            x = xo
            if session.run(rel_err) < rtol:
                break
            n += 1
    if cov:
        reg_factor = tf.norm(x, ord=1)
        l1_factor = tf.maximum(eps,
                               tf.sqrt(tf.abs(y_tensor - tf.matmul(X_tensor, x))))
        Xn = X_tensor/l1_factor
        p = tf.shape(Xn)[1]
        Ip = tf.eye(p, dtype=tf.float64)
        cov = tf.matrix_solve(tf.matmul(tf.transpose(Xn), Xn)
                              + (l1_regularizer/reg_factor) * Ip, Ip)
        return x, cov
    else:
        return x


def lad_polyfit(x, y, order=1, **kwargs):
    """Least absolute deviations polynomial fitting.

    Fit a polynomial ``p(x) = p[0]  + ... + p[order] * x**order`` of degree
    ``order`` to points (x, y). Returns a vector of coefficients ``p``
    that minimises the absolute error.

    Parameters
    ----------
    x : (n, 1)-matrix
        x-coordinate of the observations.
    y : (n, 1) matrix
        Vector of observations.
    order : int
        Degree of the fitting polynomial.
    **kwargs : dict
        See the docstrings of ``lad``.

    Returns
    -------
    p : (m, 1) matrix
        Vector of coefficients that minimizes the least absolute deviations
        with L1 regularization.

    """
    return lad(np.vander(x, N=order+1), y, **kwargs)
