#' Test for Poppins Font Import and Registration
#'
#' \code{poppins_test()} checks whether the Poppins font is imported and registered in R.
#' Poppins is the main font used by the Child Poverty Action Lab. If the font is not found,
#' instructions are provided for installing and importing it using \code{poppins_import()}.
#'
#' You can download the font from \href{https://fonts.google.com/specimen/Poppins}{Google Fonts}.
#'
#' @return A message indicating whether Poppins is successfully registered.
#' @export
poppins_test <- function() {
  if (any(grepl("[Pp]oppins$", extrafont::fonts()))) {
    message("Poppins is imported and registered.")
  } else {
    message("Poppins isn't imported or registered. Please install Poppins from Google Fonts and use poppins_import() to import it. See ?poppins_import for more information.")
  }
}
