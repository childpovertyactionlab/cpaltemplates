#' Add a Web Report Template
#'
#' \code{use_web_report} adds a web report template and necessary assets (such as images) to a specified directory. If a directory is provided, the template will be saved in that directory.
#'
#' @param name A character string for the name of the created template (default is "web_report.qmd").
#' @param directory A character string for the directory where the template should be saved (optional).
#'
#' @md
#' @export
use_web_report <- function(name = "web_report.qmd", directory = NULL) {

  # Create directory if specified
  if (!is.null(directory)) {
    usethis::use_directory(directory)
    save_name <- file.path(directory, name)
  } else {
    save_name <- name
  }

  # Ensure web images exist
  if (!file.exists("www/images/CPAL_Logo_White.png")) {
    use_content(content = "web images")
  }

  # Add template files
  usethis::use_template(
    template = "styles.qmd",
    save_as = save_name,
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )

  # Add Quarto configuration file
  usethis::use_template(
    template = "_quarto.yml",
    save_as = file.path(directory, "_quarto.yml"),
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )
}
