#' cpal_plot
#'
#' Combine elements from \code{cpal_title}, \code{cpal_subtitle},
#' \code{cpal_y_title}, \code{get_legend}, \code{remove_legend},
#' \code{cpal_notes}, \code{cpal_source}, and \code{ggplot2} into
#' one formatted plot.
#'
#' @param ... cpal plot objects or grobs
#' @param heights relative heights of each object in the final plot
#'
#' @return one plot made from many grobs
#'
#' @export
#'
cpal_plot <- function(..., heights = 1) {
  grid.arrange(...,
               heights = heights)
}
