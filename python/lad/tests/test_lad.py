import tensorflow as tf
import numpy as np
import pytest
from ..lad import lad, lad_polyfit


sess = tf.Session()
m_true = 3
b_true = 10
x = np.linspace(0, 10, 10000)
y = x * m_true + b_true + np.random.laplace(scale=1., size=x.shape)


@pytest.mark.parametrize("yerr", [(None), (np.ones(len(y))), (np.std(y))])
def test_lad(yerr):
    X = np.vstack([x, np.ones(len(x))])
    m, b = sess.run(lad(X.T, y, yerr=yerr))
    assert abs(m - m_true)/m_true < 5e-2
    assert abs(b - b_true)/b_true < 5e-2


@pytest.mark.parametrize("yerr", [(None), (np.ones(len(y))), (np.std(y))])
def test_lad_polyfit(yerr):
    m, b = sess.run(lad_polyfit(x, y, yerr=yerr))
    assert abs(m - m_true)/m_true < 5e-2
    assert abs(b - b_true)/b_true < 5e-2

