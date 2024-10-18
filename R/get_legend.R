#' Extract the Legend from a ggplot2 Object
#'
#' This function extracts and returns just the legend from a `ggplot2` plot object.
#' It's useful when you want to isolate and display the legend separately from the plot.
#'
#' @param ggplot_object A ggplot object from which the legend will be extracted.
#'
#' @return A grob object representing the ggplot legend, or `NULL` if no legend is present.
#'
#' @examples
#' \dontrun{
#' p <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(gear))) + geom_point()
#' legend <- get_legend(p)
#' grid::grid.draw(legend)
#' }
#'
#' @export
get_legend <- function(ggplot_object) {

  # Return NULL if the input is NULL
  if (is.null(ggplot_object)) return(NULL)

  # Adjust legend margin and extract the legend
  temp <- ggplot_object +
    ggplot2::theme(legend.margin = ggplot2::margin(t = 0, r = 0, b = 0, l = 0, unit = "pt"))

  # Build the ggplot and extract the legend grob
  gtable <- ggplot2::ggplot_gtable(ggplot2::ggplot_build(temp))
  legend_index <- which(purrr::map_chr(gtable$grobs, "name") == "guide-box")

  # Return the legend grob, if found
  if (length(legend_index) > 0) {
    return(gtable$grobs[[legend_index]])
  } else {
    return(NULL)
  }
}
