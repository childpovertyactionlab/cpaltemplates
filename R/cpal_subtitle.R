#' cpal_subtitle
#'
#' Add a subtitle to a plot created with \code{cpal_plot()}.
#'
#' @param string character string for a subtitle
#' @param size font size for the subtitle
#'
#' @return a grob formatted for a subtitle in a ggplot
#'
#' @export
#'
cpal_subtitle <- function(string, size = 9.5) {
  grid::textGrob(string,
           x = unit(0, "npc"),
           y = unit(1, "npc"),
           hjust = 1,
           vjust = 1,
           gp = gpar(fontsize = size,
                     fontfamily = "Poppins"))
}
