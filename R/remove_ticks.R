#' Remove Tick Marks from Axes in CPAL [ggplot2] Theme
#'
#' Removes tick marks from the specified axis or both axes in a [ggplot2] plot.
#'
#' @param axis A character string specifying which axis to remove ticks from: `"x"`, `"y"`, or `"both"` (default is `"both"`).
#'
#' @return A [ggplot2] theme object that removes the tick marks from the specified axis.
#'
#' @examples
#' \dontrun{
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point() +
#'   remove_ticks("x")
#' }
#'
#' @md
#' @export
remove_ticks <- function(axis = "both") {

  if (axis == "x") {
    ggplot2::theme(axis.ticks.x = ggplot2::element_blank())
  } else if (axis == "y") {
    ggplot2::theme(axis.ticks.y = ggplot2::element_blank())
  } else if (axis == "both") {
    ggplot2::theme(axis.ticks = ggplot2::element_blank())
  } else {
    stop('Invalid "axis" argument. Valid options are "x", "y", or "both".', call. = FALSE)
  }
}
