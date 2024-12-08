% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cpal_shiny.R
\name{cpal_shiny}
\alias{cpal_shiny}
\title{Generate a Shiny BSlib Theme with CPAL Standards}
\usage{
cpal_shiny()
}
\value{
A [bslib] theme object for use in Shiny applications.
}
\description{
This function generates a customized [shiny] BSlib theme according to Child Poverty Action Lab (CPAL) standards.
It is based on the "flatly" bootswatch theme and includes CPAL's branding colors for success, info, warning, and danger states, as well as custom font settings.
}
\examples{
\dontrun{
library(shiny)
shinyApp(
  ui = fluidPage(theme = cpal_shiny(), "Hello, CPAL!"),
  server = function(input, output) {}
)
}

}
