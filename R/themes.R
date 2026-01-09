# Declare global variables used in aes() to avoid R CMD check notes
utils::globalVariables(c("x", "y", "group"))

#' CPAL ggplot2 Theme
#'
#' A consistent theme for CPAL data visualizations based on organizational
#' style guidelines. Provides clean, accessible visualizations with
#' CPAL brand colors and typography. Now uses Google Fonts (Inter/Roboto).
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses Inter from Google Fonts if available)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param style Theme style: "default", "minimal", "classic", or "dark" (default: "default")
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param axis_line Axis line position: "x", "y", "both", or "none" (default: "x")
#' @param axis_title Include axis titles (default: TRUE)
#' @param legend_position Legend position (default: "bottom")
#' @param thematic Logical. If TRUE, allows the thematic package to control
#'   background and text colors for automatic light/dark mode support in Shiny
#'   apps. When enabled, color-related theme elements are set to NA so they
#'   inherit from thematic's auto-detected colors. Default: FALSE.
#'
#' @return A ggplot2 theme object
#' @export
theme_cpal <- function(base_size = 14,
                       base_family = "",
                       base_line_size = base_size / 22,
                       base_rect_size = base_size / 22,
                       style = c("default", "minimal", "classic", "dark"),
                       grid = c("horizontal", "vertical", "both", "none"),
                       axis_line = c("x", "y", "both", "none"),
                       axis_title = TRUE,
                       legend_position = "bottom",
                       thematic = FALSE) {

  style <- match.arg(style)

  # Handle logical grid values (for backward compatibility)
  if (is.logical(grid)) {
    grid <- if (grid) "horizontal" else "none"
  }
  grid <- match.arg(grid, c("horizontal", "vertical", "both", "none"))
  axis_line <- match.arg(axis_line)

  # CPAL color palette (from brand colors)
  midnight <- "#004855"
  neutral <- "#E8ECEE"
  neutral_dark <- "#9BA8AB"
  axis_line_color <- "#5C6B73"

  # Font family setup
  if (base_family == "") {
    base_family <- get_cpal_font_family(for_interactive = FALSE, setup_if_missing = FALSE)
    if (base_family == "sans") {
      base_family <- cpal_font_family_fallback()
    }
  }

  # Start with ggplot2's theme_gray as base
  theme <- ggplot2::theme_gray(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  )

  # Set colors based on style (only used when thematic = FALSE)
  if (style == "dark") {
    bg_color <- "#1a1a1a"
    title_color <- "#f0f0f0"
    text_color <- "#f0f0f0"
    grid_color <- "#333333"
    axis_text_color <- "#e0e0e0"
    subtitle_color <- "#bbbbbb"
    caption_color <- "#888888"
    axis_title_color <- "#bbbbbb"
    strip_bg_color <- "#2a2a2a"
    axis_ticks_color <- "#666666"
    axis_line_style_color <- "#666666"
  } else {
    bg_color <- "white"
    title_color <- midnight
    text_color <- "#222222"
    grid_color <- neutral
    axis_text_color <- midnight
    subtitle_color <- "#666666"
    caption_color <- neutral_dark
    axis_title_color <- "#555555"
    strip_bg_color <- neutral
    axis_ticks_color <- neutral_dark
    axis_line_style_color <- axis_line_color
  }

  # Build theme differently based on thematic mode
  if (thematic) {
    # THEMATIC MODE: Don't set colors - let thematic control them
    # Only set structural elements (sizes, margins, fonts, positions)

    theme <- theme + ggplot2::theme(
      # Text base - font only, colour inherits from theme_gray
      text = ggplot2::element_text(
        family = base_family,
        size = base_size,
        lineheight = 0.9,
        inherit.blank = TRUE
      ),

      # Plot titles
      plot.title = ggplot2::element_text(
        size = base_size * 1.15,
        family = base_family,
        face = "bold",
        hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.4),
        inherit.blank = TRUE
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 0.9,
        family = base_family,
        face = "plain",
        hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.6),
        inherit.blank = TRUE
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 0.7,
        family = base_family,
        hjust = 1,
        margin = ggplot2::margin(t = base_size * 0.5),
        inherit.blank = TRUE
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",

      # Axis titles
      axis.title = if (axis_title) {
        ggplot2::element_text(
          family = base_family,
          face = "plain",
          size = base_size * 0.85,
          inherit.blank = TRUE
        )
      } else {
        ggplot2::element_blank()
      },
      axis.title.x = ggplot2::element_text(
        margin = ggplot2::margin(t = base_size * 0.5),
        inherit.blank = TRUE
      ),
      axis.title.y = ggplot2::element_text(
        margin = ggplot2::margin(r = base_size * 0.5),
        inherit.blank = TRUE
      ),

      # Axis text
      axis.text.x = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.8,
        face = "plain",
        inherit.blank = TRUE
      ),
      axis.text.y = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.8,
        face = "plain",
        inherit.blank = TRUE
      ),

      # Axis ticks - let thematic control color
      axis.ticks = ggplot2::element_line(colour = NA, inherit.blank = TRUE),

      # Panel - use element_rect with NA fill to inherit thematic's colors
      # Note: element_blank() causes grid lines to inherit white from theme_gray
      # which is invisible on light backgrounds. Using NA lets thematic compute proper colors.
      panel.background = ggplot2::element_rect(fill = NA, colour = NA),
      panel.border = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = NA, colour = NA),

      # Legend
      legend.position = legend_position,
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(
        size = base_size * 0.7,
        family = base_family,
        inherit.blank = TRUE
      ),
      legend.title = ggplot2::element_text(
        size = base_size * 0.7,
        face = "bold",
        inherit.blank = TRUE
      ),
      legend.key.size = ggplot2::unit(0.7, "lines"),
      legend.key.width = ggplot2::unit(0.7, "lines"),
      legend.key.height = ggplot2::unit(0.7, "lines"),
      legend.margin = ggplot2::margin(t = 5, b = 0, l = 0, r = 0, unit = "pt"),
      legend.box.margin = ggplot2::margin(0, 0, 0, 0, unit = "pt"),

      # Strip
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(
        family = base_family,
        face = "bold",
        size = base_size * 9.5 / 8.5,
        margin = ggplot2::margin(
          base_size * 0.3, base_size * 0.3,
          base_size * 0.3, base_size * 0.3
        ),
        inherit.blank = TRUE
      ),

      # Plot margins
      plot.margin = ggplot2::margin(15, 15, 15, 15, "pt")
    )

    # Grid lines - let thematic control colors
    # Use colour = NA to signal thematic should compute the color (not inherit theme_gray's white)
    # Don't blank the parent element - only blank specific gridlines we don't want
    if (grid == "horizontal") {
      theme <- theme + ggplot2::theme(
        panel.grid.major.y = ggplot2::element_line(colour = NA, linewidth = 0.25, inherit.blank = TRUE),
        panel.grid.major.x = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      )
    } else if (grid == "vertical") {
      theme <- theme + ggplot2::theme(
        panel.grid.major.x = ggplot2::element_line(colour = NA, linewidth = 0.25, inherit.blank = TRUE),
        panel.grid.major.y = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      )
    } else if (grid == "both") {
      theme <- theme + ggplot2::theme(
        panel.grid.major.y = ggplot2::element_line(colour = NA, linewidth = 0.25, inherit.blank = TRUE),
        panel.grid.major.x = ggplot2::element_line(colour = NA, linewidth = 0.25, inherit.blank = TRUE),
        panel.grid.minor = ggplot2::element_blank()
      )
    } else {
      # grid == "none"
      theme <- theme + ggplot2::theme(
        panel.grid.major = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      )
    }

    # Axis lines - same approach as gridlines: use colour = NA to let thematic compute
    if (axis_line == "x") {
      theme <- theme + ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE),
        axis.line.y = ggplot2::element_blank()
      )
    } else if (axis_line == "y") {
      theme <- theme + ggplot2::theme(
        axis.line.y.left = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE),
        axis.line.x = ggplot2::element_blank()
      )
    } else if (axis_line == "both") {
      theme <- theme + ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE),
        axis.line.y.left = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE)
      )
    } else {
      # axis_line == "none"
      theme <- theme + ggplot2::theme(axis.line = ggplot2::element_blank())
    }

    # Style-specific adjustments
    if (style == "minimal") {
      theme <- theme + ggplot2::theme(axis.ticks = ggplot2::element_blank())
    } else if (style == "classic") {
      # Classic style always shows both axis lines
      theme <- theme + ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE),
        axis.line.y.left = ggplot2::element_line(colour = NA, linewidth = 0.5, inherit.blank = TRUE)
      )
    }

  } else {
    # STANDARD MODE: Set explicit CPAL colors

    theme <- theme + ggplot2::theme(
      # Text base
      text = ggplot2::element_text(
        family = base_family,
        colour = text_color,
        size = base_size,
        lineheight = 0.9
      ),

      # Plot titles
      plot.title = ggplot2::element_text(
        size = base_size * 1.15,
        family = base_family,
        face = "bold",
        hjust = 0,
        color = title_color,
        margin = ggplot2::margin(b = base_size * 0.4)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 0.9,
        family = base_family,
        face = "plain",
        hjust = 0,
        color = subtitle_color,
        margin = ggplot2::margin(b = base_size * 0.6)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 0.7,
        family = base_family,
        hjust = 1,
        margin = ggplot2::margin(t = base_size * 0.5),
        color = caption_color
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",

      # Axis titles
      axis.title = if (axis_title) {
        ggplot2::element_text(
          family = base_family,
          face = "plain",
          size = base_size * 0.85,
          color = axis_title_color
        )
      } else {
        ggplot2::element_blank()
      },
      axis.title.x = ggplot2::element_text(
        margin = ggplot2::margin(t = base_size * 0.5)
      ),
      axis.title.y = ggplot2::element_text(
        margin = ggplot2::margin(r = base_size * 0.5)
      ),

      # Axis text
      axis.text.x = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.8,
        face = "plain",
        color = axis_text_color
      ),
      axis.text.y = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.8,
        face = "plain",
        color = if (style == "dark") "#999999" else "#444444"
      ),

      # Axis ticks
      axis.ticks = ggplot2::element_line(color = axis_ticks_color),

      # Panel
      panel.background = ggplot2::element_rect(fill = bg_color, color = NA),
      panel.border = ggplot2::element_blank(),
      plot.background = ggplot2::element_rect(fill = bg_color, color = NA),

      # Legend
      legend.position = legend_position,
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(
        size = base_size * 0.7,
        family = base_family,
        color = text_color
      ),
      legend.title = ggplot2::element_text(
        size = base_size * 0.7,
        face = "bold",
        color = if (style == "dark") title_color else midnight
      ),
      legend.key.size = ggplot2::unit(0.7, "lines"),
      legend.key.width = ggplot2::unit(0.7, "lines"),
      legend.key.height = ggplot2::unit(0.7, "lines"),
      legend.margin = ggplot2::margin(t = 5, b = 0, l = 0, r = 0, unit = "pt"),
      legend.box.margin = ggplot2::margin(0, 0, 0, 0, unit = "pt"),

      # Strip
      strip.background = ggplot2::element_rect(fill = strip_bg_color, color = NA),
      strip.text = ggplot2::element_text(
        family = base_family,
        face = "bold",
        size = base_size * 9.5 / 8.5,
        color = if (style == "dark") title_color else midnight,
        margin = ggplot2::margin(
          base_size * 0.3, base_size * 0.3,
          base_size * 0.3, base_size * 0.3
        )
      ),

      # Plot margins
      plot.margin = ggplot2::margin(15, 15, 15, 15, "pt")
    )

    # Grid lines
    theme <- theme + ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    )

    if (grid == "horizontal" || grid == "both") {
      theme <- theme + ggplot2::theme(
        panel.grid.major.y = ggplot2::element_line(color = grid_color, linewidth = 0.25)
      )
    }
    if (grid == "vertical" || grid == "both") {
      theme <- theme + ggplot2::theme(
        panel.grid.major.x = ggplot2::element_line(color = grid_color, linewidth = 0.25)
      )
    }

    # Axis lines
    theme <- theme + ggplot2::theme(axis.line = ggplot2::element_blank())

    if (axis_line == "x" || axis_line == "both") {
      theme <- theme + ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(
          color = axis_line_style_color,
          linewidth = 0.5
        )
      )
    }
    if (axis_line == "y" || axis_line == "both") {
      theme <- theme + ggplot2::theme(
        axis.line.y.left = ggplot2::element_line(
          color = axis_line_style_color,
          linewidth = 0.5
        )
      )
    }

    # Style-specific adjustments
    if (style == "minimal") {
      theme <- theme + ggplot2::theme(axis.ticks = ggplot2::element_blank())
    } else if (style == "classic") {
      theme <- theme + ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(
          color = axis_line_style_color,
          linewidth = 0.5
        ),
        axis.line.y.left = ggplot2::element_line(
          color = axis_line_style_color,
          linewidth = 0.5
        )
      )
    }
  }

  return(theme)
}

#' Reactive Theme Switcher for CPAL
#'
#' Returns the appropriate CPAL theme based on the current mode.
#' Use this in Shiny apps to switch between light and dark themes
#' without requiring the thematic package.
#'
#' @param mode Character: "light" or "dark" (typically from input$dark_mode_toggle)
#' @param ... Additional arguments passed to the underlying theme function
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' # In a Shiny server function:
#' output$my_plot <- renderPlot({
#'   ggplot(data, aes(x, y)) +
#'     geom_point() +
#'     theme_cpal_switch(input$dark_mode_toggle)
#' })
#' }
#' @seealso [make_theme_reactive()] for creating a reusable reactive theme
theme_cpal_switch <- function(mode = "light", ...) {
  if (is.null(mode) || mode == "light") {
    theme_cpal(...)
  } else {
    theme_cpal_dark(...)
  }
}

#' Reactive Theme for Shiny (Function Factory)
#'
#' Creates a reactive expression that returns the appropriate theme.
#' Call this once in your server function to create a reusable theme reactive.
#'
#' @param input The Shiny input object
#' @param toggle_id The ID of the dark mode toggle input (default: "dark_mode_toggle")
#' @param ... Additional arguments passed to theme functions
#' @return A reactive expression that returns a ggplot2 theme
#' @export
#' @examples
#' \dontrun{
#' # In server function:
#' current_theme <- make_theme_reactive(input)
#'
#' output$my_plot <- renderPlot({
#'   ggplot(data, aes(x, y)) +
#'     geom_point() +
#'     current_theme()
#' })
#' }
#' @seealso [theme_cpal_switch()] for direct theme switching
make_theme_reactive <- function(input, toggle_id = "dark_mode_toggle", ...) {
  shiny::reactive({
    mode <- input[[toggle_id]]
    theme_cpal_switch(mode, ...)
  })
}

#' CPAL Theme with Thematic Auto-theming Support (Deprecated)
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `theme_cpal_auto()` is deprecated. Please use [theme_cpal_switch()] instead,
#' which provides direct light/dark mode switching without requiring the thematic package.
#'
#' @inheritParams theme_cpal
#' @return A ggplot2 theme object
#' @export
#' @keywords internal
theme_cpal_auto <- function(base_size = 14,
                            base_family = "",
                            base_line_size = base_size / 22,
                            base_rect_size = base_size / 22,
                            grid = c("horizontal", "vertical", "both", "none"),
                            axis_line = c("x", "y", "both", "none"),
                            axis_title = TRUE,
                            legend_position = "bottom") {

  lifecycle::deprecate_warn(
    "2.6.0",
    "theme_cpal_auto()",
    "theme_cpal_switch()"
  )

  theme_cpal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    style = "default",
    grid = grid,
    axis_line = axis_line,
    axis_title = axis_title,
    legend_position = legend_position,
    thematic = TRUE
  )
}

#' CPAL Dark Theme
#'
#' Dark variant of the CPAL theme, optimized for dark backgrounds
#' and presentations. All styling elements are adjusted for optimal
#' contrast and readability in dark mode.
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses Inter from Google Fonts if available)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param axis_line Axis line position: "x", "y", "both", or "none" (default: "x")
#' @param axis_title Include axis titles (default: TRUE)
#' @param legend_position Legend position (default: "bottom")
#'
#' @return A ggplot2 theme object optimized for dark backgrounds
#' @export
theme_cpal_dark <- function(base_size = 16,
                            base_family = "",
                            base_line_size = base_size / 22,
                            base_rect_size = base_size / 22,
                            grid = c("horizontal", "vertical", "both", "none"),
                            axis_line = c("x", "y", "both", "none"),
                            axis_title = TRUE,
                            legend_position = "bottom") {

  theme_cpal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    style = "dark",
    grid = grid,
    axis_line = axis_line,
    axis_title = axis_title,
    legend_position = legend_position
  )
}

#' CPAL Minimal Theme
#'
#' Minimal variant of the CPAL theme with reduced visual elements.
#' Perfect for clean, distraction-free visualizations where data
#' should take center stage.
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses Inter from Google Fonts if available)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param axis_line Axis line position: "x", "y", "both", or "none" (default: "x")
#' @param axis_title Include axis titles (default: TRUE)
#' @param legend_position Legend position (default: "bottom")
#'
#' @return A ggplot2 theme object with minimal styling
#' @export
theme_cpal_minimal <- function(base_size = 16,
                               base_family = "",
                               base_line_size = base_size / 22,
                               base_rect_size = base_size / 22,
                               grid = c("horizontal", "vertical", "both", "none"),
                               axis_line = c("x", "y", "both", "none"),
                               axis_title = TRUE,
                               legend_position = "bottom") {

  theme_cpal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    style = "minimal",
    grid = grid,
    axis_line = axis_line,
    axis_title = axis_title,
    legend_position = legend_position
  )
}

#' CPAL Classic Theme
#'
#' Classic variant of the CPAL theme with traditional ggplot2 styling
#' elements like axis lines and more structured appearance. Good for
#' formal reports and academic presentations.
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses Inter from Google Fonts if available)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "horizontal")
#' @param axis_line Axis line position: "x", "y", "both", or "none" (default: "x")
#' @param axis_title Include axis titles (default: TRUE)
#' @param legend_position Legend position (default: "bottom")
#'
#' @return A ggplot2 theme object with classic styling
#' @export
theme_cpal_classic <- function(base_size = 16,
                               base_family = "",
                               base_line_size = base_size / 22,
                               base_rect_size = base_size / 22,
                               grid = c("horizontal", "vertical", "both", "none"),
                               axis_line = c("x", "y", "both", "none"),
                               axis_title = TRUE,
                               legend_position = "bottom") {

  theme_cpal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    style = "classic",
    grid = grid,
    axis_line = axis_line,
    axis_title = axis_title,
    legend_position = legend_position
  )
}

#' CPAL Print Theme
#'
#' Optimized theme for printed materials and PDFs. Uses conservative
#' styling and ensures good contrast for black and white printing.
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses system font for print compatibility)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param grid Grid lines: "horizontal", "vertical", "both", or "none" (default: "both")
#' @param axis_line Axis line position: "x", "y", "both", or "none" (default: "both")
#' @param axis_title Include axis titles (default: TRUE)
#' @param legend_position Legend position (default: "bottom")
#'
#' @return A ggplot2 theme object optimized for printing
#' @export
theme_cpal_print <- function(base_size = 16,
                             base_family = "",
                             base_line_size = base_size / 22,
                             base_rect_size = base_size / 22,
                             grid = c("horizontal", "vertical", "both", "none"),
                             axis_line = c("x", "y", "both", "none"),
                             axis_title = TRUE,
                             legend_position = "bottom") {

  # Use system font for print compatibility
  if (base_family == "") {
    base_family <- "sans"
  }

  theme_cpal(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size,
    style = "classic",
    grid = grid,
    axis_line = axis_line,
    axis_title = axis_title,
    legend_position = legend_position
  ) +
    ggplot2::theme(
      # High contrast for printing
      text = ggplot2::element_text(color = "black"),
      plot.title = ggplot2::element_text(color = "black"),
      plot.subtitle = ggplot2::element_text(color = "black"),
      plot.caption = ggplot2::element_text(color = "#666666"),
      axis.title = ggplot2::element_text(color = "black"),
      axis.text = ggplot2::element_text(color = "black"),
      legend.title = ggplot2::element_text(color = "black"),
      legend.text = ggplot2::element_text(color = "black"),
      strip.text = ggplot2::element_text(color = "black"),

      # Ensure white background
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA)
    )
}

#' CPAL Map Theme
#'
#' Specialized theme for geographic visualizations and maps.
#' Removes most decorative elements to focus attention on the
#' geographic data itself.
#'
#' @param base_size Base font size (default: 16)
#' @param base_family Base font family (default: uses Inter from Google Fonts if available)
#' @param base_line_size Base size for line elements (default: base_size/22)
#' @param base_rect_size Base size for rect elements (default: base_size/22)
#' @param legend_position Legend position (default: "bottom")
#'
#' @return A ggplot2 theme object optimized for maps
#' @export
theme_cpal_map <- function(base_size = 16,
                           base_family = "",
                           base_line_size = base_size / 22,
                           base_rect_size = base_size / 22,
                           legend_position = "bottom") {

  if (base_family == "") {
    base_family <- get_cpal_font_family(for_interactive = FALSE, setup_if_missing = FALSE)
    if (base_family == "sans") {
      base_family <- cpal_font_family_fallback()
    }
  }

  midnight <- "#004855"

  ggplot2::theme_void(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  ) +
    ggplot2::theme(
      # Plot titles
      plot.title = ggplot2::element_text(
        size = base_size * 12/8.5,
        family = base_family,
        face = "bold",
        hjust = 0.5,
        color = midnight,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 9.5/8.5,
        family = base_family,
        face = "plain",
        hjust = 0.5,
        color = midnight,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 7/8.5,
        family = base_family,
        hjust = 1,
        margin = ggplot2::margin(t = base_size * 0.5),
        color = "#9BA8AB"
      ),

      # Legend styling for maps - wider for continuous scales
      legend.position = legend_position,
      legend.text = ggplot2::element_text(
        size = base_size * 9.5/8.5,
        family = base_family
      ),
      legend.title = ggplot2::element_text(
        size = base_size,
        face = "bold",
        color = midnight
      ),
      # Improved legend sizing for continuous scales
      legend.key.width = ggplot2::unit(base_size * 2, "pt"),
      legend.key.height = ggplot2::unit(base_size * 0.8, "pt"),

      # Background
      plot.background = ggplot2::element_rect(fill = "white", color = NA),

      # Plot margins
      plot.margin = ggplot2::margin(
        t = base_size, r = base_size,
        b = base_size, l = base_size
      )
    )
}

#' Set CPAL Theme as Default
#'
#' Sets the CPAL theme as the default ggplot2 theme for the current session.
#' This means all subsequent plots will automatically use CPAL styling
#' unless a different theme is explicitly specified.
#'
#' @param style Theme style to set as default (default: "default")
#' @param base_size Base font size (default: 16)
#' @param ... Additional arguments passed to the theme function
#'
#' @return Invisibly returns the theme that was set
#' @export
#' @examples
#' \dontrun{
#' # Set CPAL theme as default
#' set_theme_cpal()
#'
#' # Set dark theme as default
#' set_theme_cpal("dark")
#'
#' # Set with larger font
#' set_theme_cpal(base_size = 18)
#' }
set_theme_cpal <- function(style = "default", base_size = 16, ...) {
  theme_func <- switch(style,
                       "default" = theme_cpal,
                       "dark" = theme_cpal_dark,
                       "minimal" = theme_cpal_minimal,
                       "classic" = theme_cpal_classic,
                       "print" = theme_cpal_print,
                       "map" = theme_cpal_map,
                       theme_cpal  # fallback to default
  )

  theme_to_set <- theme_func(base_size = base_size, ...)
  ggplot2::theme_set(theme_to_set)

  message(paste("CPAL", style, "theme set as default with base_size =", base_size))
  invisible(theme_to_set)
}

#' Preview All CPAL Theme Variants
#'
#' Creates a visual comparison of all CPAL theme variants using a sample plot.
#' Useful for choosing the right theme for your visualization needs.
#'
#' @param data Optional data frame. If NULL, uses built-in sample data.
#' @param save_path Optional file path. If provided, saves the preview as an image.
#' @param width Width in inches for saved image (default: 14).
#' @param height Height in inches for saved image (default: 12).
#' @param layout Character. Layout style: "grid" (2x3), "vertical" (6x1), or "paired" (3x2). Default: "paired".
#'
#' @return A patchwork object combining all theme previews (invisibly if saved).
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Display theme preview
#' preview_cpal_themes()
#'
#' # Save theme preview to file
#' preview_cpal_themes(save_path = "theme_comparison.png")
#'
#' # Use different layout
#' preview_cpal_themes(layout = "vertical")
#' }
preview_cpal_themes <- function(data = NULL, save_path = NULL, width = 14, height = 12,
                                layout = c("paired", "grid", "vertical")) {
  # Check for patchwork
  if (!requireNamespace("patchwork", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg patchwork} is required. Install with: install.packages('patchwork')")
  }

  layout <- match.arg(layout)

  # Create sample data if not provided
  if (is.null(data)) {
    set.seed(42)
    data <- data.frame(
      x = rep(1:5, each = 3),
      y = c(2, 3, 2.5, 4, 5, 4.5, 3, 4, 3.5, 5, 6, 5.5, 4, 5, 4.5) + stats::rnorm(15, 0, 0.3),
      group = rep(c("Group A", "Group B", "Group C"), 5)
    )
  }

  # Create base plot function with consistent legend handling
  make_plot <- function(theme_func, title, show_legend = TRUE) {
    p <- ggplot2::ggplot(data, ggplot2::aes(x = x, y = y, color = group)) +
      ggplot2::geom_line(linewidth = 1) +
      ggplot2::geom_point(size = 3) +
      scale_color_cpal("main_3") +
      ggplot2::labs(
        title = title,
        x = "Time Period",
        y = "Value",
        color = "Category"
      ) +
      theme_func(base_size = 11)

    if (!show_legend) {
      p <- p + ggplot2::theme(legend.position = "none")
    }
    p
  }

  # Create all theme variants - hide legend on right column to prevent overlap
  p_default <- make_plot(theme_cpal, "theme_cpal() - Default", show_legend = TRUE)
  p_minimal <- make_plot(theme_cpal_minimal, "theme_cpal_minimal()", show_legend = FALSE)
  p_classic <- make_plot(theme_cpal_classic, "theme_cpal_classic()", show_legend = TRUE)
  p_dark <- make_plot(theme_cpal_dark, "theme_cpal_dark()", show_legend = FALSE)
  p_print <- make_plot(theme_cpal_print, "theme_cpal_print()", show_legend = TRUE)

  # Create a map-style plot with matching aesthetics
  p_map <- ggplot2::ggplot(data, ggplot2::aes(x = x, y = y, fill = group)) +
    ggplot2::geom_tile(width = 0.8, height = 0.5) +
    scale_fill_cpal("main_3") +
    ggplot2::labs(
      title = "theme_cpal_map()",
      fill = "Category"
    ) +
    theme_cpal_map(base_size = 11) +
    ggplot2::theme(legend.position = "none")

  # Arrange based on layout
  if (layout == "paired") {
    # 3 rows, 2 columns - gives each chart more space
    combined <- (p_default + p_minimal) /
      (p_classic + p_dark) /
      (p_print + p_map) +
      patchwork::plot_layout(heights = c(1, 1, 1))
  } else if (layout == "grid") {
    # 2 rows, 3 columns - original layout
    combined <- (p_default + p_minimal + p_classic) /
      (p_dark + p_print + p_map)
  } else {
    # Vertical - all stacked
    combined <- p_default / p_minimal / p_classic / p_dark / p_print / p_map
    width <- 8
    height <- 20
  }

  # Add title annotation
  combined <- combined +
    patchwork::plot_annotation(
      title = "CPAL Theme Variants Comparison",
      subtitle = "Choose the theme that best fits your visualization context",
      theme = ggplot2::theme(
        plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5, color = "#004855"),
        plot.subtitle = ggplot2::element_text(size = 13, hjust = 0.5, color = "#666666"),
        plot.background = ggplot2::element_rect(fill = "white", color = NA)
      )
    )

  # Save if path provided
  if (!is.null(save_path)) {
    ggplot2::ggsave(save_path, combined, width = width, height = height, dpi = 300, bg = "white")
    cli::cli_alert_success("Theme preview saved to {.path {save_path}}")
    return(invisible(combined))
  }

  combined
}

# =============================================================================
# HIGHCHARTER THEME SWITCHING
# =============================================================================

#' CPAL Light Theme for Highcharter
#'
#' Returns a Highcharter theme configured with CPAL light mode colors.
#'
#' @return A Highcharter theme object
#' @export
#' @examples
#' \dontrun{
#' library(highcharter)
#' hchart(mtcars, "scatter", hcaes(wt, mpg)) %>%
#'   hc_add_theme(hc_theme_cpal_light())
#' }
hc_theme_cpal_light <- function() {
  if (!requireNamespace("highcharter", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg highcharter} is required. Install with: install.packages('highcharter')")
  }

  highcharter::hc_theme(
    chart = list(
      backgroundColor = "#FFFFFF",
      style = list(
        fontFamily = "Inter, Roboto, sans-serif"
      )
    ),
    title = list(
      style = list(
        color = "#004855",
        fontWeight = "bold",
        fontSize = "16px"
      )
    ),
    subtitle = list(
      style = list(
        color = "#666666",
        fontSize = "12px"
      )
    ),
    xAxis = list(
      gridLineColor = "#E8ECEE",
      lineColor = "#5C6B73",
      tickColor = "#5C6B73",
      labels = list(
        style = list(color = "#004855")
      ),
      title = list(
        style = list(color = "#555555")
      )
    ),
    yAxis = list(
      gridLineColor = "#E8ECEE",
      lineColor = "#5C6B73",
      tickColor = "#5C6B73",
      labels = list(
        style = list(color = "#444444")
      ),
      title = list(
        style = list(color = "#555555")
      )
    ),
    legend = list(
      itemStyle = list(
        color = "#222222"
      ),
      itemHoverStyle = list(
        color = "#004855"
      )
    ),
    tooltip = list(
      backgroundColor = "#FFFFFF",
      style = list(
        color = "#222222"
      )
    )
  )
}

#' CPAL Dark Theme for Highcharter
#'
#' Returns a Highcharter theme configured with CPAL dark mode colors.
#'
#' @return A Highcharter theme object
#' @export
#' @examples
#' \dontrun{
#' library(highcharter)
#' hchart(mtcars, "scatter", hcaes(wt, mpg)) %>%
#'   hc_add_theme(hc_theme_cpal_dark())
#' }
hc_theme_cpal_dark <- function() {
  if (!requireNamespace("highcharter", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg highcharter} is required. Install with: install.packages('highcharter')")
  }

  highcharter::hc_theme(
    chart = list(
      backgroundColor = "#1a1a1a",
      style = list(
        fontFamily = "Inter, Roboto, sans-serif"
      )
    ),
    title = list(
      style = list(
        color = "#f0f0f0",
        fontWeight = "bold",
        fontSize = "16px"
      )
    ),
    subtitle = list(
      style = list(
        color = "#bbbbbb",
        fontSize = "12px"
      )
    ),
    xAxis = list(
      gridLineColor = "#333333",
      lineColor = "#666666",
      tickColor = "#666666",
      labels = list(
        style = list(color = "#e0e0e0")
      ),
      title = list(
        style = list(color = "#bbbbbb")
      )
    ),
    yAxis = list(
      gridLineColor = "#333333",
      lineColor = "#666666",
      tickColor = "#666666",
      labels = list(
        style = list(color = "#999999")
      ),
      title = list(
        style = list(color = "#bbbbbb")
      )
    ),
    legend = list(
      itemStyle = list(
        color = "#f0f0f0"
      ),
      itemHoverStyle = list(
        color = "#FFFFFF"
      )
    ),
    tooltip = list(
      backgroundColor = "#2a2a2a",
      style = list(
        color = "#f0f0f0"
      )
    )
  )
}

#' Highcharter Theme Switcher for CPAL
#'
#' Returns the appropriate CPAL Highcharter theme based on the current mode.
#'
#' @param mode Character: "light" or "dark" (typically from input$dark_mode_toggle)
#' @return A Highcharter theme object
#' @export
#' @examples
#' \dontrun{
#' # In a Shiny server function:
#' output$my_chart <- renderHighchart({
#'   hchart(data, "scatter", hcaes(x, y)) %>%
#'     hc_add_theme(hc_theme_cpal_switch(input$dark_mode_toggle))
#' })
#' }
hc_theme_cpal_switch <- function(mode = "light") {
  if (is.null(mode) || mode == "light") {
    hc_theme_cpal_light()
  } else {
    hc_theme_cpal_dark()
  }
}