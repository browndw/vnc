# vnc: Variability-Based Neighbor Clustering

[![R-CMD-check](https://github.com/browndw/vnc/workflows/R-CMD-check/badge.svg)](https://github.com/browndw/vnc/actions)
[![Tests](https://github.com/browndw/vnc/workflows/Tests/badge.svg)](https://github.com/browndw/vnc/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/vnc)](https://CRAN.R-project.org/package=vnc)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/vnc)](https://cran.r-project.org/package=vnc)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

The **vnc** package implements Variability-Based Neighbor Clustering (VNC) for diachronic linguistics and time-series analysis. Based on the work of [Gries and Hilpert (2012)](https://www.oxfordhandbooks.com/view/10.1093/oxfordhb/9780199922765.001.0001/oxfordhb-9780199922765-e-14), VNC provides a data-driven approach to periodization in historical linguistics by identifying statistically meaningful periods of language change.

## Overview

Unlike traditional approaches that impose arbitrary time divisions (decades, centuries), VNC uses hierarchical clustering to group adjacent time points with similar frequency patterns. This "bottom-up" approach identifies periods based on variability in linguistic data, making it particularly useful for:

- **Historical linguistics**: Periodizing language change phenomena
- **Corpus linguistics**: Analyzing diachronic frequency patterns  
- **Time-series analysis**: Identifying natural breakpoints in temporal data
- **Digital humanities**: Studying cultural and linguistic trends over time

## Key Features

- **Data-driven periodization**: Automatically identifies meaningful time periods
- **Flexible distance measures**: Choose between standard deviation or coefficient of variation
- **R integration**: Returns standard `hclust` objects compatible with base R and other packages
- **Visualization tools**: Generate scree plots and customizable dendrograms
- **Robust validation**: Built-in checks for data completeness and sequence integrity

## Installation

Install the released version from CRAN:

```r
install.packages("vnc")
```

Or install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("browndw/vnc")
```

## Quick Start

```r
library(vnc)

# Load example data (Google Books frequencies of "witch hunt")
data(witch_hunt)

# Filter to complete decades (evenly spaced sequence required)
wh_complete <- witch_hunt[witch_hunt$decade %in% seq(1900, 1990, 10), ]

# Generate scree plot to identify optimal number of clusters
vnc_scree(wh_complete$decade, wh_complete$counts_permil)

# Perform VNC clustering
hc <- vnc_clust(wh_complete$decade, wh_complete$counts_permil)

# Visualize results
plot(hc, hang = -1, main = "VNC Dendrogram: 'Witch Hunt' Usage")
rect.hclust(hc, k = 3)  # Cut into 3 periods
```

## Main Functions

| Function | Purpose |
|----------|---------|
| `vnc_clust()` | Perform VNC clustering, returns `hclust` object |
| `vnc_scree()` | Generate scree plot for determining optimal clusters |
| `is_sequence()` | Validate that time data is evenly spaced |

## Documentation

- **Vignette**: See `vignette("introduction", package = "vnc")` for detailed examples
- **Help pages**: Use `?vnc_clust`, `?vnc_scree`, or `?witch_hunt` for function documentation
- **Online docs**: Available on [readthedocs](https://cmu-textstat-docs.readthedocs.io/en/latest/vnc/vnc.html)

## Citation

When using this package, please cite:

```text
Brown, D. W. & Reinhart, A. (2024). vnc: Variability-Based Neighbor Clustering for Time-Series Data. 
R package version 1.0.1. https://CRAN.R-project.org/package=vnc
```

And the original methodology:

```text
Gries, S. T. & Hilpert, M. (2012). Variability-based neighbor clustering: A bottom-up approach to 
periodization in historical linguistics. In T. Nevalainen & E. C. Traugott (Eds.), The Oxford 
Handbook of the History of English. Oxford University Press. 
https://doi.org/10.1093/oxfordhb/9780199922765.013.0014
```
