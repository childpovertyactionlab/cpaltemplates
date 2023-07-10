#' Import and register Poppins font
#'
#' \code{poppins_import()} tests to see if Poppins is imported and registered. If
#' Poppins, isn't imported and registered, then \code{poppins_import()} imports and
#' registers Poppins with
#' \href{https://github.com/wch/extrafont}{library(extrafont)}.
#'
#' Note: Poppins must be installed on your computer for \code{poppins_import()} to
#' work. Poppins is the Child Poverty Action Lab's main font. To install, visit
#' \href{https://fonts.google.com/specimen/Poppins}{Google fonts} and click
#' "Download family". Unzip and open each of the .ttf files and click install.
#'
#' Test to see if Poppins is imported and registered with \code{poppins_test()}.
#'
#' @md
#' @export
poppins_import <- function() {

  if (sum(grepl("[Pp]oppins$", extrafont::fonts())) > 0) {

    "Poppins is already imported and registered."

  } else {

    # get a list of all fonts on the machine
    local_fonts <- systemfonts::system_fonts()

    # subset the list to just poppins fonts
    poppins_fonts <- local_fonts[grepl(pattern = "[Pp]oppins", x = local_fonts$family), ]

    # create a vector of directories where poppins fonts are located
    poppins_directories <- unique(gsub("[Pp]oppins.*\\.ttf", "", poppins_fonts$path))

    # add a warning for unix users about Rttf2pt1 version
    if (.Platform$OS.type == "unix") {

      print(
        paste(
            "Unix (Mac) users may experience errors if the library(Rttf2pt1)",
            "version is >= 1.3.9. Restart R. Run",
            "remotes::install_version('Rttf2pt1', version = '1.3.8').",
            "Restart R. Then try poppins_import() again."
        )
      )

    }

    # import the poppins fonts
    extrafont::font_import(paths = poppins_directories, pattern = "[Pp]oppins")

    # register the fonts
    extrafont::loadfonts()

    # test to confirm that poppins is imported and registered
    poppins_test()

  }

}
