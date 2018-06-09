import tensorflow as tf
import numpy as np
from ..lad import lad


def test_least_absolute_deviations():
    m_true = 3
    b_true = 10
    x = np.linspace(0, 10, 200)
    y = x * m_true + b_true + np.random.normal(scale=2, size=x.shape)

    X = np.vstack([x, np.ones(len(x))])

    coeffs = lad(X.T, y)
    sess = tf.Session()
    m, b = sess.run(coeffs)

    assert abs(m - m_true)/m_true < 1e-1
    assert abs(b - b_true)/b_true < 1e-1
