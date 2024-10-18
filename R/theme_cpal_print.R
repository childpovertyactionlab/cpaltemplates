#' Child Poverty Action Lab [ggplot2] Theme for Print
#'
#' \code{theme_cpal_print} provides a [ggplot2] theme formatted according to the CPAL style guide for print, with sensible defaults.
#'
#' @param base_size Base font size (default is 8.5).
#' @param base_family Base font family (default is "Poppins").
#' @param base_line_size Base size for lines (default is 0.5).
#' @param base_rect_size Base size for rectangle elements (default is 0.5).
#' @param line_color Default line color (default is "#222222").
#' @param rect_fill Background color for rectangles (default is "#E7ECEE").
#' @param grid_color Grid line color (default is "#E7ECEE").
#' @import extrafont
#' @import ggrepel
#' @md
#' @export

theme_cpal_print <- function(base_size = 8.5,
                             base_family = "Poppins",
                             base_line_size = 0.5,
                             base_rect_size = 0.5,
                             line_color = "#222222",
                             rect_fill = "#E7ECEE",
                             grid_color = "#E7ECEE") {

  half_line <- base_size / 2L

  ggplot2::theme(
    line = ggplot2::element_line(colour = line_color, size = base_line_size),
    rect = ggplot2::element_rect(fill = rect_fill, colour = line_color, size = base_rect_size),
    text = ggplot2::element_text(family = base_family, colour = line_color, size = base_size, lineheight = 0.9),

    # Plot attributes
    plot.title = ggplot2::element_text(size = base_size * 12 / 8.5, family = base_family, face = "bold"),
    plot.subtitle = ggplot2::element_text(size = base_size * 9.5 / 8.5, family = base_family),
    plot.caption = ggplot2::element_text(size = base_size * 7 / 8.5, family = base_family),
    plot.tag = ggplot2::element_text(size = base_size * 1.5, family = base_family, face = "bold"),
    plot.tag.position = "topleft",
    plot.title.position = "plot",
    plot.caption.position = "plot",

    # Axis attributes
    axis.text = ggplot2::element_text(family = base_family, size = base_size),
    axis.title = ggplot2::element_text(family = base_family, face = "italic", size = base_size),
    axis.ticks = ggplot2::element_line(),
    axis.line = ggplot2::element_line(colour = line_color),

    # Legend attributes
    legend.position = "bottom",
    legend.background = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = base_size * 9.5 / 8.5, family = base_family),

    # Panel attributes
    panel.background = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_line(colour = grid_color),
    panel.grid.minor = ggplot2::element_blank(),

    # Facet strip attributes
    strip.background = ggplot2::element_rect(fill = grid_color),
    strip.text = ggplot2::element_text(family = base_family, face = "bold", size = base_size * 9.5 / 8.5)
  )
}
