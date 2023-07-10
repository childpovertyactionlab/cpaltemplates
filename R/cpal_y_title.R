#' cpal_y_title
#'
#' Add a horizontal y axis title to a plot created with \code{cpal_plot()}.
#'
#' @param string character string for a y-axis title
#' @param size font size for the y-axis title
#'
#' @return a grob formatted for a y-axis title in a ggplot
#'
#' @export
#'
cpal_y_title <- function(string, size = 8.5) {
  grid::textGrob(string,
                 x = unit(0, "npc"),
                 y = unit(1, "npc"),
                 hjust = 0,
                 vjust = 1,
                 gp = gpar(fontsize = size,
                           fontfamily = "Poppins",
                           fontface = "italic"))
}
