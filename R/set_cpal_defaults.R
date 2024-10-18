#' Set CPAL Defaults for ggplot2 Theme
#'
#' \code{set_cpal_defaults} sets a [ggplot2] theme formatted according to the Child Poverty Action Lab style guide, with sensible defaults for print and map styles.
#'
#' @param style The default theme style for the R session: "print" or "map".
#' @param base_size The base font size for the theme (default is 8.5).
#' @param base_family The base font family for the theme (default is "Poppins").
#' @param base_line_size The base line size for the theme (default is 0.5).
#' @param base_rect_size The base rect size for the theme (default is 0.5).
#' @param scale For \code{theme_cpal_map()}: Should the legend theme be continuous or discrete? (default is "continuous").
#' @param fill_color Default fill color for geoms (default is "#008097").
#' @param text_color Default text color for plot labels (default is "#042D33").
#'
#' @import extrafont
#' @import ggrepel
#'
#' @export
set_cpal_defaults <- function(style = "print",
                              base_size = 8.5,
                              base_family = "Poppins",
                              base_line_size = 0.5,
                              base_rect_size = 0.5,
                              scale = "continuous",
                              fill_color = "#008097",
                              text_color = "#042D33") {

  # Set default theme to theme_cpal_*() based on style
  if (style == "print") {
    ggplot2::theme_set(
      theme_cpal_print(base_size = base_size, base_family = base_family, base_line_size = base_line_size, base_rect_size = base_rect_size)
    )
  } else if (style == "map") {
    ggplot2::theme_set(
      theme_cpal_map(base_size = base_size, base_family = base_family, base_line_size = base_line_size, base_rect_size = base_rect_size, scale = scale)
    )
  } else {
    stop('Invalid "style" argument. Valid styles are "print" and "map".', call. = FALSE)
  }

  # Add base_family font to text and label geoms
  ggplot2::update_geom_defaults("text", list(family = base_family, size = 1 / 0.352777778, colour = text_color))
  ggplot2::update_geom_defaults("label", list(family = base_family, size = 1 / 0.352777778, colour = text_color))
  ggplot2::update_geom_defaults("text_repel", list(family = base_family, size = 1 / 0.352777778, colour = text_color))
  ggplot2::update_geom_defaults("label_repel", list(family = base_family, size = 1 / 0.352777778, colour = text_color))

  # Set default color scales for continuous variables
  options(ggplot2.continuous.colour = "gradient", ggplot2.continuous.fill = "gradient")

  # Set defaults for geoms with customizable fill color
  ggplot2::update_geom_defaults("bar", list(fill = fill_color))
  ggplot2::update_geom_defaults("col", list(fill = fill_color))
  ggplot2::update_geom_defaults("point", list(colour = fill_color, size = 3))
  ggplot2::update_geom_defaults("line", list(colour = fill_color, size = 1))
  ggplot2::update_geom_defaults("step", list(colour = fill_color, size = 1))
  ggplot2::update_geom_defaults("path", list(colour = fill_color, size = 1))
  ggplot2::update_geom_defaults("boxplot", list(fill = fill_color))
  ggplot2::update_geom_defaults("density", list(fill = fill_color))
  ggplot2::update_geom_defaults("violin", list(fill = fill_color))
  ggplot2::update_geom_defaults("sf", list(fill = fill_color, color = "#E7ECEE", size = 0.1))

  # Set defaults for stats with customizable fill color
  ggplot2::update_stat_defaults("count", list(fill = fill_color))
  ggplot2::update_stat_defaults("boxplot", list(fill = fill_color))
  ggplot2::update_stat_defaults("density", list(fill = fill_color))
  ggplot2::update_stat_defaults("ydensity", list(fill = fill_color))
}

