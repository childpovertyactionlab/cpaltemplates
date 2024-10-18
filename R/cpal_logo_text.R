#' Child Poverty Action Lab [ggplot2] Logo Theme
#'
#' Creates a grid object with the Child Poverty Action Lab logo text, which can be used in [ggplot2] plots as a custom annotation.
#'
#' This function generates a `grobTree` containing the CPAL logo text. It is useful for adding consistent branding to visualizations.
#'
#' @return A grid graphical object (`grob`) with the CPAL logo text.
#'
#' @import grid
#' @import gridExtra
#' @md
#' @export
cpal_logo_text <- function() {
  grid::grobTree(
    gp = gpar(fontsize = 8,
              hjust = 1,
              vjust = 1),
    textGrob(label = "CHILD POVERTY ACTION LAB",
             x = unit(1, "npc"),
             y = unit(1, "npc"),
             hjust = 1.1,
             vjust = 1,
             gp = gpar(col = "#008097", fontface = "bold", fontfamily = "Poppins"))
  )
}
