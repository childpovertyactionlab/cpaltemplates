#' Remove Axes and Labels in CPAL [ggplot2] Theme
#'
#' Removes axis lines, ticks, and labels for the specified axis in a [ggplot2] plot.
#' Can be customized for use with `coord_flip()`.
#'
#' @param axis A character string specifying which axis to remove: `"x"`, `"y"`, or `"both"`.
#' @param flip Logical. If `TRUE`, indicates that `coord_flip()` is used and adjusts the axis accordingly.
#'
#' @return A [ggplot2] theme object that removes the specified axis components.
#' @examples
#' \dontrun{
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   remove_axis("x", flip = FALSE)
#' }
#'
#' @export
remove_axis <- function(axis = "y", flip = FALSE) {

  if (axis == "x" && !flip) {
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.line.x = ggplot2::element_blank()
    )
  } else if (axis == "x" && flip) {
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.line.x = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line.y = ggplot2::element_line()
    )
  } else if (axis == "y" && !flip) {
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.line.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank()
    )
  } else if (axis == "y" && flip) {
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.line.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank()
    )
  } else if (axis == "both") {
    ggplot2::theme(
      panel.grid.major.x = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.line.x = ggplot2::element_blank(),
      panel.grid.major.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.line.y = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank()
    )
  } else {
    stop('Invalid "axis" argument. Valid options are "x", "y", or "both".',
         call. = FALSE)
  }
}
