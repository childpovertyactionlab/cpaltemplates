#' use_readme_cpal
#'
#' Adds a Child Poverty Action Lab specific README.
#'
#' @param name Name of analysis to put at top of README
#' @param open Boolean for whether or not to open the instructions
#'
#' @md
#' @export
use_readme_cpal <- function(name = "README", open = TRUE) {
  usethis::use_template(
    template = "README.md",
    data = list(Package = name, Version = ""),
    ignore = FALSE,
    open = open,
    package = "cpaltemplates"
  )
}
