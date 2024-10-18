#' Child Poverty Action Lab [ggplot2] Theme for Maps
#'
#' \code{theme_cpal_map} provides a [ggplot2] theme formatted according to the Child Poverty Action Lab style guide for maps, with sensible defaults for map visualizations.
#'
#' @param scale A string specifying the type of legend. "continuous" creates a vertical legend on the right of the map, while "discrete" creates a horizontal legend above the map.
#' @param base_size Base font size for the theme (default is 8.5).
#' @param base_family Base font family for the theme (default is "Poppins").
#' @param base_line_size Base line size for the theme (default is 0.5).
#' @param base_rect_size Base rectangle size for the theme (default is 0.5).
#'
#' @import extrafont
#' @import ggrepel
#' @md
#' @export
theme_cpal_map <- function(scale = "continuous",
                           base_size = 8.5,
                           base_family = "Poppins",
                           base_line_size = 0.5,
                           base_rect_size = 0.5) {

  # Start with the CPAL print theme as a base
  gg <- theme_cpal_print(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  )

  # Customize for map style visuals
  gg <- gg + ggplot2::theme(
    plot.background = ggplot2::element_rect(fill = "#FFFFFF"),
    panel.background = ggplot2::element_rect(fill = "#FFFFFF"),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    legend.margin = ggplot2::margin(t = 6L, r = 6L, b = 6L, l = 6L, unit = "pt")
  )

  # Adjust legend based on scale type
  if (scale == "continuous") {
    gg <- gg + ggplot2::theme(
      legend.position = "right",
      legend.direction = "vertical",
      legend.title = ggplot2::element_text(size = base_size)
    )
  } else if (scale == "discrete") {
    gg <- gg + ggplot2::theme(
      legend.position = "top",
      legend.direction = "horizontal",
      legend.title = ggplot2::element_text(size = base_size)
    )
  } else {
    stop('Invalid "scale" argument. Valid options are "continuous" or "discrete".')
  }

  return(gg)
}
