#' use_readme_cpal
#'
#' Adds a Child Poverty Action Lab specific README using a pre-defined template.
#'
#' @param name Name of the analysis to put at the top of the README.
#' @param version Version of the project or analysis (optional).
#' @param open Boolean for whether or not to open the README file after creation.
#'
#' @md
#' @export
use_readme_cpal <- function(name = "README", version = NULL, open = TRUE) {

  # Ensure the version argument is non-null for better template flexibility
  version <- ifelse(is.null(version), "", version)

  # Check if the template file exists within the package
  if (!file.exists(system.file("templates/README.md", package = "cpaltemplates"))) {
    stop("README template not found. Please ensure it is installed correctly in the package.")
  }

  # Use the template to generate the README
  usethis::use_template(
    template = "README.md",
    data = list(Package = name, Version = version),
    ignore = FALSE,
    open = open,
    package = "cpaltemplates"
  )

  message("README.md created successfully for ", name)
}
