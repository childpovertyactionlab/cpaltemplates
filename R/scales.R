#' Child Poverty Action Lab Color Palette
#'
#' Returns a function that retrieves color palettes for CPAL plots, either categorical or sequential.
#'
#' @param palette A string specifying the palette type: "categorical" or "sequential".
#' @export
cpal_color_pal <- function(palette = "categorical") {
  palette_list <- palette_cpal

  # Ensure the palette exists
  if (!palette %in% names(palette_list)) {
    stop("Invalid palette name. Choose 'categorical' or 'sequential'.")
  }

  function(n) {
    max_colors <- length(palette_list[[palette]])

    if (n > max_colors) {
      stop(paste("The maximum number of colors is", max_colors, ". Your code asked for", n, "colors."))
    }

    palette_list[[palette]][[n]]
  }
}

#' Discrete color scale for CPAL
#'
#' A color scale that aligns with CPAL's style, using up to 8 categories.
#' @export
scale_color_discrete <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    scale_name = "cpal",
    palette = cpal_color_pal("categorical"),
    ...
  )
}

#' Discrete fill scale for CPAL
#'
#' A fill scale that aligns with CPAL's style, using up to 8 categories.
#' @export
scale_fill_discrete <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = "cpal",
    palette = cpal_color_pal("categorical"),
    ...
  )
}

#' Continuous color gradient scale for CPAL
#'
#' A continuous gradient color scale that aligns with CPAL's style.
#' @param colours Vector of colors for the gradient (defaults to CPAL colors).
#' @param values Optional vector for non-uniform color distribution along the gradient.
#' @export
scale_color_gradientn <- function(...,
                                  colours = c("#E2F1F3", "#B4DDE4", "#87C8D4", "#5AB4C4", "#008BA3", "#00687A", "#00343D", "#001114"),
                                  values = NULL) {
  ggplot2::continuous_scale(
    aesthetics = "colour",
    scale_name = "gradientn",
    palette = scales::gradient_n_pal(colours, values),
    ...
  )
}

#' Continuous fill gradient scale for CPAL
#'
#' A continuous gradient fill scale that aligns with CPAL's style.
#' @param colours Vector of colors for the gradient (defaults to CPAL colors).
#' @param values Optional vector for non-uniform color distribution along the gradient.
#' @export
scale_fill_gradientn <- function(...,
                                 colours = c("#E2F1F3", "#B4DDE4", "#87C8D4", "#5AB4C4", "#008BA3", "#00687A", "#00343D", "#001114"),
                                 values = NULL) {
  ggplot2::continuous_scale(
    aesthetics = "fill",
    scale_name = "gradientn",
    palette = scales::gradient_n_pal(colours, values),
    ...
  )
}

#' Discrete color scale for ordinal factors with CPAL style
#'
#' A discrete color scale for ordinal data, using CPAL's sequential palette.
#' @export
scale_color_ordinal <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    scale_name = "cpal",
    palette = cpal_color_pal("sequential"),
    ...
  )
}

#' Discrete fill scale for ordinal factors with CPAL style
#'
#' A discrete fill scale for ordinal data, using CPAL's sequential palette.
#' @export
scale_fill_ordinal <- function(...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    scale_name = "cpal",
    palette = cpal_color_pal("sequential"),
    ...
  )
}
