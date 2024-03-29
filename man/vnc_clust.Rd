% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vnc_functions.R
\name{vnc_clust}
\alias{vnc_clust}
\title{This function is based on the work of Greis and Hilpert (2012) for
Variability-Based Neighbor Clustering. See here:
https://www.oxfordhandbooks.com/view/10.1093/oxfordhb/9780199922765.001.0001/oxfordhb-9780199922765-e-14}
\usage{
vnc_clust(time, values, distance.measure = c("sd", "cv"))
}
\arguments{
\item{time}{A vector of sequential time intervals like years or decades}

\item{values}{A vector containing normaized frequency counts}

\item{distance.measure}{Indicating whether the standard deviation or coefficient of variation should be used in dinstance calculations}
}
\value{
An hclust object
}
\description{
The idea is to use hierarchical clustering to aid "bottom up" periodization
of language change. The functions below are built on their original code here:
http://global.oup.com/us/companion.websites/fdscontent/uscompanion/us/static/companion.websites/nevalainen/Gries-Hilpert_web_final/vnc.individual.html
However, rather than producing a plot, this function returns
an "hclust" object. The advantage, is that an "hclust" object
can be used to produce not only base R dendrograms, but can be passed
to other functions for more detailed and controlled plotting.
}
