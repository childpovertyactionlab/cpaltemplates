#' Save ggplot2 plots in standard Child Poverty Action Lab sizes
#'
#' This is a function to save standardized images for CPAL
#' publications. For more functionality like custom widths and heights, use
#' ggsave() directly.
#'
#' @param filename File name to create on disk.
#' @param plot Plot to save, defaults to last plot displayed.
#' @param size Size of plot. Must be one of "small" (3.25 x 2 inches),
#' "medium" (6.5 x 4 inches), or "large" (9 x 6.5 inches).
#' @param dpi Plot resolution. Also accepts a string input: "retina" (320),
#' "print" (300), or "screen" (72). Applies only to raster output types.
#'@param height Height of plot after save. Default is NULL.
#' @examples
#'
#' \dontrun{
#' library(tidyverse)
#' library(cpalthemes)
#'
#' set_cpal_defaults(style = "print")
#'
#' cars %>%
#'   ggplot(aes(speed, dist)) +
#'   geom_point()
#'
#' cpal_save("test.png")
#' }
#'
#' @export
cpal_save <- function(filename,
                      plot = ggplot2::last_plot(),
                      size = "medium",
                      dpi = 300,
                      height = NULL) {

  stopifnot(is.character(filename))

  if (!size %in% c("small", "medium", "large")) {

    stop("Error: size must be one of 'small', 'medium', or 'large'")

  }

  if (is.null(height)){
    sizes <- list(
      small = c(width = 3.12, height = 2),
      medium = c(width = 6.25, height = 4),
      large = c(width = 8.75, height = 6.5)
    )
  } else {
    sizes <- list(
      small = c(width = 3.12, height = height),
      medium = c(width = 6.25, height = height),
      large = c(width = 8.75, height = height)
    )
  }

  selected_size <- sizes[[size]]

  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = selected_size["width"],
    height = selected_size["height"]
  )

}


