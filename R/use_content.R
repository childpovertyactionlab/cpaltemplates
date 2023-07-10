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

    img_logo_teal <- magick::image_read(system.file("content/CPAL_Logo_Teal.png", package = "cpaltemplates"))
    img_logo_white <- magick::image_read(system.file("content/CPAL_Logo_White.png", package = "cpaltemplates"))
    img_favi <- magick::image_read(system.file("content/CPAL_favicon.ico", package = "cpaltemplates"))
    img_skywh <- magick::image_read(system.file("content/CPAL_Skyline_White.png", package = "cpaltemplates"))
    img_skyte <- magick::image_read(system.file("content/CPAL_Skyline_Teal.png", package = "cpaltemplates"))

    magick::image_write(img_logo_teal, "www/images/CPAL_Logo_Teal.png")
    magick::image_write(img_logo_white, "www/images/CPAL_Logo_White.png")
    magick::image_write(img_favi, "www/images/CPAL_favicon.ico")
    magick::image_write(img_skywh, "www/images/CPAL_Skyline_White.png")
    magick::image_write(img_skyte, "www/images/CPAL_Skyline_Teal.png")

  } else {

    stop("Invalid 'preamble' argument. Valid stylesheets are: ",
         "fact_sheet",
         call. = FALSE)

  }
}
