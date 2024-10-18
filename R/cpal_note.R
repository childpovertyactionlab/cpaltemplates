#' Add Notes Section to a Plot
#'
#' Adds a formatted notes section to the bottom of a plot created with \code{cpal_plot()}.
#'
#' @param text A character string for the note to be displayed.
#' @param size Numeric value indicating the font size of the note (default is 8).
#' @param width Numeric value for the number of characters to allow before wrapping the text (default is 132).
#' @param plural Logical value; if `TRUE`, changes "Note:" to "Notes:" (default is `FALSE`).
#'
#' @return A grid graphical object (`grob`) formatted for a source note in a ggplot.
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- cpal_plot(mtcars, aes(x = wt, y = mpg)) + geom_point()
#' p + annotation_custom(cpal_note("This is a note", plural = TRUE))
#' }
#'
#' @export
cpal_note <- function(text, size = 8, width = 132, plural = FALSE) {

  # Determine whether to use singular or plural for the note title
  section_title <- if (plural) "     Notes: " else "     Note: "

  # Wrap the text and separate into lines
  wrapped_lines <- stringr::str_wrap(text, width = width - 6)
  line1 <- paste0(stringr::str_split(wrapped_lines, "\n", n = 2)[[1]][1], "\n")
  multiline <- length(stringr::str_split(wrapped_lines, "\n", n = 2)[[1]]) > 1

  if (multiline) {
    lines <- stringr::str_replace_all(stringr::str_split(wrapped_lines, "\n", n = 2)[[1]][2], "\n", " ")
    lines <- stringr::str_wrap(lines, width = width)
  }

  # Create the first text grob (title)
  grob1 <- grid::textGrob(
    section_title,
    name = "note1",
    x = unit(0, "npc"),
    y = unit(1, "npc"),
    hjust = 0,
    vjust = 1,
    gp = gpar(fontsize = size, fontfamily = "Poppins", fontface = "bold", lineheight = 1)
  )

  # Create the second text grob (first line of the note)
  grob2 <- grid::textGrob(
    line1,
    x = unit(0, "npc") + grobWidth(grob1),
    y = unit(1, "npc"),
    hjust = 0,
    vjust = 1,
    gp = gpar(fontsize = size, fontfamily = "Poppins", lineheight = 1)
  )

  # Create the third text grob (additional lines of the note if multiline)
  if (multiline) {
    grob3 <- grid::textGrob(
      lines,
      x = unit(0, "npc"),
      y = unit(1, "npc") - 1.5 * grobHeight(grob1),
      hjust = 0,
      vjust = 1,
      gp = gpar(fontsize = size, fontfamily = "Poppins", lineheight = 1)
    )

    return(grid::grobTree(grob1, grob2, grob3))
  }

  # Return the grobs for single-line notes
  grid::grobTree(grob1, grob2)
}
