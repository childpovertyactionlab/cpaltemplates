#' CPAL Styled geom_bar
#'
#' This function applies a custom width and other CPAL-specific defaults to `geom_bar()`.
#' For full documentation, see \code{?ggplot2::geom_bar}.
#'
#' @param mapping Aesthetic mapping from ggplot2.
#' @param width Numeric value for the bar width (default is 1.1).
#' @param ... Additional arguments passed to \code{geom_bar()}.
#' @return A ggplot2 `geom_bar()` layer with CPAL styling.
#' @export
geom_bar <- function(mapping = NULL, width = 1.1, ...) {
  ggplot2::geom_bar(mapping = mapping, width = width, ...)
}

#' CPAL Styled geom_col
#'
#' This function applies a custom width and other CPAL-specific defaults to `geom_col()`.
#' For full documentation, see \code{?ggplot2::geom_col}.
#'
#' @param mapping Aesthetic mapping from ggplot2.
#' @param width Numeric value for the column width (default is 1.1).
#' @param ... Additional arguments passed to \code{geom_col()}.
#' @return A ggplot2 `geom_col()` layer with CPAL styling.
#' @export
geom_col <- function(mapping = NULL, width = 1.1, ...) {
  ggplot2::geom_col(mapping = mapping, width = width, ...)
}
