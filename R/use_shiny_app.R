#' Add a Shiny Application Template
#'
#' \code{use_shiny_app} adds a template called \code{app.R} for creating R Shiny applications. This function does not require a name argument because the Child Poverty Action Lab Shiny server expects the file to be named \code{app.R}.
#'
#' The template will be added to the current working directory, or an existing \code{www} folder if needed for Shiny assets.
#'
#' @md
#' @export
use_shiny_app <- function() {

  # Ensure required directories
  if (!dir.exists("www")) {
    dir.create("www")
  }

  # Add Shiny app template
  usethis::use_template(
    template = "app.R",
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )

  message("Shiny app template 'app.R' has been added.")
}
