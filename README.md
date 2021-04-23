## VNC

This package contains functions based on the work of Greis and Hilpert (2012) for [Variability-Based Neighbor Clustering](https://www.oxfordhandbooks.com/view/10.1093/oxfordhb/9780199922765.001.0001/oxfordhb-9780199922765-e-14).

The idea is to use hierarchical clustering to aid "bottom up" periodization of language change. The functions are built on [their original code](http://global.oup.com/us/companion.websites/fdscontent/uscompanion/us/static/companion.websites/nevalainen/Gries-Hilpert_web_final/vnc.individual.html). However, rather than producing a plot, this function returns an "hclust" object. The advantage, is that an "hclust" object can be used to produce not only base R dendrograms, but can be passed to other functions for more detailed and controlled plotting.

## Installing and Running vnc

Use devtools to install the package.

```r
devtools::install_github("browndw/vnc")
```
