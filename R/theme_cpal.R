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
                       legend_position = "bottom") {

  style <- match.arg(style)

  # Handle logical grid values (for backward compatibility)
  if (is.logical(grid)) {
    grid <- if (grid) "horizontal" else "none"
  }
  grid <- match.arg(grid, c("horizontal", "vertical", "both", "none"))
  axis_line <- match.arg(axis_line)

  # CPAL color palette
  midnight <- "#004855"
  neutral <- "#EBEBEB"
  neutral_dark <- "#919191"
  axis_line_color <- "#4a4a4a"

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

  # Style-specific colors
  if (style == "dark") {
    bg_color <- "#1a1a1a"
    title_color <- "#f0f0f0"
    text_color <- "#f0f0f0"
    grid_color <- "#333333"
    axis_text_color <- "#e0e0e0"
  } else {
    bg_color <- "white"
    title_color <- midnight
    text_color <- "#222222"
    grid_color <- neutral
    axis_text_color <- midnight
  }

  # Apply the main theme customizations
  theme <- theme + ggplot2::theme(
    # Base text styling
    text = ggplot2::element_text(
      family = base_family,
      colour = text_color,
      size = base_size,
      lineheight = 0.9
    ),

    # Plot titles and labels
    plot.title = ggplot2::element_text(
      size = base_size * 12/8.5,
      family = base_family,
      face = "bold",
      hjust = 0,
      color = title_color,
      margin = ggplot2::margin(b = base_size * 0.5)
    ),
    plot.subtitle = ggplot2::element_text(
      size = base_size * 9.5/8.5,
      family = base_family,
      face = "plain",
      hjust = 0,
      color = title_color,
      margin = ggplot2::margin(b = base_size * 0.5)
    ),
    plot.caption = ggplot2::element_text(
      size = base_size * 7/8.5,
      family = base_family,
      hjust = 1,
      margin = ggplot2::margin(t = base_size * 0.5),
      color = if (style == "dark") "#999999" else neutral_dark
    ),
    plot.title.position = "plot",
    plot.caption.position = "plot",

    # Axis styling
    axis.title = if (axis_title) {
      ggplot2::element_text(
        family = base_family,
        face = "italic",
        size = base_size,
        color = if (style == "dark") text_color else midnight
      )
    } else {
      ggplot2::element_blank()
    },
    axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = base_size * 0.5)),
    axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = base_size * 0.5)),
    axis.text.x = ggplot2::element_text(
      family = base_family,
      size = base_size * 1.1,
      face = "bold",
      color = if (style == "dark") axis_text_color else midnight
    ),
    axis.text.y = ggplot2::element_text(
      family = base_family,
      size = base_size * 0.9,
      face = "bold",
      color = if (style == "dark") "#999999" else neutral_dark
    ),
    axis.ticks = ggplot2::element_line(
      color = if (style == "dark") "#666666" else neutral_dark
    ),

    # Panel styling
    panel.background = ggplot2::element_rect(fill = bg_color, color = NA),
    panel.border = ggplot2::element_blank(),
    plot.background = ggplot2::element_rect(fill = bg_color, color = NA),

    # Legend styling - IMPROVED with wider continuous legends
    legend.position = legend_position,
    legend.background = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(
      size = base_size * 9.5/8.5,
      family = base_family
    ),
    legend.title = ggplot2::element_text(
      size = base_size,
      face = "bold",
      color = if (style == "dark") title_color else midnight
    ),
    # NEW: Wider legends for continuous scales
    legend.key.width = ggplot2::unit(base_size * 2, "pt"),
    legend.key.height = ggplot2::unit(base_size * 0.8, "pt"),

    # Facet styling
    strip.background = ggplot2::element_rect(
      fill = if (style == "dark") "#2a2a2a" else neutral
    ),
    strip.text = ggplot2::element_text(
      family = base_family,
      face = "bold",
      size = base_size * 9.5/8.5,
      color = if (style == "dark") title_color else midnight,
      margin = ggplot2::margin(
        base_size * 0.3, base_size * 0.3,
        base_size * 0.3, base_size * 0.3
      )
    ),

    # Plot margins
    plot.margin = ggplot2::margin(
      t = base_size, r = base_size,
      b = base_size, l = base_size
    )
  )

  # Grid lines (initially remove all)
  theme <- theme + ggplot2::theme(
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank()
  )

  # Add back specific grid lines based on grid parameter
  if (grid == "horizontal" || grid == "both") {
    theme <- theme + ggplot2::theme(
      panel.grid.major.y = ggplot2::element_line(
        color = grid_color,
        linewidth = 0.25
      )
    )
  }
  if (grid == "vertical" || grid == "both") {
    theme <- theme + ggplot2::theme(
      panel.grid.major.x = ggplot2::element_line(
        color = grid_color,
        linewidth = 0.25
      )
    )
  }

  # Axis lines (initially remove all)
  theme <- theme + ggplot2::theme(axis.line = ggplot2::element_blank())

  # Add back specific axis lines based on axis_line parameter
  if (axis_line == "x" || axis_line == "both") {
    theme <- theme + ggplot2::theme(
      axis.line.x.bottom = ggplot2::element_line(
        color = if (style == "dark") "#666666" else axis_line_color,
        linewidth = 0.5
      )
    )
  }
  if (axis_line == "y" || axis_line == "both") {
    theme <- theme + ggplot2::theme(
      axis.line.y.left = ggplot2::element_line(
        color = if (style == "dark") "#666666" else axis_line_color,
        linewidth = 0.5
      )
    )
  }

  # Style-specific modifications
  if (style == "minimal") {
    theme <- theme + ggplot2::theme(
      axis.ticks = ggplot2::element_blank()
    )
  } else if (style == "classic") {
    theme <- theme + ggplot2::theme(
      axis.line.x.bottom = ggplot2::element_line(
        color = if (style == "dark") "#666666" else axis_line_color,
        linewidth = 0.5
      ),
      axis.line.y.left = ggplot2::element_line(
        color = if (style == "dark") "#666666" else axis_line_color,
        linewidth = 0.5
      )
    )
  }

  return(theme)
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
        color = "#919191"
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

#' Use Shiny Theme
#'
#' Apply CPAL theming to Shiny applications for consistent branding
#' across web applications and static visualizations.
#'
#' @param theme CPAL theme to use: "default", "dark", "minimal", "classic" (default: "default")
#' @param base_size Base font size (default: 16)
#'
#' @return CSS styling for Shiny applications
#' @export
use_shiny_theme <- function(theme = "default", base_size = 16) {
  # Define color schemes
  themes <- list(
    default = list(
      primary = "#004855",
      secondary = "#FF6B35",
      background = "#FFFFFF",
      text = "#222222"
    ),
    dark = list(
      primary = "#004855",
      secondary = "#FF6B35",
      background = "#1a1a1a",
      text = "#f0f0f0"
    ),
    minimal = list(
      primary = "#004855",
      secondary = "#FF6B35",
      background = "#FFFFFF",
      text = "#222222"
    ),
    classic = list(
      primary = "#004855",
      secondary = "#FF6B35",
      background = "#FFFFFF",
      text = "#222222"
    )
  )

  colors <- themes[[theme]] %||% themes[["default"]]

  # Generate CSS with improved font sizing
  css <- sprintf("
    body {
      font-family: 'Inter', 'Roboto', sans-serif;
      font-size: %dpx;
      background-color: %s;
      color: %s;
    }
    .navbar { background-color: %s !important; }
    .btn-primary {
      background-color: %s;
      border-color: %s;
    }
    .btn-primary:hover {
      background-color: %s;
      border-color: %s;
    }
    .selectize-input {
      font-size: %dpx;
      border-color: %s;
    }
    .form-control {
      font-size: %dpx;
      border-color: %s;
    }
    h1, h2, h3, h4, h5, h6 {
      color: %s;
      font-weight: bold;
    }
  ",
                 base_size,              # body font-size
                 colors$background,      # background-color
                 colors$text,           # color
                 colors$primary,        # navbar background
                 colors$primary,        # btn-primary background
                 colors$primary,        # btn-primary border
                 colors$secondary,      # btn-primary:hover background
                 colors$secondary,      # btn-primary:hover border
                 base_size * 0.9,       # selectize font-size (slightly smaller)
                 colors$primary,        # selectize border
                 base_size * 0.9,       # form-control font-size (slightly smaller)
                 colors$primary,        # form-control border
                 colors$primary         # heading color
  )

  return(css)
}
