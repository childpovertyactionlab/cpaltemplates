#' Child Poverty Action Lab [ggplot2] theme
#'
#' Creates a grid object with a Child Poverty Action Lab logo
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


