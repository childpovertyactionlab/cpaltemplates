#' Add a Horizontal Y-Axis Title to a Plot
#'
#' Adds a horizontal y-axis title to a plot created with \code{cpal_plot()}.
#'
#' @param string A character string representing the y-axis title.
#' @param size Numeric value specifying the font size for the y-axis title (default is 8.5).
#'
#' @return A grid graphical object (`grob`) formatted as a horizontal y-axis title for a ggplot.
#'
#' @examples
#' \dontrun{
#' y_title <- cpal_y_title("Y-Axis Label")
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' p + annotation_custom(y_title)
#' }
#'
#' @export
cpal_y_title <- function(string, size = 8.5) {
  grid::textGrob(
    string,
    x = unit(0, "npc"),
    y = unit(1, "npc"),
    hjust = 0,  # Left-align for horizontal orientation
    vjust = 1,  # Top-align the text
    gp = gpar(
      fontsize = size,
      fontfamily = "Poppins",
      fontface = "italic"
    )
  )
}
