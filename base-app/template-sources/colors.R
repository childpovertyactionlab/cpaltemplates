library(thematic)
library(brand.yml)

# Load the brand configuration object globally from the _brand.yml file.
brand <- read_brand_yml("_brand.yml")

#' Get CPAL Primary Brand Color
#'
#' Retrieves the hex code for the primary brand color (Teal) as defined
#' in the `_brand.yml` palette.
#'
#' @return A character string containing the hex color code (e.g., "#007A8C").
#' @export
cpal_get_primary_color <- function(){
  hex_code <- brand_color_pluck(brand, "teal")
  return(hex_code)
}

#' Get CPAL Color by Palette Name
#'
#' Generic helper to retrieve a specific hex code from the brand palette
#' by providing its name (e.g., "pink", "orange", "indigo").
#'
#' @param palette_color_name Character string matching a key in the
#'   `color: palette:` section of _brand.yml.
#'
#' @return A character string hex code.
#' @errors Throws an error if the color name does not exist in the palette.
#' @export
#'
#' @examples
#' cpal_get_color("orange") # Returns "#FF7F50"
cpal_get_color <- function(palette_color_name) {

  hex_code <- brand_color_pluck(brand, palette_color_name)

  if (is.null(hex_code)) {
    stop(paste0("Color '", palette_color_name, "' not found in palette."))
  }

  return(hex_code)
}
