#' Remove the Legend from a ggplot2 Object
#'
#' This function removes the legend from a ggplot2 plot by disabling all guide aesthetics.
#'
#' @param ggplot_object A ggplot object from which the legend will be removed.
#'
#' @return A ggplot object without a legend.
#'
#' @examples
#' \dontrun{
#' p <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(gear))) + geom_point()
#' p_no_legend <- remove_legend(p)
#' }
#'
#' @export
remove_legend <- function(ggplot_object) {
  ggplot_object +
    ggplot2::guides(
      color = FALSE,
      fill = FALSE,
      alpha = FALSE,
      size = FALSE,
      shape = FALSE,
      linetype = FALSE
    )
}
