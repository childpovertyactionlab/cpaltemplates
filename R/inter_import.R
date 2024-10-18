#' Import and Register Inter Font
#'
#' \code{poppins_import()} checks if the Inter font is imported and registered on your system.
#' If not, it imports and registers the font using the \href{https://github.com/wch/extrafont}{extrafont} package.
#'
#' Note: The Inter font must be installed on your computer for \code{poppins_import()} to work.
#' Inter is the main font used by the Child Poverty Action Lab. To install, visit
#' \href{https://fonts.google.com/specimen/Inter}{Google Fonts} and download the Inter font family.
#' After downloading, unzip and install each of the .ttf files.
#'
#' You can test if Inter is imported and registered with \code{extrafont::fonts()}.
#'
#' @md
#' @export
poppins_import <- function() {

  if (sum(grepl("[Ii]nter$", extrafont::fonts())) > 0) {
    message("Inter is already imported and registered.")
  } else {
    local_fonts <- systemfonts::system_fonts()
    inter_fonts <- local_fonts[grepl(pattern = "[Ii]nter", x = local_fonts$family), ]
    inter_directories <- unique(gsub("[Ii]nter.*\\.ttf", "", inter_fonts$path))

    if (.Platform$OS.type == "unix") {
      warning(
        paste(
          "Unix (Mac) users may experience errors if library(Rttf2pt1)",
          "version is >= 1.3.9. Restart R and run:",
          "remotes::install_version('Rttf2pt1', version = '1.3.8').",
          "Then try poppins_import() again."
        )
      )
    }

    extrafont::font_import(paths = inter_directories, pattern = "[Ii]nter")
    extrafont::loadfonts()

    message("Inter font successfully imported and registered.")
  }
}
