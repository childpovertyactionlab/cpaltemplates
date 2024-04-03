#' Import and register Inter font
#'
#' \code{inter_import()} tests to see if Inter is imported and registered. If
#' Inter, isn't imported and registered, then \code{inter_import()} imports and
#' registers Inter with
#' \href{https://github.com/wch/extrafont}{library(extrafont)}.
#'
#' Note: Inter must be installed on your computer for \code{inter_import()} to
#' work. Inter is the Child Poverty Action Lab's main font. To install, visit
#' \href{https://fonts.google.com/specimen/Poppins}{Google fonts} and click
#' "Download family". Unzip and open each of the .ttf files and click install.
#'
#' Test to see if Inter is imported and registered with \code{inter_test()}.
#'
#' @md
#' @export
poppins_import <- function() {

  if (sum(grepl("[Ii]inter$", extrafont::fonts())) > 0) {

    "Inter is already imported and registered."

  } else {

    # get a list of all fonts on the machine
    local_fonts <- systemfonts::system_fonts()

    # subset the list to just inter fonts
    inter_fonts <- local_fonts[grepl(pattern = "[Ii]inter", x = local_fonts$family), ]

    # create a vector of directories where inter fonts are located
    inter_directories <- unique(gsub("[Ii]inter.*\\.ttf", "", inter_fonts$path))

    # add a warning for unix users about Rttf2pt1 version
    if (.Platform$OS.type == "unix") {

      print(
        paste(
            "Unix (Mac) users may experience errors if the library(Rttf2pt1)",
            "version is >= 1.3.9. Restart R. Run",
            "remotes::install_version('Rttf2pt1', version = '1.3.8').",
            "Restart R. Then try inter_import() again."
        )
      )

    }

    # import the poppins fonts
    extrafont::font_import(paths = inter_directories, pattern = "[Ii]inter")

    # register the fonts
    extrafont::loadfonts()

    # test to confirm that poppins is imported and registered
    inter_test()

  }

}
