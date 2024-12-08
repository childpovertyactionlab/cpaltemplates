% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cpal_plot.R
\name{cpal_plot}
\alias{cpal_plot}
\title{Create a Formatted CPAL Plot}
\usage{
cpal_plot(..., heights = 1)
}
\arguments{
\item{...}{CPAL plot objects or grid graphical objects (grobs) to be combined.}

\item{heights}{A numeric vector specifying the relative heights of each object in the final plot. Default is 1 for equal heights.}
}
\value{
A combined plot made from multiple grobs.
}
\description{
Combines multiple CPAL plot elements or graphical objects (grobs) into one formatted plot.
This function makes it easy to compose various plot components such as titles, subtitles, axes labels, legends, notes, and sources into a cohesive plot.
}
\examples{
\dontrun{
library(ggplot2)
p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
title <- cpal_title("Title")
subtitle <- cpal_subtitle("Subtitle")
cpal_plot(title, subtitle, p)
}

}
