#' Generate a Shiny BSlib Theme with CPAL Standards
#'
#' This function generates a customized BSlib theme for Shiny applications according to
#' Child Poverty Action Lab (CPAL) visual standards. It integrates with the cpaltemplates
#' color system and provides consistent branding across web applications.
#'
#' The theme is based on Bootstrap 5 with custom CPAL colors, typography, and component
#' styling. It ensures accessibility compliance and maintains visual consistency with
#' other CPAL data visualizations created using cpaltemplates.

cpal_dasbhoard_theme <- function(
){
  theme <- bslib::bs_theme(
    version = 5,
    brand = TRUE
  )
  # Include external CSS file for enhanced CPAL styling
  css_path <- "www/cpal-theme.scss"
  if (file.exists(css_path)) {
    theme <- bslib::bs_add_rules(theme, sass::sass_file(css_path))
  } else {
    cli::cli_warn("CSS file not found at {.path {css_path}}. Ensure it is placed correctly.")
  }

  attr(theme, "cpal_variant") <- "dashboard"
  attr(theme, "cpal_version") <- "1.0.0"
  attr(theme, "created") <- Sys.time()

  return(theme)
}

#' Save Enhanced CPAL SCSS File to Project
#'
#' Exports the enhanced CPAL SCSS file to your project directory for use
#' in Quarto documents, standalone CSS compilation, or custom Shiny styling.
#'
#' @param path Character string specifying where to save the SCSS file.
#'   Default is "cpal-enhanced.scss" in current working directory.
#' @param overwrite Logical. Whether to overwrite existing file.
#'
#' @return Invisibly returns the file path where SCSS was saved
#'
#' @examples
#' \dontrun{
#' # Export to current directory
#' cpal_export_scss()
#'
#' # Export to specific location
#' cpal_export_scss("assets/styles/cpal-theme.scss")
#'
#' # For use in Quarto YAML:
#' # format:
#' #   html:
#' #     theme: cpal-enhanced.scss
#' }
#'
#' @export
cpal_export_scss <- function(path = "cpal-enhanced.scss", overwrite = FALSE) {
  # Check if file exists and handle overwrite
  if (file.exists(path) && !overwrite) {
    cli::cli_abort("File {.path {path}} already exists. Use {.code overwrite = TRUE} to replace it.")
  }

  # Get the SCSS content from package
  scss_source <- system.file("scss", "cpal-enhanced.scss", package = "cpaltemplates")

  if (!file.exists(scss_source)) {
    cli::cli_abort("Enhanced SCSS file not found in package. Ensure package is properly installed.")
  }

  # Copy file to specified location
  success <- file.copy(scss_source, path, overwrite = overwrite)

  if (!success) {
    cli::cli_abort("Failed to copy SCSS file to {.path {path}}")
  }

  cli::cli_inform(
    c("v" = "Enhanced CPAL SCSS exported to {.path {path}}", "i" = "Use in Quarto YAML: theme: {basename(path)}", "i" = "Use in Shiny: bs_theme() %>% bs_add_rules(sass_file('{path}'))")
  )

  invisible(path)
}
