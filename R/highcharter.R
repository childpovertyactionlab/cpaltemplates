# =============================================================================
# HIGHCHARTER THEME AND HELPER FUNCTIONS FOR CPAL
# =============================================================================

#' @importFrom graphics hist
NULL

# =============================================================================
# Core Theme Functions
# =============================================================================

#' CPAL Light Theme for Highcharter
#'
#' Returns a Highcharter theme configured with CPAL light mode colors,
#' matching the cpaltemplates theme_cpal() ggplot2 theme.
#'
#' @param base_size Base font size in pixels (default: 14)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param legend_position Legend position: "bottom", "right", "top", "left" (default: "bottom")
#' @param show_credits Show Highcharts credits watermark (default: FALSE)
#'
#' @return A Highcharter theme object
#' @export
#'
#' @examples
#' \dontrun{
#' library(highcharter)
#' hchart(mtcars, "scatter", hcaes(wt, mpg)) |>
#'   hc_add_theme(hc_theme_cpal_light())
#' }
hc_theme_cpal_light <- function(
    base_size = 14,
    grid = "horizontal",
    legend_position = "bottom",
    show_credits = FALSE
) {

  # Get colors from cpaltemplates
 palette_main <- cpal_colors("main")
  midnight <- palette_main[1]
  neutral <- "#E8ECEE"
  slate <- "#5C6B73"
  deep_teal <- "#006878"

  # Font settings
  font_family <- "Inter, Roboto, sans-serif"

  # Calculate derived sizes
  title_size <- paste0(round(base_size * 1.15), "px")
  subtitle_size <- paste0(round(base_size * 0.9), "px")
  caption_size <- paste0(round(base_size * 0.7), "px")
  axis_title_size <- paste0(round(base_size * 0.85), "px")
  axis_text_size <- paste0(round(base_size * 0.8), "px")
  legend_size <- paste0(round(base_size * 0.8), "px")

  # Grid line settings
  x_grid_width <- if (grid %in% c("vertical", "both")) 1 else 0
  y_grid_width <- if (grid %in% c("horizontal", "both")) 1 else 0

  # Legend positioning
  legend_align <- if (legend_position %in% c("left", "right")) legend_position else "center"
  legend_v_align <- if (legend_position %in% c("top", "bottom")) legend_position else "middle"
  legend_layout <- if (legend_position %in% c("top", "bottom")) "horizontal" else "vertical"

  # Build theme
  highcharter::hc_theme(
    colors = unname(palette_main),
    lang = list(
      thousandsSep = ",",
      decimalPoint = "."
    ),
    chart = list(
      backgroundColor = "#FFFFFF",
      style = list(
        fontFamily = font_family
      )
    ),
    title = list(
      align = "left",
      style = list(
        color = midnight,
        fontFamily = font_family,
        fontWeight = "bold",
        fontSize = title_size
      )
    ),
    subtitle = list(
      align = "left",
      style = list(
        color = "#666666",
        fontFamily = font_family,
        fontSize = subtitle_size
      )
    ),
    caption = list(
      align = "right",
      style = list(
        color = "#888888",
        fontFamily = font_family,
        fontSize = caption_size
      )
    ),
    xAxis = list(
      gridLineWidth = x_grid_width,
      gridLineColor = neutral,
      lineColor = slate,
      lineWidth = 1,
      tickColor = slate,
      allowDecimals = FALSE,
      labels = list(
        style = list(
          color = midnight,
          fontFamily = font_family,
          fontSize = axis_text_size
        )
      ),
      title = list(
        style = list(
          color = "#555555",
          fontFamily = font_family,
          fontSize = axis_title_size
        )
      )
    ),
    yAxis = list(
      gridLineWidth = y_grid_width,
      gridLineColor = neutral,
      lineColor = slate,
      lineWidth = 0,
      tickColor = slate,
      allowDecimals = FALSE,
      labels = list(
        style = list(
          color = "#444444",
          fontFamily = font_family,
          fontSize = axis_text_size
        )
      ),
      title = list(
        style = list(
          color = "#555555",
          fontFamily = font_family,
          fontSize = axis_title_size
        )
      )
    ),
    legend = list(
      align = legend_align,
      verticalAlign = legend_v_align,
      layout = legend_layout,
      itemStyle = list(
        color = "#222222",
        fontFamily = font_family,
        fontSize = legend_size,
        fontWeight = "normal"
      ),
      itemHoverStyle = list(
        color = deep_teal
      ),
      itemHiddenStyle = list(
        color = "#cccccc"
      )
    ),
    tooltip = list(
      backgroundColor = "#FFFFFF",
      borderColor = neutral,
      borderRadius = 6,
      shadow = TRUE,
      style = list(
        color = "#222222",
        fontFamily = font_family,
        fontSize = paste0(base_size, "px")
      )
    ),
    plotOptions = list(
      series = list(
        animation = list(
          duration = 1000,
          easing = "easeOutQuart"
        ),
        marker = list(
          lineWidth = 1,
          lineColor = "#FFFFFF"
        ),
        states = list(
          hover = list(
            enabled = TRUE,
            lineWidthPlus = 1
          ),
          inactive = list(
            opacity = 0.3
          )
        )
      ),
      bar = list(
        borderWidth = 0,
        borderRadius = 2
      ),
      column = list(
        borderWidth = 0,
        borderRadius = 2
      ),
      line = list(
        lineWidth = 2,
        marker = list(
          enabled = TRUE,
          symbol = "circle",
          radius = 4,
          fillColor = NULL,
          lineWidth = 1,
          lineColor = "#FFFFFF",
          states = list(
            hover = list(
              enabled = TRUE,
              radius = 6,
              fillColor = "#FFFFFF",
              lineWidth = 2,
              lineWidthPlus = 0
            )
          )
        )
      ),
      spline = list(
        lineWidth = 2,
        marker = list(
          enabled = TRUE,
          symbol = "circle",
          radius = 4,
          fillColor = NULL,
          lineWidth = 1,
          lineColor = "#FFFFFF",
          states = list(
            hover = list(
              enabled = TRUE,
              radius = 6,
              fillColor = "#FFFFFF",
              lineWidth = 2,
              lineWidthPlus = 0
            )
          )
        )
      ),
      scatter = list(
        marker = list(
          radius = 5
        )
      )
    ),
    credits = list(
      enabled = show_credits,
      text = "Highcharts.com",
      style = list(
        color = "#999999",
        fontSize = "10px"
      )
    )
  )
}

#' CPAL Dark Theme for Highcharter
#'
#' Returns a Highcharter theme configured with CPAL dark mode colors,
#' matching the cpaltemplates theme_cpal_dark() ggplot2 theme.
#'
#' @param base_size Base font size in pixels (default: 14)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param legend_position Legend position: "bottom", "right", "top", "left" (default: "bottom")
#' @param show_credits Show Highcharts credits watermark (default: FALSE)
#'
#' @return A Highcharter theme object
#' @export
#'
#' @examples
#' \dontrun{
#' library(highcharter)
#' hchart(mtcars, "scatter", hcaes(wt, mpg)) |>
#'   hc_add_theme(hc_theme_cpal_dark())
#' }
hc_theme_cpal_dark <- function(
    base_size = 14,
    grid = "horizontal",
    legend_position = "bottom",
    show_credits = FALSE
) {

  # Get colors from cpaltemplates
  palette_main <- cpal_colors("main")

  # Font settings
  font_family <- "Inter, Roboto, sans-serif"

  # Dark mode colors
  bg_color <- "#1a1a1a"
  text_color <- "#f0f0f0"
  subtitle_color <- "#bbbbbb"
  caption_color <- "#888888"
  axis_text_color <- "#e0e0e0"
  axis_title_color <- "#bbbbbb"
  grid_color <- "#333333"
  line_color <- "#666666"

  # Calculate derived sizes
  title_size <- paste0(round(base_size * 1.15), "px")
  subtitle_size <- paste0(round(base_size * 0.9), "px")
  caption_size <- paste0(round(base_size * 0.7), "px")
  axis_title_size <- paste0(round(base_size * 0.85), "px")
  axis_text_size <- paste0(round(base_size * 0.8), "px")
  legend_size <- paste0(round(base_size * 0.8), "px")

  # Grid line settings
  x_grid_width <- if (grid %in% c("vertical", "both")) 1 else 0
  y_grid_width <- if (grid %in% c("horizontal", "both")) 1 else 0

  # Legend positioning
  legend_align <- if (legend_position %in% c("left", "right")) legend_position else "center"
  legend_v_align <- if (legend_position %in% c("top", "bottom")) legend_position else "middle"
  legend_layout <- if (legend_position %in% c("top", "bottom")) "horizontal" else "vertical"

  # Build theme
  highcharter::hc_theme(
    colors = unname(palette_main),
    lang = list(
      thousandsSep = ",",
      decimalPoint = "."
    ),
    chart = list(
      backgroundColor = bg_color,
      style = list(
        fontFamily = font_family
      )
    ),
    title = list(
      align = "left",
      style = list(
        color = text_color,
        fontFamily = font_family,
        fontWeight = "bold",
        fontSize = title_size
      )
    ),
    subtitle = list(
      align = "left",
      style = list(
        color = subtitle_color,
        fontFamily = font_family,
        fontSize = subtitle_size
      )
    ),
    caption = list(
      align = "right",
      style = list(
        color = caption_color,
        fontFamily = font_family,
        fontSize = caption_size
      )
    ),
    xAxis = list(
      gridLineWidth = x_grid_width,
      gridLineColor = grid_color,
      lineColor = line_color,
      lineWidth = 1,
      tickColor = line_color,
      allowDecimals = FALSE,
      labels = list(
        style = list(
          color = axis_text_color,
          fontFamily = font_family,
          fontSize = axis_text_size
        )
      ),
      title = list(
        style = list(
          color = axis_title_color,
          fontFamily = font_family,
          fontSize = axis_title_size
        )
      )
    ),
    yAxis = list(
      gridLineWidth = y_grid_width,
      gridLineColor = grid_color,
      lineColor = line_color,
      lineWidth = 0,
      tickColor = line_color,
      allowDecimals = FALSE,
      labels = list(
        style = list(
          color = "#999999",
          fontFamily = font_family,
          fontSize = axis_text_size
        )
      ),
      title = list(
        style = list(
          color = axis_title_color,
          fontFamily = font_family,
          fontSize = axis_title_size
        )
      )
    ),
    legend = list(
      align = legend_align,
      verticalAlign = legend_v_align,
      layout = legend_layout,
      itemStyle = list(
        color = text_color,
        fontFamily = font_family,
        fontSize = legend_size,
        fontWeight = "normal"
      ),
      itemHoverStyle = list(
        color = "#FFFFFF"
      ),
      itemHiddenStyle = list(
        color = "#666666"
      )
    ),
    tooltip = list(
      backgroundColor = "#2a2a2a",
      borderColor = grid_color,
      borderRadius = 6,
      shadow = TRUE,
      style = list(
        color = text_color,
        fontFamily = font_family,
        fontSize = paste0(base_size, "px")
      )
    ),
    plotOptions = list(
      series = list(
        animation = list(
          duration = 1000,
          easing = "easeOutQuart"
        ),
        marker = list(
          lineWidth = 1,
          lineColor = bg_color
        ),
        states = list(
          hover = list(
            enabled = TRUE,
            lineWidthPlus = 1
          ),
          inactive = list(
            opacity = 0.3
          )
        )
      ),
      bar = list(
        borderWidth = 0,
        borderRadius = 2
      ),
      column = list(
        borderWidth = 0,
        borderRadius = 2
      ),
      line = list(
        lineWidth = 2,
        marker = list(
          enabled = TRUE,
          symbol = "circle",
          radius = 4,
          fillColor = NULL,
          lineWidth = 1,
          lineColor = bg_color,
          states = list(
            hover = list(
              enabled = TRUE,
              radius = 6,
              fillColor = bg_color,
              lineWidth = 2,
              lineWidthPlus = 0
            )
          )
        )
      ),
      spline = list(
        lineWidth = 2,
        marker = list(
          enabled = TRUE,
          symbol = "circle",
          radius = 4,
          fillColor = NULL,
          lineWidth = 1,
          lineColor = bg_color,
          states = list(
            hover = list(
              enabled = TRUE,
              radius = 6,
              fillColor = bg_color,
              lineWidth = 2,
              lineWidthPlus = 0
            )
          )
        )
      ),
      scatter = list(
        marker = list(
          radius = 5
        )
      )
    ),
    credits = list(
      enabled = show_credits,
      text = "Highcharts.com",
      style = list(
        color = "#666666",
        fontSize = "10px"
      )
    )
  )
}

#' Highcharter Theme Switcher for CPAL
#'
#' Returns the appropriate CPAL Highcharter theme based on the current mode.
#' Useful for Shiny apps with dark mode toggles.
#'
#' @param mode Character: "light" or "dark" (typically from input$dark_mode_toggle)
#' @param ... Additional arguments passed to hc_theme_cpal_light() or hc_theme_cpal_dark()
#'
#' @return A Highcharter theme object
#' @export
#'
#' @examples
#' \dontrun{
#' # In a Shiny server function:
#' output$my_chart <- renderHighchart({
#'   hchart(data, "scatter", hcaes(x, y)) |>
#'     hc_add_theme(hc_theme_cpal_switch(input$dark_mode))
#' })
#' }
hc_theme_cpal_switch <- function(mode = "light", ...) {
  if (is.null(mode) || mode == "light" || mode == FALSE) {
    hc_theme_cpal_light(...)
  } else {
    hc_theme_cpal_dark(...)
  }
}

#' Apply CPAL Theme with Number Formatting
#'
#' Convenience function that applies the CPAL theme and ensures proper
#' US number formatting (commas for thousands) in a single call.
#' Note: Number formatting is a global setting that affects all charts.
#'
#' @param hc A highchart object
#' @param mode Theme mode: "light" or "dark" (default: "light")
#' @param ... Additional arguments passed to the theme function
#'
#' @return A highchart object with theme applied (number formatting set globally)
#' @export
#'
#' @examples
#' \dontrun{
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_cpal_theme()
#'
#' # With dark mode
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_cpal_theme("dark")
#' }
hc_cpal_theme <- function(hc, mode = "light", ...) {
  # Set global number formatting
  hc_cpal_number_format()

  # Apply theme
  hc |>
    highcharter::hc_add_theme(hc_theme_cpal_switch(mode, ...))
}

# =============================================================================
# Color Functions
# =============================================================================

#' Apply CPAL Color Palette to Highcharter
#'
#' Helper function to easily apply CPAL color palettes to a highchart.
#'
#' @param hc A highchart object
#' @param palette Palette name: "main" (categorical), "sequential", or "diverging"
#' @param n Number of colors to use (optional, uses full palette if not specified)
#' @param reverse Reverse the palette order (default: FALSE)
#'
#' @return A highchart object with colors applied
#' @export
#'
#' @examples
#' \dontrun{
#' hchart(data, "bar", hcaes(x = category, y = value, group = series)) |>
#'   hc_colors_cpal("main")
#' }
hc_colors_cpal <- function(hc, palette = "main", n = NULL, reverse = FALSE) {

  colors <- switch(palette,
    "main" = cpal_colors("main"),
    "categorical" = cpal_colors("main"),
    "sequential" = cpal_colors("midnight_seq_8"),
    "seq" = cpal_colors("midnight_seq_8"),
    "diverging" = cpal_colors("coral_midnight_9"),
    "div" = cpal_colors("coral_midnight_9"),
    cpal_colors("main")
  )

  colors <- unname(colors)

  if (!is.null(n) && n <= length(colors)) {
    colors <- colors[1:n]
  }

  if (reverse) {
    colors <- rev(colors)
  }

  hc |> highcharter::hc_colors(colors)
}

#' Apply CPAL Color Axis for Heatmaps
#'
#' Returns a pre-configured colorAxis using CPAL color palettes.
#' Useful for heatmaps, choropleths, and other continuous color scales.
#'
#' @param hc A highchart object
#' @param palette Palette type: "sequential" (default) or "diverging"
#' @param min Minimum value for color scale (default: NULL, auto-calculated)
#' @param max Maximum value for color scale (default: NULL, auto-calculated)
#' @param reverse Reverse the color direction (default: FALSE)
#' @param stops Number of color stops to use (default: uses full palette)
#'
#' @return A highchart object with colorAxis configured
#' @export
#'
#' @examples
#' \dontrun{
#' # Sequential (good for heatmaps with positive values)
#' hchart(data, "heatmap", hcaes(x, y, value = z)) |>
#'   hc_colorAxis_cpal("sequential", min = 0, max = 100)
#'
#' # Diverging (good for correlation matrices, -1 to 1)
#' hchart(cor_data, "heatmap", hcaes(x, y, value = correlation)) |>
#'   hc_colorAxis_cpal("diverging", min = -1, max = 1)
#' }
hc_colorAxis_cpal <- function(
    hc,
    palette = "sequential",
    min = NULL,
    max = NULL,
    reverse = FALSE,
    stops = NULL
) {

  # Select palette
  colors <- switch(palette,
    "sequential" = cpal_colors("midnight_seq_8"),
    "seq" = cpal_colors("midnight_seq_8"),
    "diverging" = cpal_colors("coral_midnight_9"),
    "div" = cpal_colors("coral_midnight_9"),
    cpal_colors("midnight_seq_8")
  )

  colors <- unname(colors)

  # Reverse if requested
  if (reverse) {
    colors <- rev(colors)
  }

  # Limit stops if specified
  if (!is.null(stops) && stops < length(colors)) {
    indices <- round(seq(1, length(colors), length.out = stops))
    colors <- colors[indices]
  }

  # Build colorAxis config
  color_axis_config <- list(
    stops = highcharter::color_stops(colors = colors)
  )

  # Add min/max if specified
  if (!is.null(min)) color_axis_config$min <- min
  if (!is.null(max)) color_axis_config$max <- max

  hc |>
    highcharter::hc_colorAxis(
      stops = color_axis_config$stops,
      min = color_axis_config$min,
      max = color_axis_config$max
    )
}

# =============================================================================
# Formatting Helper Functions
# =============================================================================

#' Apply CPAL Number Formatting to Highcharter
#'
#' Ensures numbers in tooltips, axis labels, and legends use commas as
#' thousand separators (US format). This sets a GLOBAL option that affects
#' all subsequent highcharts in the session.
#'
#' @param hc A highchart object (optional, for pipe compatibility)
#'
#' @return The highchart object (unchanged), or NULL if called without argument
#' @export
#'
#' @examples
#' \dontrun{
#' # Option 1: Call once at session start
#' hc_cpal_number_format()
#'
#' # Option 2: In a pipe (sets global option, returns chart unchanged)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_add_theme(hc_theme_cpal_light()) |>
#'   hc_cpal_number_format()
#' }
hc_cpal_number_format <- function(hc = NULL) {
  # Set global highcharter language options
  hcoptslang <- getOption("highcharter.lang")
  if (is.null(hcoptslang)) {
    hcoptslang <- list()
  }
  hcoptslang$thousandsSep <- ","
  hcoptslang$decimalPoint <- "."
  options(highcharter.lang = hcoptslang)

  # Return the chart object for pipe compatibility
  if (!is.null(hc)) {
    return(hc)
  }
  invisible(NULL)
}

#' Apply CPAL-styled Tooltip with Decimal Control
#'
#' Helper function to easily configure tooltip formatting with control over
#' decimal places, prefixes, and suffixes.
#'
#' @param hc A highchart object
#' @param decimals Number of decimal places (default: 0)
#' @param prefix Text before the value, e.g., "$" (default: "")
#' @param suffix Text after the value, e.g., "\%" or " people" (default: "")
#' @param point_format Custom point format string (overrides other options if provided)
#'
#' @return A highchart object with tooltip configured
#' @export
#'
#' @examples
#' \dontrun{
#' # Population (no decimals, suffix)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_tooltip_cpal(decimals = 0, suffix = " people")
#'
#' # Percentage (2 decimals, suffix)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_tooltip_cpal(decimals = 2, suffix = "%")
#'
#' # Currency (2 decimals, prefix)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_tooltip_cpal(decimals = 2, prefix = "$")
#' }
hc_tooltip_cpal <- function(hc, decimals = 0, prefix = "", suffix = "", point_format = NULL) {

  if (!is.null(point_format)) {
    # Use custom format if provided
    hc |>
      highcharter::hc_tooltip(
        pointFormat = point_format
      )
  } else {
    # Build format string based on parameters
    format_str <- sprintf("<b>%s{point.y:,.%df}%s</b>", prefix, decimals, suffix)

    hc |>
      highcharter::hc_tooltip(
        pointFormat = format_str
      )
  }
}

#' Apply CPAL-styled Y-Axis with Decimal Control
#'
#' Helper function to configure y-axis label formatting with decimal control.
#'
#' @param hc A highchart object
#' @param title Y-axis title (default: NULL for no title)
#' @param decimals Number of decimal places in labels (default: 0)
#' @param prefix Text before values, e.g., "$" (default: "")
#' @param suffix Text after values, e.g., "\%" (default: "")
#' @param divide_by Divide values by this number for display, e.g., 1000000 for millions (default: 1)
#' @param ... Additional arguments passed to hc_yAxis
#'
#' @return A highchart object with y-axis configured
#' @export
#'
#' @examples
#' \dontrun{
#' # Percentage axis
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_yaxis_cpal(title = "Poverty Rate", decimals = 1, suffix = "%")
#'
#' # Population in millions
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_yaxis_cpal(title = "Population", suffix = "M", divide_by = 1000000)
#'
#' # Currency
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_yaxis_cpal(title = "Income", decimals = 0, prefix = "$")
#' }
hc_yaxis_cpal <- function(hc, title = NULL, decimals = 0, prefix = "", suffix = "",
                          divide_by = 1, ...) {

  # Build formatter function
  if (divide_by != 1) {
    formatter_js <- sprintf(
      "function() { return '%s' + Highcharts.numberFormat(this.value / %d, %d) + '%s'; }",
      prefix, divide_by, decimals, suffix
    )
  } else {
    formatter_js <- sprintf(
      "function() { return '%s' + Highcharts.numberFormat(this.value, %d) + '%s'; }",
      prefix, decimals, suffix
    )
  }

  hc |>
    highcharter::hc_yAxis(
      title = if (!is.null(title)) list(text = title) else list(text = NULL),
      labels = list(
        formatter = htmlwidgets::JS(formatter_js)
      ),
      ...
    )
}

#' Set Line Chart Type (Straight or Curved)
#'
#' Helper function to easily switch between straight lines and smooth splines.
#' Apply this after creating a line chart to convert it to a spline.
#'
#' @param hc A highchart object (should be a line chart)
#' @param curved Logical: TRUE for smooth spline curves, FALSE for straight lines (default: TRUE)
#'
#' @return A highchart object with the specified line type
#' @export
#'
#' @examples
#' \dontrun{
#' # Curved spline (smooth)
#' hchart(data, "line", hcaes(x, y, group = series)) |>
#'   hc_cpal_theme() |>
#'   hc_linetype_cpal(curved = TRUE)
#'
#' # Straight lines
#' hchart(data, "line", hcaes(x, y, group = series)) |>
#'   hc_cpal_theme() |>
#'   hc_linetype_cpal(curved = FALSE)
#' }
hc_linetype_cpal <- function(hc, curved = TRUE) {
  chart_type <- if (curved) "spline" else "line"

  # Modify each series type
  if (!is.null(hc$x$hc_opts$series)) {
    for (i in seq_along(hc$x$hc_opts$series)) {
      if (hc$x$hc_opts$series[[i]]$type %in% c("line", "spline")) {
        hc$x$hc_opts$series[[i]]$type <- chart_type
      }
    }
  }

  hc
}

# =============================================================================
# Logo Functions
# =============================================================================

#' Get CPAL Logo as Base64 Data URI
#'
#' Reads a CPAL logo from the cpaltemplates package and converts it to a
#' base64-encoded data URI suitable for embedding in Highcharts.
#'
#' @param mode Theme mode: "light" uses teal logo, "dark" uses white logo
#'
#' @return A base64 data URI string, or NULL if logo not found
#' @keywords internal
get_cpal_logo_base64 <- function(mode = "light") {
  # Determine which logo file to use based on mode
  logo_file <- if (mode == "dark") {
    "icons/CPAL_Icon_White.png"
  } else {
    "icons/CPAL_Icon_Teal.png"
  }

  # Try to find the logo in cpaltemplates package
  logo_path <- tryCatch(
    system.file("assets", logo_file, package = "cpaltemplates"),
    error = function(e) ""
  )

  if (logo_path == "" || !file.exists(logo_path)) {
    return(NULL)
  }

  # Check if base64enc is available
  if (!requireNamespace("base64enc", quietly = TRUE)) {
    warning("Package 'base64enc' is required for logo embedding. Install with: install.packages('base64enc')")
    return(NULL)
  }

  # Read and encode the file
  tryCatch({
    raw_data <- readBin(logo_path, "raw", file.info(logo_path)$size)
    base64_str <- base64enc::base64encode(raw_data)
    paste0("data:image/png;base64,", base64_str)
  }, error = function(e) {
    warning("Could not read logo file: ", e$message)
    NULL
  })
}

#' Add CPAL Logo to Highcharter Chart
#'
#' Adds the CPAL logo to a highchart using the renderer.image() method.
#' Logo is positioned in the top-right corner by default.
#'
#' @param hc A highchart object
#' @param logo_url URL or base64 string of the logo image. If NULL, automatically
#'   loads the appropriate CPAL logo from cpaltemplates package.
#' @param mode Theme mode: "light" or "dark". Determines which logo variant to use
#'   when logo_url is NULL. Default is "light" (teal logo).
#' @param position Logo position: "top-right" (default), "top-left", "bottom-right", "bottom-left"
#' @param width Logo width in pixels (default: 60)
#' @param height Logo height in pixels (default: auto based on 370:250 aspect ratio)
#' @param opacity Logo opacity 0-1 (default: 0.5)
#' @param margin Margin from chart edge in pixels (default: 10)
#'
#' @return A highchart object with logo added
#' @export
#'
#' @examples
#' \dontrun{
#' # Light mode (teal logo, top-right by default)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_add_theme(hc_theme_cpal_light()) |>
#'   hc_add_cpal_logo()
#'
#' # Dark mode (white logo)
#' hchart(data, "bar", hcaes(x, y)) |>
#'   hc_add_theme(hc_theme_cpal_dark()) |>
#'   hc_add_cpal_logo(mode = "dark")
#' }
hc_add_cpal_logo <- function(
    hc,
    logo_url = NULL,
    mode = "light",
    position = "top-right",
    width = 60,
    height = NULL,
    opacity = 0.5,
    margin = 10
) {

  # Get default CPAL logo if none provided
  if (is.null(logo_url)) {
    logo_url <- get_cpal_logo_base64(mode)
    if (is.null(logo_url)) {
      warning("Could not load CPAL logo. Install 'base64enc' package or provide a logo_url manually.")
      return(hc)
    }
  }

  # Calculate height from aspect ratio if not specified (370:250 = 1.48)
  if (is.null(height)) {
    height <- round(width / 1.48)
  }

  # Calculate position based on position parameter
  position_js <- switch(position,
    "bottom-right" = sprintf(
      "var x = this.chartWidth - %d - %d; var y = this.chartHeight - %d - %d;",
      width, margin, height, margin
    ),
    "bottom-left" = sprintf(
      "var x = %d; var y = this.chartHeight - %d - %d;",
      margin, height, margin
    ),
    "top-right" = sprintf(
      "var x = this.chartWidth - %d - %d; var y = %d;",
      width, margin, margin
    ),
    "top-left" = sprintf(
      "var x = %d; var y = %d;",
      margin, margin
    ),
    sprintf(
      "var x = this.chartWidth - %d - %d; var y = this.chartHeight - %d - %d;",
      width, margin, height, margin
    )
  )

  # Build the JavaScript for adding logo
  logo_js <- sprintf(
    "function() {
      %s
      var logo = this.renderer.image('%s', x, y, %d, %d)
        .attr({opacity: %f, zIndex: 5})
        .add();
      this.cpalLogo = logo;
    }",
    position_js,
    logo_url,
    width,
    height,
    opacity
  )

  # Add redraw handler to reposition on resize
  redraw_js <- sprintf(
    "function() {
      if (this.cpalLogo) {
        %s
        this.cpalLogo.attr({x: x, y: y});
      }
    }",
    position_js
  )

  hc |>
    highcharter::hc_chart(
      events = list(
        load = htmlwidgets::JS(logo_js),
        redraw = htmlwidgets::JS(redraw_js)
      )
    )
}

# =============================================================================
# Chart-Specific Helper Functions
# =============================================================================

#' Create a CPAL-styled Histogram
#'
#' Creates a histogram from raw data, handling the binning automatically.
#'
#' @param data A numeric vector of values to bin
#' @param breaks Number of bins (default: 15), or a vector of break points
#' @param name Series name for legend/tooltip (default: "Frequency")
#' @param color Bar color (default: CPAL midnight)
#' @param border_color Border color for bars (default: white)
#' @param border_width Border width in pixels (default: 1)
#' @param title Chart title (default: NULL)
#' @param subtitle Chart subtitle (default: NULL)
#' @param x_title X-axis title (default: "Value")
#' @param y_title Y-axis title (default: "Frequency")
#'
#' @return A highchart object
#' @export
hc_histogram_cpal <- function(
    data,
    breaks = 15,
    name = "Frequency",
    color = NULL,
    border_color = "#FFFFFF",
    border_width = 1,
    title = NULL,
    subtitle = NULL,
    x_title = "Value",
    y_title = "Frequency"
) {

  # Default color
  if (is.null(color)) {
    color <- cpal_colors("main")[1]
  }

  # Calculate histogram bins
  hist_result <- hist(data, breaks = breaks, plot = FALSE)

  # Create the highchart
  hc <- highcharter::highchart() |>
    highcharter::hc_chart(type = "column") |>
    highcharter::hc_xAxis(
      categories = round(hist_result$mids, 2),
      title = list(text = x_title)
    ) |>
    highcharter::hc_yAxis(title = list(text = y_title)) |>
    highcharter::hc_add_series(
      name = name,
      data = hist_result$counts,
      color = color,
      showInLegend = FALSE
    ) |>
    highcharter::hc_plotOptions(column = list(
      pointPadding = 0,
      groupPadding = 0,
      borderWidth = border_width,
      borderColor = border_color
    )) |>
    highcharter::hc_tooltip(
      pointFormat = paste0(name, ": <b>{point.y}</b>")
    )

  if (!is.null(title)) {
    hc <- hc |> highcharter::hc_title(text = title)
  }

  if (!is.null(subtitle)) {
    hc <- hc |> highcharter::hc_subtitle(text = subtitle)
  }

  hc
}

#' Create a CPAL-styled Lollipop Chart
#'
#' Creates a lollipop chart (stem + dot) from category and value data.
#'
#' @param categories Vector of category names (x-axis labels)
#' @param values Vector of numeric values
#' @param name Series name for legend/tooltip (default: "Value")
#' @param stem_color Color of the stem lines (default: CPAL midnight)
#' @param dot_color Color of the dots (default: CPAL coral)
#' @param dot_radius Size of dots in pixels (default: 8)
#' @param stem_width Width of stems in pixels (default: 2)
#' @param horizontal Logical: horizontal orientation (default: FALSE)
#' @param title Chart title (default: NULL)
#' @param subtitle Chart subtitle (default: NULL)
#' @param y_title Y-axis title (default: NULL)
#' @param tooltip_decimals Decimal places in tooltip (default: 1)
#' @param tooltip_suffix Suffix for tooltip values (default: "")
#'
#' @return A highchart object
#' @export
hc_lollipop_cpal <- function(
    categories,
    values,
    name = "Value",
    stem_color = NULL,
    dot_color = NULL,
    dot_radius = 8,
    stem_width = 2,
    horizontal = FALSE,
    title = NULL,
    subtitle = NULL,
    y_title = NULL,
    tooltip_decimals = 1,
    tooltip_suffix = ""
) {

  palette <- cpal_colors("main")
  if (is.null(stem_color)) stem_color <- palette[1]
  if (is.null(dot_color)) dot_color <- palette[2]

  # Build stem data
  stem_data <- lapply(seq_along(values), function(i) {
    list(low = 0, high = values[i])
  })

  hc <- highcharter::highchart() |>
    highcharter::hc_chart(inverted = horizontal) |>
    highcharter::hc_xAxis(
      categories = categories,
      title = list(text = NULL)
    ) |>
    highcharter::hc_yAxis(
      title = if (!is.null(y_title)) list(text = y_title) else list(text = NULL)
    ) |>
    highcharter::hc_add_series(
      type = "columnrange",
      name = "Range",
      data = stem_data,
      color = stem_color,
      pointWidth = stem_width,
      showInLegend = FALSE
    ) |>
    highcharter::hc_add_series(
      type = "scatter",
      name = name,
      data = values,
      color = dot_color,
      marker = list(radius = dot_radius, symbol = "circle")
    ) |>
    highcharter::hc_tooltip(
      pointFormat = sprintf("<b>{point.y:.%df}%s</b>", tooltip_decimals, tooltip_suffix)
    )

  if (!is.null(title)) hc <- hc |> highcharter::hc_title(text = title)
  if (!is.null(subtitle)) hc <- hc |> highcharter::hc_subtitle(text = subtitle)

  hc
}

#' Create a CPAL-styled Dumbbell Chart
#'
#' Creates a dumbbell chart showing the gap between two values for each category.
#'
#' @param categories Vector of category names
#' @param values_start Vector of starting values (first dot)
#' @param values_end Vector of ending values (second dot)
#' @param name_start Name for starting values in legend (default: "Start")
#' @param name_end Name for ending values in legend (default: "End")
#' @param color_start Color of starting dots (default: CPAL coral)
#' @param color_end Color of ending dots (default: CPAL sage)
#' @param connector_color Color of connecting lines (default: CPAL warm_gray)
#' @param dot_radius Size of dots in pixels (default: 8)
#' @param connector_width Width of connecting lines (default: 3)
#' @param horizontal Logical: horizontal orientation (default: TRUE)
#' @param title Chart title (default: NULL)
#' @param subtitle Chart subtitle (default: NULL)
#' @param y_title Y-axis title (default: NULL)
#' @param tooltip_decimals Decimal places in tooltip (default: 1)
#' @param tooltip_suffix Suffix for tooltip values (default: "")
#'
#' @return A highchart object
#' @export
hc_dumbbell_cpal <- function(
    categories,
    values_start,
    values_end,
    name_start = "Start",
    name_end = "End",
    color_start = NULL,
    color_end = NULL,
    connector_color = NULL,
    dot_radius = 8,
    connector_width = 3,
    horizontal = TRUE,
    title = NULL,
    subtitle = NULL,
    y_title = NULL,
    tooltip_decimals = 1,
    tooltip_suffix = ""
) {

  palette <- cpal_colors("main")
  if (is.null(color_start)) color_start <- palette[2]  # coral
  if (is.null(color_end)) color_end <- palette[3]      # sage
  if (is.null(connector_color)) connector_color <- "#9BA8AB"  # warm_gray

  # Build connector data
  connector_data <- lapply(seq_along(categories), function(i) {
    list(
      low = min(values_start[i], values_end[i]),
      high = max(values_start[i], values_end[i])
    )
  })

  hc <- highcharter::highchart() |>
    highcharter::hc_chart(inverted = horizontal) |>
    highcharter::hc_xAxis(
      categories = categories,
      title = list(text = NULL)
    ) |>
    highcharter::hc_yAxis(
      title = if (!is.null(y_title)) list(text = y_title) else list(text = NULL)
    ) |>
    highcharter::hc_add_series(
      type = "columnrange",
      name = "Change",
      data = connector_data,
      color = connector_color,
      pointWidth = connector_width,
      showInLegend = FALSE
    ) |>
    highcharter::hc_add_series(
      type = "scatter",
      name = name_start,
      data = values_start,
      color = color_start,
      marker = list(radius = dot_radius, symbol = "circle")
    ) |>
    highcharter::hc_add_series(
      type = "scatter",
      name = name_end,
      data = values_end,
      color = color_end,
      marker = list(radius = dot_radius, symbol = "circle")
    ) |>
    highcharter::hc_tooltip(
      shared = TRUE,
      pointFormat = sprintf("{series.name}: <b>{point.y:.%df}%s</b><br/>",
                            tooltip_decimals, tooltip_suffix)
    )

  if (!is.null(title)) hc <- hc |> highcharter::hc_title(text = title)
  if (!is.null(subtitle)) hc <- hc |> highcharter::hc_subtitle(text = subtitle)

  hc
}

# =============================================================================
# Single Color Accessor
# =============================================================================

#' Get a Single CPAL Color by Name
#'
#' Convenience function to get a single color from the CPAL palette by name.
#' Wrapper around cpal_colors() for single color access.
#'
#' @param name Color name (e.g., "midnight", "coral", "sage", "deep_teal")
#'
#' @return A single hex color string
#' @export
#'
#' @examples
#' cpal_color("midnight")
#' cpal_color("coral")
cpal_color <- function(name) {
  colors <- cpal_colors("primary")
  if (name %in% names(colors)) {
    return(unname(colors[name]))
  }

  # Try extended colors
  colors_ext <- cpal_colors("extended")
  if (name %in% names(colors_ext)) {
    return(unname(colors_ext[name]))
  }

  # Try main palette by index name
  colors_main <- cpal_colors("main")
  if (name %in% names(colors_main)) {
    return(unname(colors_main[name]))
  }

  # Default fallback
  warning(paste0("Color '", name, "' not found. Returning midnight."))
  return(cpal_colors("primary")[1])
}

# =============================================================================
# Boxplot Styling
# =============================================================================

#' Apply CPAL Styling to Boxplot Series
#'
#' Applies CPAL colors and fill opacity to boxplot series.
#' Use this after adding boxplot series to ensure consistent CPAL styling.
#'
#' @param hc A highchart object with boxplot series
#' @param fill_opacity Fill opacity for boxes (default: 0.7)
#'
#' @return A highchart object with styled boxplots
#' @export
#'
#' @examples
#' \dontrun{
#' highchart() |>
#'   hc_chart(type = "boxplot") |>
#'   hc_add_series(name = "Group A", data = list(...)) |>
#'   hc_add_series(name = "Group B", data = list(...)) |>
#'   hc_boxplot_style_cpal()
#' }
hc_boxplot_style_cpal <- function(hc, fill_opacity = 0.7) {
  palette <- unname(cpal_colors("main"))

  # Modify each series to have explicit color and fillColor

  if (!is.null(hc$x$hc_opts$series)) {
    for (i in seq_along(hc$x$hc_opts$series)) {
      color_index <- ((i - 1) %% length(palette)) + 1
      base_color <- palette[color_index]
      # Convert hex to rgba with opacity for fill
      rgb_vals <- grDevices::col2rgb(base_color)
      fill_color <- sprintf("rgba(%d, %d, %d, %.1f)",
                            rgb_vals[1], rgb_vals[2], rgb_vals[3], fill_opacity)
      # Set both color (for stroke) and fillColor (for fill)
      hc$x$hc_opts$series[[i]]$color <- base_color
      hc$x$hc_opts$series[[i]]$fillColor <- fill_color
    }
  }

  # Set plotOptions for line styling
  hc |>
    highcharter::hc_plotOptions(
      boxplot = list(
        lineWidth = 2,
        medianWidth = 3,
        whiskerLength = "50%"
      )
    )
}

# =============================================================================
# Waterfall Chart Helpers
# =============================================================================

#' Auto-Color Waterfall Chart Data with CPAL Colors
#'
#' Automatically assigns CPAL colors to waterfall chart data based on whether
#' values are positive (increases), negative (decreases), or totals.
#'
#' @param data A data frame with columns: name, y, and optionally isSum
#' @param positive_color Color for positive values (default: CPAL sage)
#' @param negative_color Color for negative values (default: CPAL coral)
#' @param total_color Color for sum/total values (default: CPAL midnight)
#'
#' @return A list suitable for hc_add_series data parameter
#' @export
#'
#' @examples
#' \dontrun{
#' waterfall_data <- data.frame(
#'   name = c("Start", "Add", "Subtract", "Total"),
#'   y = c(100, 50, -30, NA),
#'   isSum = c(FALSE, FALSE, FALSE, TRUE)
#' )
#' colored_data <- hc_waterfall_colors_cpal(waterfall_data)
#' }
hc_waterfall_colors_cpal <- function(
    data,
    positive_color = NULL,
    negative_color = NULL,
    total_color = NULL
) {
  palette <- cpal_colors("main")

  if (is.null(positive_color)) positive_color <- palette[3]  # sage
  if (is.null(negative_color)) negative_color <- palette[2]  # coral
  if (is.null(total_color)) total_color <- palette[1]        # midnight

  # Ensure isSum column exists
  if (!"isSum" %in% names(data)) {
    data$isSum <- FALSE
  }

  # Build list of data points with colors
  lapply(seq_len(nrow(data)), function(i) {
    point <- list(
      name = data$name[i],
      y = data$y[i]
    )

    if (!is.na(data$isSum[i]) && data$isSum[i]) {
      point$isSum <- TRUE
      point$color <- total_color
    } else if (!is.na(data$y[i])) {
      if (data$y[i] >= 0) {
        point$color <- positive_color
      } else {
        point$color <- negative_color
      }
    }

    point
  })
}

# =============================================================================
# Treemap Helpers
# =============================================================================

#' Build Hierarchical Treemap Data with CPAL Colors
#'
#' Converts a flat data frame with parent-child relationships into the
#' hierarchical format required by Highcharts treemaps, with CPAL colors applied.
#'
#' @param data A data frame with parent, child, and value columns
#' @param parent_col Name of the column containing parent/group names
#' @param child_col Name of the column containing child/item names
#' @param value_col Name of the column containing numeric values
#'
#' @return A list suitable for hc_add_series data parameter
#' @export
#'
#' @examples
#' \dontrun{
#' budget_data <- data.frame(
#'   department = c("Health", "Health", "Education", "Education"),
#'   program = c("Clinics", "Hospitals", "K-12", "Higher Ed"),
#'   budget = c(45, 120, 180, 95)
#' )
#' treemap_data <- hc_treemap_data_cpal(
#'   budget_data,
#'   parent_col = "department",
#'   child_col = "program",
#'   value_col = "budget"
#' )
#' }
hc_treemap_data_cpal <- function(
    data,
    parent_col,
    child_col,
    value_col
) {
  palette <- cpal_colors("main")
  parents <- unique(data[[parent_col]])

  result <- list()

  # Add parent nodes (level 1)
  for (i in seq_along(parents)) {
    parent <- parents[i]
    color_idx <- ((i - 1) %% length(palette)) + 1

    result[[length(result) + 1]] <- list(
      id = parent,
      name = parent,
      color = unname(palette[color_idx])
    )
  }

  # Add child nodes (level 2)
  for (j in seq_len(nrow(data))) {
    result[[length(result) + 1]] <- list(
      name = data[[child_col]][j],
      parent = data[[parent_col]][j],
      value = data[[value_col]][j]
    )
  }

  result
}

#' Apply CPAL Styling to Treemap
#'
#' Applies CPAL-styled level options to treemap charts, including
#' proper header formatting and border styling.
#'
#' @param hc A highchart object with treemap series
#' @param level1_border_width Border width for level 1 (default: 3)
#' @param level2_border_width Border width for level 2 (default: 1)
#'
#' @return A highchart object with styled treemap
#' @export
#'
#' @examples
#' \dontrun{
#' highchart() |>
#'   hc_add_series(type = "treemap", data = treemap_data) |>
#'   hc_treemap_style_cpal()
#' }
hc_treemap_style_cpal <- function(
    hc,
    level1_border_width = 3,
    level2_border_width = 1
) {
  hc |>
    highcharter::hc_plotOptions(
      treemap = list(
        allowDrillToNode = TRUE,
        layoutAlgorithm = "squarified",
        dataLabels = list(
          enabled = TRUE,
          style = list(
            fontSize = "12px",
            fontWeight = "normal",
            textOutline = "none"
          )
        ),
        levels = list(
          list(
            level = 1,
            borderWidth = level1_border_width,
            borderColor = "#FFFFFF",
            dataLabels = list(
              enabled = TRUE,
              align = "left",
              verticalAlign = "top",
              style = list(
                fontSize = "14px",
                fontWeight = "bold",
                color = "#FFFFFF",
                textOutline = "2px contrast"
              )
            )
          ),
          list(
            level = 2,
            borderWidth = level2_border_width,
            borderColor = "#FFFFFF",
            dataLabels = list(
              enabled = TRUE,
              style = list(
                fontSize = "11px",
                color = "#FFFFFF",
                textOutline = "1px contrast"
              )
            )
          )
        )
      )
    )
}
