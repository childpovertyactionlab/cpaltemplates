#' use_shiny_app
#'
#' Adds a template called app.R for creating R Shiny applications. There is no
#'   name argument because the Child Poverty Action Lab Shiny server expects app.R.
#'
#' @md
#' @export
use_shiny_app <- function() {
  usethis::use_template(
    template = "app.R",
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )
}
