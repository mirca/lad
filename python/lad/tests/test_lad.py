import tensorflow as tf
import numpy as np
import pytest
from ..lad import lad, lad_polyfit


sess = tf.Session()
true_params = np.array([3, 10])
x = np.linspace(0, 10, 10000)
y = np.random.laplace(loc=x * true_params[0] + true_params[1], scale=1.)


@pytest.mark.parametrize("yerr", [(None), (np.ones(len(y))), (np.std(y))])
def test_lad(yerr):
    X = np.vstack([x, np.ones(len(x))])
    coeffs = sess.run(lad(X.T, y, yerr=yerr))
    assert ((abs(coeffs.flatten() - true_params) / true_params) < 5e-2).all()

@pytest.mark.parametrize("yerr", [(None), (np.ones(len(y))), (np.std(y))])
def test_lad_polyfit(yerr):
    coeffs = sess.run(lad_polyfit(x, y, yerr=yerr))
    assert ((abs(coeffs.flatten() - true_params) / true_params) < 5e-2).all()

@pytest.mark.parametrize("order", [(1), (2), (3)])
def test_lad_polyfit_order(order):
    coeffs = sess.run(lad_polyfit(x, y, order=order))
    assert ((abs(coeffs.flatten()[-2:] - true_params) / true_params) < 5e-2).all()

    if order > 1:
        assert (abs(coeffs[:-2]) < 1e-1).all()
