#' Setup CPAL Google Fonts for Plots
#'
#' Downloads and registers Inter and Roboto from Google Fonts for use in plots.
#'
#' @param force_refresh Logical. Force re-download of fonts (default: FALSE)
#' @param verbose Logical. Show detailed setup messages (default: TRUE)
#'
#' @return List with setup results including success status for each font.
#'
#' @export
setup_cpal_google_fonts <- function(force_refresh = FALSE, verbose = TRUE) {

  results <- list(
    inter = FALSE,
    roboto = FALSE,
    success = FALSE
  )

  if (verbose) cat("Setting up CPAL Google Fonts...\n")

  # Check required packages
  required_packages <- c("sysfonts", "showtext")
  missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

  if (length(missing_packages) > 0) {
    if (verbose) {
      cat("Missing required packages for Google Fonts:\n")
      for (pkg in missing_packages) {
        cat("   install.packages('", pkg, "')\n", sep = "")
      }
    }
    return(results)
  }

  # Setup fonts for plots (showtext/sysfonts)
  if (verbose) cat("Setting up fonts for plots...\n")

  tryCatch({
    # Add Inter from Google Fonts
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      if (!"Inter" %in% sysfonts::font_families() || force_refresh) {
        sysfonts::font_add_google("Inter", "Inter")
        if (verbose) cat("   Inter downloaded and registered\n")
      } else {
        if (verbose) cat("   Inter already available\n")
      }
      results$inter <- TRUE
    }

    # Add Roboto from Google Fonts
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      if (!"Roboto" %in% sysfonts::font_families() || force_refresh) {
        sysfonts::font_add_google("Roboto", "Roboto")
        if (verbose) cat("   Roboto downloaded and registered\n")
      } else {
        if (verbose) cat("   Roboto already available\n")
      }
      results$roboto <- TRUE
    }

    # Enable showtext
    if (requireNamespace("showtext", quietly = TRUE)) {
      showtext::showtext_auto()
      if (verbose) cat("   Showtext enabled for plots\n")
    }

  }, error = function(e) {
    if (verbose) cat("   Error setting up fonts:", e$message, "\n")
  })

  # Overall success check
  results$success <- results$inter || results$roboto

  if (verbose) {
    if (results$success) {
      cat("CPAL Google Fonts setup complete!\n")
      cat("   Primary: Inter | Secondary: Roboto\n")
    } else {
      cat("Font setup failed - plots will use fallback fonts\n")
    }
  }

  return(invisible(results))
}

#' Create interactive maps with mapgl
#'
#' Initialize a Mapbox GL map with CPAL-branded basemap styles.
#'
#' @param theme Basemap theme: "light" (default), "dark", "satellite", or "minimal"
#' @param bounds Optional bounding box for initial view. If NULL, the map will
#'   fit to data added via layers. Use `mapgl::fit_bounds()` to adjust after
#'   adding layers.
#' @param ... Additional arguments passed to `mapgl::mapboxgl()`
#'
#' @return A mapboxgl map object
#'
#' @details
#' Available themes:
#' \itemize{
#'   \item \code{"light"} - Default theme, good for general use and dashboards
#'   \item \code{"dark"} - Dark mode for dark-themed dashboards
#'   \item \code{"satellite"} - Satellite imagery for geographic/land use analysis
#'   \item \code{"minimal"} - Monochrome style for dense data overlays
#' }
#'
#' Requires a Mapbox access token. Set the environment variable
#' `MAPBOX_PUBLIC_TOKEN` in your `.Renviron` file:
#'
#' ```
#' usethis::edit_r_environ()
#' # Add: MAPBOX_PUBLIC_TOKEN="pk.your_token_here"
#' ```
#'
#' @examples
#' \dontrun{
#' library(mapgl)
#'
#' # Basic light theme map
#' cpal_mapgl()
#'
#' # Dark theme for dashboards
#' cpal_mapgl(theme = "dark")
#'
#' # Satellite for land use analysis
#' cpal_mapgl(theme = "satellite")
#'
#' # Minimal for dense data
#' cpal_mapgl(theme = "minimal")
#'
#' # With data layer
#' cpal_mapgl() |>
#'   add_fill_layer(
#'     id = "regions",
#'     source = my_sf_data,
#'     fill_color = "#008097",
#'     fill_opacity = 0.7
#'   )
#' }
#'
#' @export
cpal_mapgl <- function(theme = c("light", "dark", "satellite", "minimal"), bounds = NULL, ...) {
  if (!requireNamespace("mapgl", quietly = TRUE)) {
    stop("Package 'mapgl' is required. Install with: install.packages('mapgl')")
  }

  theme <- match.arg(theme)

  style <- switch(theme,
    light = "mapbox://styles/cpalanalytics/cmkipsrnw001101qmhs3r1m48",
    dark = "mapbox://styles/cpalanalytics/cmkippo3x000z01qm3tkzfvxz",
    satellite = "mapbox://styles/cpalanalytics/cmkipv02z00kg01rxajhs4pdb",
    minimal = "mapbox://styles/cpalanalytics/cmkipug0b003g01rzbyj624g5"
  )

  # Only pass bounds if explicitly provided (NULL interferes with fit_bounds)
  if (is.null(bounds)) {
    mapgl::mapboxgl(style = style, ...)
  } else {
    mapgl::mapboxgl(style = style, bounds = bounds, ...)
  }
}

#' Add CPAL popup styling to a map
#'
#' Injects custom CSS to style Mapbox GL popups with CPAL branding. This styles
#' the popup container (background, border, shadow, fonts) regardless of what
#' content is inside.
#'
#' @param map A mapboxgl map object
#' @param theme Popup theme: "light" (default) or "dark"
#'
#' @return The map object with CPAL popup styling applied
#'
#' @details
#' This function styles the popup container elements:
#' \itemize{
#'   \item Font family (Inter with system fallbacks)
#'   \item Background color and border radius
#'   \item Box shadow
#'   \item Popup tip/arrow color
#'   \item Close button styling
#' }
#'
#' Use in combination with \code{\link{cpal_popup_html}} for fully branded popups.
#'
#' @examples
#' \dontrun{
#' library(mapgl)
#'
#' cpal_mapgl() |>
#'   add_fill_layer(
#'     id = "counties",
#'     source = nc,
#'     fill_color = "#008097",
#'     popup = "NAME"
#'   ) |>
#'   add_cpal_popup_style()
#' }
#'
#' @export
add_cpal_popup_style <- function(map, theme = c("light", "dark")) {
  if (!requireNamespace("htmlwidgets", quietly = TRUE)) {
    stop("Package 'htmlwidgets' is required. Install with: install.packages('htmlwidgets')")
  }

  theme <- match.arg(theme)

  # Define colors based on theme
  if (theme == "light") {
    bg_color <- "#FFFFFF"
    text_color <- "#1E1E1E"
    border_color <- "#E0E0E0"
    tip_color <- "#FFFFFF"
    close_color <- "#666666"
    close_hover <- "#1E1E1E"
  } else {
    bg_color <- "#1E1E1E"
    text_color <- "#FFFFFF"
    border_color <- "#333333"
    tip_color <- "#1E1E1E"
    close_color <- "#999999"
    close_hover <- "#FFFFFF"
  }

  css <- sprintf('
    .mapboxgl-popup-content {
      font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 14px;
      line-height: 1.5;
      color: %s;
      background-color: %s;
      border-radius: 8px;
      padding: 12px 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      border: 1px solid %s;
      max-width: 300px;
    }
    .mapboxgl-popup-close-button {
      font-size: 18px;
      padding: 4px 8px;
      color: %s;
      right: 4px;
      top: 4px;
    }
    .mapboxgl-popup-close-button:hover {
      color: %s;
      background-color: transparent;
    }
    .mapboxgl-popup-tip {
      border-top-color: %s;
      border-bottom-color: %s;
    }
    .maplibregl-popup-content {
      font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 14px;
      line-height: 1.5;
      color: %s;
      background-color: %s;
      border-radius: 8px;
      padding: 12px 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      border: 1px solid %s;
      max-width: 300px;
    }
    .maplibregl-popup-close-button {
      font-size: 18px;
      padding: 4px 8px;
      color: %s;
      right: 4px;
      top: 4px;
    }
    .maplibregl-popup-close-button:hover {
      color: %s;
      background-color: transparent;
    }
    .maplibregl-popup-tip {
      border-top-color: %s;
      border-bottom-color: %s;
    }
  ', text_color, bg_color, border_color, close_color, close_hover, tip_color, tip_color,
     text_color, bg_color, border_color, close_color, close_hover, tip_color, tip_color)

  style_tag <- htmltools::tags$style(htmltools::HTML(css))

  htmlwidgets::prependContent(map, style_tag)
}

#' Create CPAL-styled popup HTML content
#'
#' Generate consistently styled HTML for map popup content. Use this to create
#' a popup column in your sf data, then reference it in the \code{popup}
#' parameter of layer functions.
#'
#' @param title The popup title (can be a column value or static text)
#' @param body The popup body content. Can include HTML like \code{<br>} for
#'   line breaks. Build with \code{paste0()} or \code{glue::glue()} for
#'   dynamic content.
#' @param subtitle Optional subtitle displayed below the title
#'
#' @return A character string containing styled HTML
#'
#' @details
#' This function generates the HTML content inside the popup. For best results,
#' also use \code{\link{add_cpal_popup_style}} to style the popup container.
#'
#' The function applies:
#' \itemize{
#'   \item CPAL teal color for the title
#'   \item Proper typography hierarchy
#'   \item Consistent spacing
#' }
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(mapgl)
#'
#' # Add popup column to your data
#' nc <- nc |>
#'   mutate(
#'     popup = cpal_popup_html(
#'       title = NAME,
#'       subtitle = "County",
#'       body = paste0(
#'         "Population: ", scales::comma(population), "<br>",
#'         "Poverty Rate: ", poverty_rate, "%"
#'       )
#'     )
#'   )
#'
#' # Use in map
#' cpal_mapgl() |>
#'   add_fill_layer(
#'     id = "counties",
#'     source = nc,
#'     fill_color = "#008097",
#'     popup = "popup"
#'   ) |>
#'   add_cpal_popup_style()
#' }
#'
#' @export
cpal_popup_html <- function(title, body = NULL, subtitle = NULL) {
  # CPAL colors

  teal <- "#006878"  # deep_teal for better contrast

  # Build HTML
  html <- paste0(
    '<div style="font-family: Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif;">',
    '<div style="font-size: 16px; font-weight: 600; color: ', teal, '; margin-bottom: 2px;">',
    title,
    '</div>'
  )

  if (!is.null(subtitle)) {
    html <- paste0(
      html,
      '<div style="font-size: 12px; color: #666666; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;">',
      subtitle,
      '</div>'
    )
  }

  if (!is.null(body)) {
    # Add margin-top only if there's no subtitle
    margin_top <- if (is.null(subtitle)) "8px" else "0"
    html <- paste0(
      html,
      '<div style="font-size: 14px; color: #1E1E1E; margin-top: ', margin_top, '; line-height: 1.5;">',
      body,
      '</div>'
    )
  }

  html <- paste0(html, '</div>')

  return(html)
}

#' CPAL Legend Style for mapgl
#'
#' Returns a style list for use with \code{mapgl::add_legend()}. Provides
#' consistent CPAL branding for map legends with light and dark theme options.
#'
#' @param theme Legend theme: "light" (default) or "dark"
#' @param position Legend position: "top-left", "top-right", "bottom-left",
#'   or "bottom-right" (default)
#' @param width Legend width in pixels or "auto". Default is 180.
#'
#' @return A named list of style options to pass to \code{add_legend(style = ...)}
#'
#' @details
#' The style list includes:
#' \itemize{
#'   \item Background color and opacity
#'   \item Border styling
#'   \item Typography (Inter font family)
#'   \item Shadow for visual depth
#'   \item Consistent sizing and spacing
#' }
#'
#' @examples
#' \dontrun{
#' library(mapgl)
#'
#' cpal_mapgl() |>
#'   add_fill_layer(
#'     id = "counties",
#'     source = nc,
#'     fill_color = color_scale$expression
#'   ) |>
#'   add_legend(
#'     "Poverty Rate (%)",
#'     values = c("0-10", "10-20", "20-30"),
#'     colors = c("#E8F4F6", "#28889E", "#004855"),
#'     style = cpal_legend_style()
#'   )
#'
#' # Dark theme legend
#' cpal_mapgl(theme = "dark") |>
#'   add_fill_layer(...) |>
#'   add_legend(
#'     "Value",
#'     values = values,
#'     colors = colors,
#'     style = cpal_legend_style(theme = "dark")
#'   )
#' }
#'
#' @export
cpal_legend_style <- function(theme = c("light", "dark"),
                               position = c("bottom-right", "bottom-left",
                                           "top-right", "top-left"),
                               width = 180) {


  theme <- match.arg(theme)
  position <- match.arg(position)


  # Define colors based on theme
  if (theme == "light") {
    bg_color <- "#FFFFFF"
    bg_opacity <- 0.95
    text_color <- "#1E1E1E"
    title_color <- "#004855"
    border_color <- "#E0E0E0"
    shadow_color <- "rgba(0, 0, 0, 0.12)"
  } else {
    bg_color <- "#1E1E1E"
    bg_opacity <- 0.95
    text_color <- "#F5F5F5"
    title_color <- "#88BECA"
    border_color <- "#333333"
    shadow_color <- "rgba(0, 0, 0, 0.3)"
  }

  list(
    # Background
    background_color = bg_color,
    background_opacity = bg_opacity,

    # Border
    border_width = 1,
    border_color = border_color,

    # Typography
    font_family = "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
    text_color = text_color,
    title_color = title_color,
    title_font_weight = "600",
    title_size = 13,
    text_size = 12,

    # Shadow for depth
    shadow = TRUE,
    shadow_color = shadow_color,
    shadow_size = 8,

    # Element styling (color swatches)
    element_border_color = border_color,
    element_border_width = 0,

    # Position (passed through but also used in add_legend directly)
    position = position,

    # Width
    width = if (is.numeric(width)) paste0(width, "px") else width
  )
}

#' Create CPAL-styled popup HTML with metrics
#'
#' Generate consistently styled HTML for map popup content with support for
#' highlighted metrics and footers. Use this to create a popup column in your
#' sf data, then reference it in the \code{popup} parameter of layer functions.
#'
#' @param title The popup title (can be a column value or static text)
#' @param subtitle Optional subtitle displayed below the title
#' @param metrics Optional named list or vector of key metrics to highlight.
#'   Displayed prominently between subtitle and body. Names become labels,
#'   values become the displayed metrics.
#' @param body The popup body content. Can include HTML like \code{<br>} for
#'   line breaks. Build with \code{paste0()} or \code{glue::glue()} for
#'   dynamic content.
#' @param footer Optional footer text displayed at bottom in smaller, muted text.
#'   Useful for data sources, timestamps, or disclaimers.
#' @param theme Color theme: "light" (default) or "dark"
#'
#' @return A character string containing styled HTML
#'
#' @details
#' This function generates the HTML content inside the popup. For best results,
#' also use \code{\link{add_cpal_popup_style}} to style the popup container.
#'
#' The function applies:
#' \itemize{
#'   \item CPAL brand colors for visual hierarchy
#'   \item Prominent metric display with large values
#'   \item Proper typography hierarchy
#'   \item Consistent spacing
#' }
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(mapgl)
#'
#' # Basic popup with metrics
#' nc <- nc |>
#'   mutate(
#'     popup = cpal_popup_html_metrics(
#'       title = NAME,
#'       subtitle = "County",
#'       metrics = c(
#'         "Population" = scales::comma(population),
#'         "Poverty Rate" = paste0(poverty_rate, "%")
#'       ),
#'       footer = "Source: US Census Bureau"
#'     )
#'   )
#'
#' # With body text
#' nc <- nc |>
#'   mutate(
#'     popup = cpal_popup_html_metrics(
#'       title = NAME,
#'       subtitle = "County Overview",
#'       metrics = c("Poverty Rate" = paste0(poverty_rate, "%")),
#'       body = paste0(
#'         "This county has a total area of ", round(AREA, 1), " sq mi ",
#'         "and is located in the ", region, " region."
#'       ),
#'       footer = "Data as of 2023"
#'     )
#'   )
#'
#' # Use in map
#' cpal_mapgl() |>
#'   add_fill_layer(
#'     id = "counties",
#'     source = nc,
#'     fill_color = "#008097",
#'     popup = "popup"
#'   ) |>
#'   add_cpal_popup_style()
#' }
#'
#' @export
cpal_popup_html_metrics <- function(title,
                                     subtitle = NULL,
                                     metrics = NULL,
                                     body = NULL,
                                     footer = NULL,
                                     theme = c("light", "dark")) {

  theme <- match.arg(theme)

  # Define colors based on theme
  if (theme == "light") {
    title_color <- "#006878"
    subtitle_color <- "#666666"
    text_color <- "#1E1E1E"
    metric_value_color <- "#004855"
    metric_label_color <- "#666666"
    footer_color <- "#888888"
    divider_color <- "#E8E8E8"
  } else {
    title_color <- "#88BECA"
    subtitle_color <- "#999999"
    text_color <- "#F5F5F5"
    metric_value_color <- "#88BECA"
    metric_label_color <- "#AAAAAA"
    footer_color <- "#777777"
    divider_color <- "#444444"
  }

  font_family <- "Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif"

  # Start building HTML

  html <- paste0(
    '<div style="font-family: ', font_family, ';">'
  )

  # Title
  html <- paste0(
    html,
    '<div style="font-size: 16px; font-weight: 600; color: ', title_color, '; margin-bottom: 2px;">',
    title,
    '</div>'
  )

  # Subtitle
  if (!is.null(subtitle)) {
    html <- paste0(
      html,
      '<div style="font-size: 11px; color: ', subtitle_color, '; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px;">',
      subtitle,
      '</div>'
    )
  }

  # Metrics section
  if (!is.null(metrics) && length(metrics) > 0) {
    # Add top margin if no subtitle
    margin_top <- if (is.null(subtitle)) "10px" else "0"

    html <- paste0(
      html,
      '<div style="margin-top: ', margin_top, '; margin-bottom: 10px;">'
    )

    # Handle both named vectors and lists
    metric_names <- names(metrics)
    metric_values <- unname(metrics)

    for (i in seq_along(metrics)) {
      label <- if (!is.null(metric_names) && metric_names[i] != "") metric_names[i] else ""
      value <- metric_values[i]

      # Each metric as a row
      html <- paste0(
        html,
        '<div style="display: flex; justify-content: space-between; align-items: baseline; padding: 4px 0; border-bottom: 1px solid ', divider_color, ';">',
        '<span style="font-size: 12px; color: ', metric_label_color, ';">', label, '</span>',
        '<span style="font-size: 15px; font-weight: 600; color: ', metric_value_color, ';">', value, '</span>',
        '</div>'
      )
    }

    html <- paste0(html, '</div>')
  }

  # Body text
  if (!is.null(body)) {
    margin_top <- if (is.null(metrics) && is.null(subtitle)) "8px" else "0"
    html <- paste0(
      html,
      '<div style="font-size: 13px; color: ', text_color, '; margin-top: ', margin_top, '; line-height: 1.5;">',
      body,
      '</div>'
    )
  }

  # Footer
  if (!is.null(footer)) {
    html <- paste0(
      html,
      '<div style="font-size: 10px; color: ', footer_color, '; margin-top: 10px; padding-top: 8px; border-top: 1px solid ', divider_color, ';">',
      footer,
      '</div>'
    )
  }

  html <- paste0(html, '</div>')

  return(html)
}
