#' cpal_shiny
#'
#' generates a shiny bslib theme to CPAL standards
#'
#' @md
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
    "navbar-light-active-color" = "#FFF9FB !important", # does work!!!
    "nav-link-color" = "#FFF9FB !important",
    "nav-link-hover-color" = "#FFF9FB !important",
  )
}
