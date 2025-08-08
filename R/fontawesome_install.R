#' Import and Register FontAwesome
#'
#' \code{fontawesome_install()} checks whether FontAwesome is already imported and registered.
#' If it is not, the function imports and registers FontAwesome using the \href{https://github.com/wch/extrafont}{extrafont} package.
#'
#' Note: FontAwesome must be installed on your computer for \code{fontawesome_install()} to work properly.
#'
#' You can test if FontAwesome is installed using \code{extrafont::fonts()}.
#'
#' @return A message indicating whether FontAwesome was already imported or has been successfully imported and registered.
#'
#' @md
#' @export
fontawesome_install <- function() {
  if ("FontAwesome" %in% extrafont::fonts()) {
    message("FontAwesome is already imported and registered.")
  } else {
    message("Importing and registering FontAwesome...")
    extrafont::font_import(pattern = "FontAwesome")
    extrafont::loadfonts()
    message("FontAwesome successfully imported and registered.")
  }
}
