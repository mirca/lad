lad
===

|ci-badge| |appveyor-badge| |cov-badge| |zenodo-badge| |downloads-badge|


.. |ci-badge| image:: https://travis-ci.org/mirca/lad.svg?branch=master
    :target: https://travis-ci.org/mirca/lad
.. |cov-badge| image:: https://codecov.io/gh/mirca/lad/branch/master/graph/badge.svg
    :target: https://codecov.io/gh/mirca/lad/branch/master/
.. |zenodo-badge| image:: https://zenodo.org/badge/136721899.svg
   :target: https://zenodo.org/badge/latestdoi/136721899
.. |appveyor-badge| image:: https://ci.appveyor.com/api/projects/status/j0fitxs1hmyogntv/branch/master?svg=true
                    :target: https://ci.appveyor.com/project/mirca/lad
.. |downloads-badge| image:: https://pepy.tech/badge/lad
   :target: https://pepy.tech/project/lad
.. |buy-me-a-coffee| image:: https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png
   :target: https://www.buymeacoffee.com/Csg8p1Y

Linear least absolute deviations with L1 regularization.

In estimation theory terms, this is the Maximum A Posterior (MAP) estimator for
a Laplacian likelihood with Laplacian prior, i.e.

.. image:: lad.png

The algorithm yield by the Majorization-Minimization framework turns out to be
an iteratively reweighted least-squares. See ``notes/notes.pdf``.

Python Version
--------------

To install the development version, proceed as follows::

    git clone https://github.com/mirca/lad.git
    pip install -e lad

Or install the lastest version on PyPi::

    pip install lad

Installation dependencies::

    - tensorflow

Test dependencies::

    - numpy
    - tensorflow
    - pytest
    - pytest-cov

R version
---------

Inside the R console, type::

    devtools::install_github("mirca/lad/r/lad")

Support
-------

If this software has been useful to you, please consider buying me a coffee at
|buy-me-a-coffee| or via WeChat:

.. image:: static/wechat_pay.jpg

Thanks!
