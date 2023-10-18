#' cpal_shiny
#'
#' generates a shiny bslib theme to CPAL standards
#'
#' @md
#' @export
cpal_shiny <- function(){
  bslib::bs_theme(
    version = 5,
    bg = "#FFFFFF",
    fg = "#008097",
    primary = "#042D33",
    secondary = "#881354",
    success = "#009763",
    info = "#FEF6C7",
    warning = "#ED683F",
    danger = "#881354",
    font_scale = NULL,
    heading_font = bslib::font_google("Poppins"),
    base_font = bslib::font_google("Roboto"),
    code_font = bslib::font_google("Fira Code"),
    "enable-gradients" = TRUE,
    "enable-shadows" = TRUE,
    "progress-bar-bg" = "#042D33", # progress bar color
    "progress-bg" = "#83b6bf", # progress bar background color
    "body-color" = "#2F2F2F", # body text color

    bootswatch = "sandstone" # base shiny theme to modify
  )
}
