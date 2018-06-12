lad
===

Least absolute deviations with L1 regularization using majorization-minimization.
In estimation theory terms, this is the Maximum A Posterior (MAP) estimator for
a Laplacian likelihood with Laplacian prior, i.e.

.. image:: lad.png

The MM algorithm update turns out to be

.. image:: lad2.png

which belongs to the class of iterative reweighted least-squares: https://en.wikipedia.org/wiki/Iteratively_reweighted_least_squares

Installation
------------

To install the development version, proceed as follows::

    git clone https://github.com/mirca/lad.git
    pip install -e lad

Or install the lastest version on PyPi::

    pip install lad

Dependencies
------------

Installation dependencies::

    - tensorflow

Test dependencies::

    - numpy
    - tensorflow
    - pytest
    - pytest-cov
