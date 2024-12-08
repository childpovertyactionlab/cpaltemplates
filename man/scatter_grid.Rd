% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scatter_grid.R
\name{scatter_grid}
\alias{scatter_grid}
\title{Add Vertical Grid Lines for Scatter Plots}
\usage{
scatter_grid(colour = "#ccd4d5", linetype = "solid", size = 0.5)
}
\arguments{
\item{colour}{A character string specifying the color of the vertical grid lines (default is `"#ccd4d5"`).}

\item{linetype}{A character string specifying the line type (default is `"solid"`).}

\item{size}{A numeric value specifying the line size (default is `0.5`).}
}
\value{
A ggplot2 theme object with vertical grid lines added.
}
\description{
Adds vertical grid lines to a scatter plot, complementing the default horizontal grid lines in CPAL themes.
This function is useful for scatter plots to improve the clarity of the x-axis.
}
