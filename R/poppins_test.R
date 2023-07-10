#' Test for Poppins import and registration
#'
#' \code{poppins_test} tests to see if Poppins is imported and registered. Poppins is
#' the Child Poverty Action Lab's main font and can be installed from
#' \href{https://fonts.google.com/specimen/Poppins}{Google fonts}.
#'
#' Import and register Poppins in R with poppins_import().
#'
#' @export
#'
poppins_test <- function() {

  if (sum(grepl("[Pp]oppins$", extrafont::fonts())) > 0) {

    "Poppins is imported and registered."

  } else {

    "Poppins isn't imported and registered. Install the poppins font from Google
    Fonts and import using poppins_import(). See ?poppins_import for more
    information."

  }
}
