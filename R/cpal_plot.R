#' Create a Formatted CPAL Plot
#'
#' Combines multiple CPAL plot elements or graphical objects (grobs) into one formatted plot.
#' This function makes it easy to compose various plot components such as titles, subtitles, axes labels, legends, notes, and sources into a cohesive plot.
#'
#' @param ... CPAL plot objects or grid graphical objects (grobs) to be combined.
#' @param heights A numeric vector specifying the relative heights of each object in the final plot. Default is 1 for equal heights.
#'
#' @return A combined plot made from multiple grobs.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' title <- cpal_title("Title")
#' subtitle <- cpal_subtitle("Subtitle")
#' cpal_plot(title, subtitle, p)
#' }
#'
#' @export
cpal_plot <- function(..., heights = 1) {
  gridExtra::grid.arrange(..., heights = heights)
}
