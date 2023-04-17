#' use_content
#'
#' Adds content to the specified directory.
#'
#' @param content A character string for the name of the content. The
#'   only options are "header image" and "urban logo".
#'
#' @md
#' @export
use_content <- function(content) {

  if (content == "web images") {

    if (!dir.exists("www")) {
      dir.create("www")
    }

    if (!dir.exists("www/images")) {
      dir.create("www/images")
    }

    img_logo <- magick::image_read(system.file("content/CPAL_Logo_White.png", package = "cpaltemplates"))
    img_sky <- magick::image_read(system.file("content/CPAL_Skyline_Name_White.png", package = "cpaltemplates"))

    magick::image_write(img_logo, "www/images/CPAL_Logo_White.png")
    magick::image_write(img_sky, "www/images/CPAL_Skyline_Name_White.png")

  } else {

    stop("Invalid 'preamble' argument. Valid stylesheets are: ",
         "fact_sheet",
         call. = FALSE)

  }
}
