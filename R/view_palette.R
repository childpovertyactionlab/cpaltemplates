#' Child Poverty Action Lab [ggplot2] theme
#'
#' \code{view_palette} displays the colors and hexadecimal codes for \code{palette_cpal_*} vectors.
#'
#' @param palette A \code{palette_cpal_*} vector from \code{library(cpalthemes)}.
#'   Options are `palette_cpal_diverging`, `palette_cpal_politics`,
#'   `palette_cpal_quintile`, `palette_cpal_teal`, `palette_cpal_gray`,
#'   `palette_cpal_yellow`, `palette_cpal_magenta`, `palette_cpal_green`,
#'   `palette_cpal_purple`, and `palette_cpal_red`.
#'
#' @examples
#' view_palette()
#' view_palette(palette_cpal_teal)
#'
#' @md
#'
#' @export
view_palette <- function(palette = palette_cpal_main) {

  color_palette <- unname(rev(palette))

  print(paste0("c(", paste(color_palette, collapse = ", "), ")"))

  data <- tibble::tibble(x = 1,
         y = 1:length(color_palette),
         colors = factor(color_palette, levels = color_palette))

  ggplot2::ggplot(data = data) +
    ggplot2::geom_point(ggplot2::aes_string("x", "y", color = "colors"), size = 15) +
    ggplot2::geom_text(ggplot2::aes_string(2, "y"), label = color_palette) +
    ggplot2::scale_color_manual(values = color_palette) +
    ggplot2::scale_x_continuous(limits = c(0, 3)) +
    theme_cpal_map() +
    ggplot2::guides(color = "none")

}
