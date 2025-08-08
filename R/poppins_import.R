#' Import and Register Poppins Font
#'
#' \code{poppins_import()} checks if the Poppins font is imported and registered. If not, it imports and registers Poppins using the \href{https://github.com/wch/extrafont}{extrafont} package.
#'
#' Note: Poppins must be installed on your computer for \code{poppins_import()} to work. Poppins is the Child Poverty Action Lab's main font. To install, visit \href{https://fonts.google.com/specimen/Poppins}{Google Fonts}, download, unzip, and install each of the .ttf files.
#'
#' @return A message indicating whether Poppins is already registered or has been successfully imported and registered.
#'
#' @md
#' @export
poppins_import <- function() {

  # Check if Poppins is already registered
  if (any(grepl("[Pp]oppins$", extrafont::fonts()))) {
    message("Poppins is already imported and registered.")
    return(invisible(NULL))
  }

  # Get a list of all system fonts
  local_fonts <- systemfonts::system_fonts()

  # Subset to Poppins fonts
  poppins_fonts <- local_fonts[grepl("[Pp]oppins", local_fonts$family), ]

  # Create directories where Poppins fonts are located
  poppins_directories <- unique(gsub("[Pp]oppins.*\\.ttf", "", poppins_fonts$path))

  # Warn Mac users about potential Rttf2pt1 issues
  if (.Platform$OS.type == "unix") {
    warning(
      paste(
        "Mac users may experience errors if library(Rttf2pt1) version >= 1.3.9.",
        "Run remotes::install_version('Rttf2pt1', version = '1.3.8')."
      )
    )
  }

  # Import and register Poppins fonts
  extrafont::font_import(paths = poppins_directories, pattern = "[Pp]oppins")
  extrafont::loadfonts()

  # Confirm Poppins registration
  message("Poppins font successfully imported and registered.")
  poppins_test()
}

