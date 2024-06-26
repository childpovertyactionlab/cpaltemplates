% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scales.R
\name{scale_colour_ordinal}
\alias{scale_colour_ordinal}
\title{Discrete color scale for ordinal factors that aligns with Child Poverty Action Lab style}
\usage{
scale_colour_ordinal(...)
}
\arguments{
\item{...}{other arguments passed to \code{discrete_scale()}}
}
\description{
This function can only handle up to 8 categories/colors.
}
\details{
If you need more than 8 colors for exploratory purposes, use
ggplot2::scale_colour_ordinal().
}
