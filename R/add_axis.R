#' Add Custom Axes to a [ggplot2] Plot
#'
#' Adds or removes axis lines for a specified axis in a [ggplot2] plot.
#'
#' @param axis A character string indicating which axis lines to add. Options are:
#'   \itemize{
#'     \item `"x"`: Adds an axis line for the x-axis and removes it for the y-axis.
#'     \item `"y"`: Adds an axis line for the y-axis and removes it for the x-axis (default).
#'     \item `"both"`: Adds axis lines for both x and y axes.
#'   }
#'
#' @return A [ggplot2] theme object modifying the axis lines.
#' @examples
#' ggplot(data = mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   add_axis("x")
#'
#' @export
add_axis <- function(axis = "y") {

  axis_line <- ggplot2::element_line()  # default element_line

  if (axis == "x") {
    ggplot2::theme(
      axis.line.x = axis_line,
      axis.line.y = ggplot2::element_blank()
    )
  } else if (axis == "y") {
    ggplot2::theme(
      axis.line.x = ggplot2::element_blank(),
      axis.line.y = axis_line
    )
  } else if (axis == "both") {
    ggplot2::theme(
      axis.line.x = axis_line,
      axis.line.y = axis_line
    )
  } else {
    stop('Invalid "axis" argument: "', axis, '". Valid arguments are: "x", "y", and "both".',
         call. = FALSE)
  }
}
