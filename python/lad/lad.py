import tensorflow as tf
import math
import numpy as np

def lad(X, y, yerr=None, l1_regularizer=0., maxiter=50, rtol=1e-4,
        eps=1e-4, session=None):
    """
    Linear least absolute deviations with L1 norm regularization using
    Majorization-Minimization. See [1]_ for a similar mathematical derivation.

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
    maxiter : int
        Maximum number of iterations of the majorization-minimization algorithm.
        If maxiter equals zero, then this function returns the Weighted
        Least-Squares coefficients.
    rtol : float
        Relative tolerance used as an early stopping criterion.
    eps : float
        Inscrease this value if tensorflow raises an exception
        saying that the Cholesky decomposition was not successful.
    session : tf.Session object
        A tensorflow.Session object.

    Returns
    -------
    x : (m, 1) matrix
        Vector of coefficients that minimizes the least absolute deviations
        with L1 regularization.

    References
    ----------
    [1] Phillips, R. F. Least absolute deviations estimation via the EM
        algorithm. Statistics and Computing, 12, 281-285, 2002.
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

    with session or tf.Session() as session:
        # solves the L2 norm with L2 regularization problem
        # and use its solution as initial value for the MM algorithm
        x = tf.matrix_solve_ls(X_tensor, y_tensor, l2_regularizer=l1_regularizer)
        n = 0
        while n < maxiter:
            reg_factor = tf.norm(x, ord=1)
            l1_factor = tf.maximum(eps, tf.sqrt(tf.abs(y_tensor - tf.matmul(X_tensor, x))))

            X_tensor = X_tensor / l1_factor
            y_tensor = y_tensor / l1_factor

            # Solves the reweighted least squares problem with L2 regularization
            xo = tf.matrix_solve_ls(X_tensor, y_tensor,
                                    l2_regularizer=l1_regularizer/reg_factor)

            rel_err = tf.norm(x - xo, ord=1) / tf.maximum(tf.constant(1., dtype=tf.float64), reg_factor)
            x = xo
            if session.run(rel_err) < rtol:
                break
            n += 1
    return x
