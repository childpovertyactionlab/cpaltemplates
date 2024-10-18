#' Display a CPAL Color Palette
#'
#' \code{view_palette} displays the colors and hexadecimal codes for a specified CPAL color palette.
#'
#' @param palette A color palette vector. Options include predefined palettes like `palette_cpal_diverging`, `palette_cpal_teal`, `palette_cpal_gray`, and more.
#'
#' @examples
#' view_palette(palette_cpal_teal)
#' view_palette(palette_cpal_magenta)
#'
#' @md
#' @export
utils::globalVariables(c("x", "y", "colors"))
view_palette <- function(palette = palette_cpal_main) {

  # Reverse palette for display and remove names if any
  color_palette <- unname(rev(palette))

  # Print hex codes for reference
  print(paste0("Palette colors: c(", paste(color_palette, collapse = ", "), ")"))

  # Create tibble for plotting
  data <- tibble::tibble(
    x = 1,
    y = 1:length(color_palette),
    colors = factor(color_palette, levels = color_palette)
  )

  # Plot the palette
  ggplot2::ggplot(data = data) +
    ggplot2::geom_point(ggplot2::aes(x = x, y = y, color = colors), size = 15) +
    ggplot2::geom_text(ggplot2::aes(x = 2, y = y, label = colors), hjust = 0, size = 4) +
    ggplot2::scale_color_manual(values = color_palette) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::coord_fixed(ratio = 0.5) +
    ggplot2::xlim(1, 3)
}
