#' Reset ggplot2 Theme to Defaults
#'
#' \code{undo_cpal_defaults} resets the ggplot2 theme to its default settings and returns the aesthetics to standard colors and font family.
#'
#' @param font_family Font family to use when resetting (default is "Helvetica").
#' @param fill_color Default fill color for geoms (default is "#595959").
#' @param line_color Default line color (default is "#595959").
#'
#' @import extrafont
#' @import ggrepel
#' @md
#' @export
undo_cpal_defaults <- function(font_family = "Helvetica", fill_color = "#595959", line_color = "#595959") {

  # Reset to the default ggplot2 theme
  ggplot2::theme_set(ggplot2::theme_grey())

  # Update text and label defaults with specified font
  ggplot2::update_geom_defaults("text", list(family = font_family))
  ggplot2::update_geom_defaults("label", list(family = font_family))
  ggplot2::update_geom_defaults("text_repel", list(family = font_family))
  ggplot2::update_geom_defaults("label_repel", list(family = font_family))

  # Set default fill and line colors for geoms
  ggplot2::update_geom_defaults("bar", list(fill = fill_color))
  ggplot2::update_geom_defaults("col", list(fill = fill_color))
  ggplot2::update_geom_defaults("point", list(colour = "black"))
  ggplot2::update_geom_defaults("line", list(colour = line_color))
  ggplot2::update_geom_defaults("boxplot", list(fill = fill_color))
  ggplot2::update_geom_defaults("density", list(fill = fill_color))
  ggplot2::update_geom_defaults("violin", list(fill = fill_color))

  # Set default colors for stats
  ggplot2::update_stat_defaults("count", list(fill = fill_color))
  ggplot2::update_stat_defaults("boxplot", list(fill = fill_color))
  ggplot2::update_stat_defaults("density", list(fill = fill_color))
  ggplot2::update_stat_defaults("ydensity", list(fill = fill_color))
}
