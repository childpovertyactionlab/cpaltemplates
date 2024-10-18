#' Generate a Shiny BSlib Theme with CPAL Standards
#'
#' This function generates a customized [shiny] BSlib theme according to Child Poverty Action Lab (CPAL) standards.
#' It is based on the "flatly" bootswatch theme and includes CPAL's branding colors for success, info, warning, and danger states, as well as custom font settings.
#'
#' @return A [bslib] theme object for use in Shiny applications.
#' @examples
#' library(shiny)
#' shinyApp(
#'   ui = fluidPage(theme = cpal_shiny(), "Hello, CPAL!"),
#'   server = function(input, output) {}
#' )
#'
#' @export
cpal_shiny <- function(){
  bslib::bs_theme(
    version = 5,
    bootswatch = "flatly", # base shiny theme to modify
    bg = "#FFFFFF",
    fg = "#042D33",
    "body-color" = "#2F2F2F",
    primary = "#042D33",
    secondary = "#042D33",
    success = "#008097",
    info = "#EACA2D",
    warning = "#ED683F",
    danger = "#ED018C",
    font_scale = NULL,
    heading_font = bslib::font_google("Poppins"),
    base_font = bslib::font_google("Roboto"),
    code_font = bslib::font_google("Fira Code"),
    "enable-gradients" = TRUE,
    "enable-shadows" = TRUE,
    "enable-rounded" = TRUE,
    "enable-transitions" = TRUE,
    "progress-bar-bg" = "#881534", # progress bar color
    "progress-bg" = "#FFF9FB", # progress bar background color
    "body-color" = "#2F2F2F", # body text color
    "navbar-light-active-color" = "#FFF9FB !important",
    "nav-link-color" = "#FFF9FB !important",
    "nav-link-hover-color" = "#FFF9FB !important"
  )
}

