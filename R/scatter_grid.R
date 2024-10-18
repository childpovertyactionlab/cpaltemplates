#' Add Vertical Grid Lines for Scatter Plots
#'
#' Adds vertical grid lines to a scatter plot, complementing the default horizontal grid lines in CPAL themes.
#' This function is useful for scatter plots to improve the clarity of the x-axis.
#'
#' @param colour A character string specifying the color of the vertical grid lines (default is `"#ccd4d5"`).
#' @param linetype A character string specifying the line type (default is `"solid"`).
#' @param size A numeric value specifying the line size (default is `0.5`).
#'
#' @return A ggplot2 theme object with vertical grid lines added.
#' @export
scatter_grid <- function(colour = "#ccd4d5", linetype = "solid", size = 0.5) {
  ggplot2::theme(
    panel.grid.major.x = ggplot2::element_line(colour = colour, linetype = linetype, size = size)
  )
}
