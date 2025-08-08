#' Save ggplot2 Plots in Standard Child Poverty Action Lab Sizes
#'
#' This function saves ggplot2 plots with standardized dimensions for CPAL publications.
#' For custom sizes or more control over width and height, consider using `ggsave()` directly.
#'
#' @param filename Character string. The file name to create on disk.
#' @param plot A ggplot2 plot to save. Defaults to the last plot displayed.
#' @param size Character string. Size of the plot, must be one of `"small"` (3.25 x 2 inches),
#' `"medium"` (6.5 x 4 inches), or `"large"` (9 x 6.5 inches).
#' @param dpi Numeric or character. Plot resolution. Can be a number or `"retina"` (320), `"print"` (300), or `"screen"` (72).
#' Applies only to raster output types.
#' @param height Numeric. Custom height for the plot. Default is `NULL`, and the standard size height is used.
#'
#' @return Saves the plot to the specified file.
#'
#' @examples
#' \dontrun{
#' library(tidyverse)
#' cpal_save("plot.png", size = "small")
#' }
#'
#' @export
cpal_save <- function(filename,
                      plot = ggplot2::last_plot(),
                      size = "medium",
                      dpi = 300,
                      height = NULL) {

  # Validate file name input
  stopifnot(is.character(filename), !is.na(filename))

  # Validate size input
  if (!size %in% c("small", "medium", "large")) {
    stop("Error: size must be one of 'small', 'medium', or 'large'.")
  }

  # Define default sizes if no custom height is provided
  sizes <- list(
    small = c(width = 3.25, height = ifelse(is.null(height), 2, height)),
    medium = c(width = 6.5, height = ifelse(is.null(height), 4, height)),
    large = c(width = 9, height = ifelse(is.null(height), 6.5, height))
  )

  selected_size <- sizes[[size]]

  # Map DPI options
  dpi_mapping <- list(retina = 320, print = 300, screen = 72)
  if (is.character(dpi)) {
    dpi <- dpi_mapping[[dpi]]
    if (is.null(dpi)) stop("Error: dpi must be 'retina', 'print', 'screen', or a numeric value.")
  }

  # Save the plot
  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = selected_size["width"],
    height = selected_size["height"],
    dpi = dpi
  )
}
