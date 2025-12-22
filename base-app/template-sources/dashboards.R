#' Create CPAL Dashboard Theme
#'
#' Initializes a Bootstrap 5 theme using `bslib` that automatically incorporates 
#' brand settings from `_brand.yml`. It also attempts to load an additional 
#' SCSS layer for custom CPAL-specific styling components.
#'
#' @return A `bs_theme` object with added CPAL metadata attributes:
#' \itemize{
#'   \item \code{cpal_variant}: Set to "dashboard".
#'   \item \code{cpal_version}: The version of the template (currently 1.0.0).
#'   \item \code{created}: Timestamp of theme initialization.
#' }
#' 
#' @details 
#' The function looks for a file at `www/cpal-theme.scss`. If found, these rules 
#' are compiled into the theme. If missing, a warning is issued via `cli`, but 
#' the base Bootstrap theme is still returned.
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' ui <- fluidPage(
#'   theme = cpal_dasbhoard_theme(),
#'   h1("CPAL Dashboard")
#' )
#' }
#' @export
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

#' @section TODO:
#' - Please verify that this function is needed and works as intended.
#' 
#' Save Enhanced CPAL SCSS File to Project
#'
#' Exports the enhanced CPAL SCSS source file from the package internal library 
#' to a local directory. This is useful for Quarto documents, standalone CSS 
#' compilation, or manual injection into Shiny apps.
#'
#' @param path Character string specifying where to save the SCSS file.
#'   Default is "cpal-enhanced.scss" in the current working directory.
#' @param overwrite Logical. Whether to overwrite an existing file at the destination.
#'
#' @return Invisibly returns the character path where the SCSS was saved.
#'
#' @section Usage in Quarto:
#' To use the exported file in Quarto, reference it in your YAML header:
#' \preformatted{
#' format:
#'   html:
#'     theme: cpal-enhanced.scss
#' }
#'
#' @examples
#' \dontrun{
#' # Export to current directory
#' cpal_export_scss()
#'
#' # Export to specific location with overwrite
#' cpal_export_scss("assets/styles/cpal-theme.scss", overwrite = TRUE)
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
