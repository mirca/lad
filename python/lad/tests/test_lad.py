import tensorflow as tf
import numpy as np
from ..lad import lad


def test_least_absolute_deviations():
    sess = tf.Session()
    m_true = 3
    b_true = 10
    x = np.linspace(0, 10, 10000)
    y = x * m_true + b_true + np.random.laplace(scale=1., size=x.shape)
    X = np.vstack([x, np.ones(len(x))])

    m, b = sess.run(lad(X.T, y))
    assert abs(m - m_true)/m_true < 5e-2
    assert abs(b - b_true)/b_true < 5e-2

    m, b = sess.run(lad(X.T, y, yerr=np.std(y)))
    assert abs(m - m_true)/m_true < 5e-2
    assert abs(b - b_true)/b_true < 5e-2
