## vnc

[![R-CMD-check](https://github.com/browndw/vnc/workflows/R-CMD-check/badge.svg)](https://github.com/browndw/vnc/actions)
[![Tests](https://github.com/browndw/vnc/workflows/Tests/badge.svg)](https://github.com/browndw/vnc/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/vnc)](https://CRAN.R-project.org/package=vnc)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/vnc)](https://cran.r-project.org/package=vnc)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This package contains functions based on the work of Greis and Hilpert (2012) for [Variability-Based Neighbor Clustering](https://www.oxfordhandbooks.com/view/10.1093/oxfordhb/9780199922765.001.0001/oxfordhb-9780199922765-e-14).

The idea is to use hierarchical clustering to aid "bottom up" periodization of language change. The functions are built on [their original code](http://global.oup.com/us/companion.websites/fdscontent/uscompanion/us/static/companion.websites/nevalainen/Gries-Hilpert_web_final/vnc.individual.html). However, rather than producing a plot, this function returns an [**hclust**](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/hclust) object. The advantage, is that an **hclust** object can be used to produce not only base R dendrograms, but can be passed to other functions for more detailed and controlled plotting.

## Installing vnc

Use devtools to install the package.

```r
devtools::install_github("browndw/vnc")
```
The package documentation is available on [readthedocs](https://cmu-textstat-docs.readthedocs.io/en/latest/vnc/vnc.html).
