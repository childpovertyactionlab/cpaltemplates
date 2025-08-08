#' Add a Title to a Plot
#'
#' Adds a formatted title to a plot created with \code{cpal_plot()}.
#'
#' @param string A character string representing the title text.
#' @param size Numeric value specifying the font size for the title (default is 12).
#' @param width Numeric value indicating the maximum number of characters per line before wrapping the text (default is 68). If `FALSE`, no wrapping occurs.
#'
#' @return A grid graphical object (`grob`) formatted as a title for a ggplot.
#'
#' @examples
#' \dontrun{
#' title <- cpal_title("This is a title")
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' p + annotation_custom(title)
#' }
#'
#' @export
cpal_title <- function(string, size = 12, width = 68) {

  # Determine whether to wrap the text or not
  text_to_display <- if (width == FALSE) string else stringr::str_wrap(string, width = width)

  # Create the title grob
  grid::textGrob(
    text_to_display,
    x = unit(0, "npc"),
    y = unit(1, "npc"),
    hjust = -0.05,  # Left-align
    vjust = 1,      # Position at the top
    gp = gpar(
      fontsize = size,
      fontfamily = "Poppins",
      lineheight = 1,
      fontface = "bold"
    )
  )
}
