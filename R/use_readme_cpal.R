#' Add a Child Poverty Action Lab Specific README
#'
#' \code{use_readme_cpal} adds a pre-defined CPAL README template, with the project name and optional version included at the top.
#'
#' @param name A character string for the name of the analysis or project (default is "README").
#' @param version A character string for the project or analysis version (optional).
#' @param open Boolean indicating whether or not to open the README file after creation (default is TRUE).
#'
#' @md
#' @export
use_readme_cpal <- function(name = "README", version = "1.0", open = TRUE) {

  # Add template for README
  usethis::use_template(
    template = "README.md",
    data = list(Package = name, Version = version),
    ignore = FALSE,
    open = open,
    package = "cpaltemplates"
  )

  # Inform the user
  message("README.md created successfully for project: ", name)
}
