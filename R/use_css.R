#' Add a CSS/SCSS Stylesheet to the Project
#'
#' \code{use_css} adds a Syntactically Awesome Style Sheet (SCSS) or CSS file to the specified directory for either Shiny apps or web reports.
#'
#' @param stylesheet Selection of stylesheet. Current options are `"shiny"`, and `"web_report"`.
#' @param directory The directory where the template should be saved (default is `"www"`). Use `NULL` to save the template to the project directory or current working directory.
#' @param open Logical. Should the newly created file be opened for editing? (default is `FALSE`).
#'
#' @md
#' @export
use_css <- function(stylesheet, directory = "www", open = FALSE) {

  # Validate the stylesheet argument
  valid_stylesheets <- c("shiny", "web_report")
  if (!stylesheet %in% valid_stylesheets) {
    stop("Invalid 'stylesheet' argument. Valid stylesheets are: 'shiny', 'web_report'.", call. = FALSE)
  }

  # Update template name based on stylesheet type
  template_name <- "styles.scss"
  if (stylesheet == "shiny") {
    template_name_format <- "format.css"
  }

  # Determine the destination directory
  save_name <- if (!is.null(directory)) {
    usethis::use_directory(directory)
    file.path(directory, template_name)
  } else {
    template_name
  }

  # Add SCSS template for both shiny and web report
  usethis::use_template(
    template = template_name,
    save_as = save_name,
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = open,
    package = "cpaltemplates"
  )

  # Add format.css for shiny specifically
  if (stylesheet == "shiny") {
    save_format <- file.path(directory, "format.css")
    usethis::use_template(
      template = "format.css",
      save_as = save_format,
      data = list(Package = "", Version = ""),
      ignore = FALSE,
      open = open,
      package = "cpaltemplates"
    )
  }

  # Optional: Add Quarto YAML if needed for web report templates
  if (stylesheet == "web_report") {
    usethis::use_template(
      template = "_quarto.yml",
      save_as = "_quarto.yml",
      data = list(Package = "", Version = ""),
      ignore = FALSE,
      open = open,
      package = "cpaltemplates"
    )
  }

  message("Stylesheet '", template_name, "' and associated files have been added to ", if (!is.null(directory)) directory else "current directory", ".")
}
