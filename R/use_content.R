#' Add Content to Specified Directory
#'
#' \code{use_content} adds specific content, like images, to a designated directory.
#' This function supports "web images" for now, which includes adding CPAL logos and images.
#'
#' @param content A character string specifying the type of content to add. Currently, the only valid option is "web images".
#' @param overwrite Logical. If `TRUE`, existing files with the same name will be overwritten (default is `FALSE`).
#'
#' @md
#' @export
use_content <- function(content, overwrite = FALSE) {

  # Ensure valid content argument
  if (content != "web images") {
    stop("Invalid 'content' argument. The only supported option is: 'web images'.", call. = FALSE)
  }

  # Create directories if they do not exist
  if (!dir.exists("www")) {
    dir.create("www")
  }
  if (!dir.exists("www/images")) {
    dir.create("www/images")
  }

  # Define image paths
  img_paths <- list(
    teal_logo = "www/images/CPAL_Logo_Teal.png",
    white_logo = "www/images/CPAL_Logo_White.png",
    favicon = "www/images/CPAL_favicon.ico",
    skyline_white = "www/images/CPAL_Skyline_White.png",
    skyline_teal = "www/images/CPAL_Skyline_Teal.png"
  )

  # Read images from package files
  images <- list(
    teal_logo = magick::image_read(system.file("content/CPAL_Logo_Teal.png", package = "cpaltemplates")),
    white_logo = magick::image_read(system.file("content/CPAL_Logo_White.png", package = "cpaltemplates")),
    favicon = magick::image_read(system.file("content/CPAL_favicon.ico", package = "cpaltemplates")),
    skyline_white = magick::image_read(system.file("content/CPAL_Skyline_White.png", package = "cpaltemplates")),
    skyline_teal = magick::image_read(system.file("content/CPAL_Skyline_Teal.png", package = "cpaltemplates"))
  )

  # Write images to destination, handle overwriting if specified
  for (img_name in names(img_paths)) {
    if (!file.exists(img_paths[[img_name]]) || overwrite) {
      magick::image_write(images[[img_name]], img_paths[[img_name]])
    }
  }

  message("Images successfully added to 'www/images' directory.")
}
