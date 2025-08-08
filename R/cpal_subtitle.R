#' Add a Subtitle to a Plot
#'
#' Adds a formatted subtitle to a plot created with \code{cpal_plot()}.
#'
#' @param string A character string representing the subtitle text.
#' @param size Numeric value specifying the font size for the subtitle (default is 9.5).
#'
#' @return A grid graphical object (`grob`) formatted for a subtitle in a ggplot.
#'
#' @examples
#' \dontrun{
#' subtitle <- cpal_subtitle("This is a subtitle")
#' p <- ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' p + annotation_custom(subtitle)
#' }
#'
#' @export
cpal_subtitle <- function(string, size = 9.5) {
  grid::textGrob(
    string,
    x = unit(0, "npc"),
    y = unit(1, "npc"),
    hjust = -0.05,  # Horizontal justification to left-align
    vjust = 1,      # Vertical justification to position at the top
    gp = gpar(
      fontsize = size,
      fontfamily = "Poppins"
    )
  )
}
