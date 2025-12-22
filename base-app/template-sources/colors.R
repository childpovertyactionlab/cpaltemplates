library(thematic)
library(brand.yml)

brand <- read_brand_yml("_brand.yml")

cpal_get_primary_color <- function(){  
  hex_code <- brand_color_pluck(brand, "teal")
  return(hex_code)
}

cpal_get_color <- function(palette_color_name) {

  hex_code <- brand_color_pluck(brand, palette_color_name)
  
  if (is.null(hex_code)) {
    stop(paste0("Color '", palette_color_name, "' not found in palette."))
  }
  
  return(hex_code)
}