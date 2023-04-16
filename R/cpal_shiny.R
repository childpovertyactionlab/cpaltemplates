#' cpal_shiny
#'
#' generates a shiny bslib theme to CPAL standards
#'
#' @md
#' @export
cpal_shiny <- function() {

  bslib::bs_theme(
    version = 5,
    bg = "#E7ECEE",
    fg = "#008097",
    primary = "#008097",
    secondary = "#E98816",
    success = "#009763",
    info = "#008097",
    warning = "#E98816",
    danger = "#971700",
    font_scale = NULL,
    heading_font = gt::font_google("Poppins"),
    base_font = gt::font_google("Roboto"),
    code_font = gt::font_google("Fira Code"),
    "enable-gradients" = TRUE,
    "enable-shadows" = TRUE,
    "progress-bar-bg" = "#E98816", # progress bar color
    "progress-bg" = "#595959", # progress bar background color
    "body-color" = "#3f3f3f", # body text color

    bootswatch = "sandstone" # base shiny theme to modify
  )

}
