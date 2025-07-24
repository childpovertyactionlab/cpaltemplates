#' CPAL ggplot2 Theme
#'
#' A consistent theme for CPAL data visualizations based on organizational
#' style guidelines. Provides clean, accessible visualizations with
#' CPAL brand colors and typography.
#'
#' @param base_size Base font size (default: 11)
#' @param base_family Base font family (default: uses Inter if available)
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
theme_cpal <- function(base_size = 11,
                       base_family = "",
                       base_line_size = base_size / 22,
                       base_rect_size = base_size / 22,
                       style = c("default", "minimal", "classic", "dark"),
                       grid = c("horizontal", "vertical", "both", "none"),
                       axis_line = c("x", "y", "both", "none"),
                       axis_title = TRUE,
                       legend_position = "bottom") {

  style <- match.arg(style)
  # Handle logical grid values
  if (is.logical(grid)) {
    grid <- if (grid) "horizontal" else "none"
  }
  grid <- match.arg(grid, c("horizontal", "vertical", "both", "none"))
  axis_line <- match.arg(axis_line)

  # Load CPAL colors
  midnight <- "#004855"
  neutral <- "#EBEBEB"
  neutral_dark <- "#919191"  # Using gray for darker neutral
  axis_line_color <- "#4a4a4a"  # Much darker gray for axis lines

  # Set font family - try Inter first
  if (base_family == "") {
    base_family <- cpal_font_family()
  }

  # Start with theme_gray as base
  theme <- ggplot2::theme_gray(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  )

  # Define colors based on style
  if (style == "dark") {
    bg_color <- "#1a1a1a"
    # For dark theme, use lighter colors for text
    title_color <- "#f0f0f0"  # Light text for dark background
    text_color <- "#f0f0f0"
    grid_color <- "#333333"
    axis_text_color <- "#e0e0e0"
  } else {
    bg_color <- "white"
    title_color <- midnight  # Use midnight for titles
    text_color <- "#222222"
    grid_color <- neutral    # Light grey for grid
    axis_text_color <- midnight  # Midnight for x-axis labels
  }

  # Core theme modifications
  theme <- theme +
    ggplot2::theme(
      # Text elements
      text = ggplot2::element_text(
        family = base_family,
        colour = text_color,
        size = base_size,
        lineheight = 0.9
      ),

      # Title elements - Left aligned, bold, midnight color
      plot.title = ggplot2::element_text(
        size = base_size * 12 / 8.5,
        family = base_family,
        face = "bold",
        hjust = 0,  # Left aligned
        color = title_color,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 9.5 / 8.5,
        family = base_family,
        face = "plain",  # Not bold
        hjust = 0,  # Left aligned
        color = title_color,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 7 / 8.5,
        family = base_family,
        hjust = 1,
        margin = ggplot2::margin(t = base_size * 0.5),
        color = if(style == "dark") "#999999" else neutral_dark
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",

      # Axis titles
      axis.title = if (axis_title) {
        ggplot2::element_text(
          family = base_family,
          face = "italic",
          size = base_size,
          color = if(style == "dark") text_color else midnight
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

      # Axis text - Y axis: neutral/gray, bold, small; X axis: midnight, bold, larger
      axis.text.x = ggplot2::element_text(
        family = base_family,
        size = base_size * 1.1,  # Slightly larger
        face = "bold",
        color = if(style == "dark") axis_text_color else midnight
      ),
      axis.text.y = ggplot2::element_text(
        family = base_family,
        size = base_size * 0.9,  # Smaller
        face = "bold",
        color = if(style == "dark") "#999999" else neutral_dark
      ),

      # Axis ticks
      axis.ticks = ggplot2::element_line(
        color = if(style == "dark") "#666666" else neutral_dark
      ),

      # Panel elements
      panel.background = ggplot2::element_rect(fill = bg_color, color = NA),
      panel.border = ggplot2::element_blank(),

      # Plot background
      plot.background = ggplot2::element_rect(fill = bg_color, color = NA),

      # Legend
      legend.position = legend_position,
      legend.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(
        size = base_size * 9.5 / 8.5,
        family = base_family
      ),
      legend.title = ggplot2::element_text(
        size = base_size,
        face = "bold",
        color = if(style == "dark") title_color else midnight
      ),

      # Facets
      strip.background = ggplot2::element_rect(
        fill = if (style == "dark") "#2a2a2a" else neutral
      ),
      strip.text = ggplot2::element_text(
        family = base_family,
        face = "bold",
        size = base_size * 9.5 / 8.5,
        color = if(style == "dark") title_color else midnight,
        margin = ggplot2::margin(base_size * 0.3, base_size * 0.3,
                                 base_size * 0.3, base_size * 0.3)
      ),

      # Spacing
      plot.margin = ggplot2::margin(
        t = base_size,
        r = base_size,
        b = base_size,
        l = base_size
      )
    )

  # Handle grid preferences - default all off, then add based on preference
  theme <- theme +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    )

  # Add grid lines based on preference
  if (grid == "horizontal" || grid == "both") {
    theme <- theme +
      ggplot2::theme(
        panel.grid.major.y = ggplot2::element_line(
          color = grid_color,
          linewidth = 0.25  # Thin lines
        )
      )
  }

  if (grid == "vertical" || grid == "both") {
    theme <- theme +
      ggplot2::theme(
        panel.grid.major.x = ggplot2::element_line(
          color = grid_color,
          linewidth = 0.25  # Thin lines
        )
      )
  }

  # Handle axis lines - default all off
  theme <- theme +
    ggplot2::theme(
      axis.line = ggplot2::element_blank()
    )

  # Add axis lines based on preference - NOW WITH THINNER, DARKER LINES
  if (axis_line == "x" || axis_line == "both") {
    theme <- theme +
      ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(
          color = if(style == "dark") "#666666" else axis_line_color,
          size = 0.5  # Thinner line (was 1)
        )
      )
  }

  if (axis_line == "y" || axis_line == "both") {
    theme <- theme +
      ggplot2::theme(
        axis.line.y.left = ggplot2::element_line(
          color = if(style == "dark") "#666666" else axis_line_color,
          size = 0.5  # Thinner line (was 1)
        )
      )
  }

  # Style-specific adjustments
  if (style == "minimal") {
    theme <- theme +
      ggplot2::theme(
        axis.ticks = ggplot2::element_blank()
      )
  } else if (style == "classic") {
    # Classic always has both axis lines
    theme <- theme +
      ggplot2::theme(
        axis.line.x.bottom = ggplot2::element_line(
          color = if(style == "dark") "#666666" else axis_line_color,
          size = 0.5  # Thinner line
        ),
        axis.line.y.left = ggplot2::element_line(
          color = if(style == "dark") "#666666" else axis_line_color,
          size = 0.5  # Thinner line
        )
      )
  }

  return(theme)
}

#' Import Inter font from Google Fonts
#'
#' This function attempts to import the Inter font from Google Fonts
#' using the sysfonts and showtext packages.
#'
#' @return Logical indicating success
#' @export
import_inter_font <- function() {
  # Check if required packages are available
  if (!requireNamespace("sysfonts", quietly = TRUE)) {
    message("Package 'sysfonts' is required to import Google fonts.")
    message("Install with: install.packages('sysfonts')")
    return(invisible(FALSE))
  }

  if (!requireNamespace("showtext", quietly = TRUE)) {
    message("Package 'showtext' is required to use Google fonts.")
    message("Install with: install.packages('showtext')")
    return(invisible(FALSE))
  }

  # Check if Inter is already available
  if ("Inter" %in% sysfonts::font_families()) {
    message("Inter font already available")
    return(invisible(TRUE))
  }

  # Try to add Inter from Google Fonts
  tryCatch({
    sysfonts::font_add_google("Inter", "Inter")
    showtext::showtext_auto()
    message("Inter font successfully imported from Google Fonts")
    return(invisible(TRUE))
  }, error = function(e) {
    message("Could not import Inter font: ", e$message)
    message("Falling back to system fonts")
    return(invisible(FALSE))
  })
}

#' Helper function to determine available fonts
#' @keywords internal
cpal_font_family <- function() {
  # Check if Inter is available via showtext
  if (requireNamespace("sysfonts", quietly = TRUE)) {
    if ("Inter" %in% sysfonts::font_families()) {
      return("Inter")
    }
  }

  # Check system fonts
  sysname <- Sys.info()["sysname"]

  # Platform-specific checks
  if (sysname == "Windows") {
    # Check Windows fonts
    win_fonts <- names(grDevices::windowsFonts())
    if ("Inter" %in% win_fonts) return("Inter")
    return("Arial")
  } else if (sysname == "Darwin") {
    # On macOS, try Inter first (will fall back if not available)
    return("Inter")
  } else {
    # Linux/other
    return("sans")
  }
}

#' CPAL Theme Variants
#'
#' Convenience functions for common theme configurations
#'
#' @param ... Additional arguments passed to theme_cpal()
#' @name theme_cpal_variants
NULL

#' @rdname theme_cpal_variants
#' @export
theme_cpal_minimal <- function(...) {
  theme_cpal(style = "minimal", grid = "none", axis_line = "x", ...)
}

#' @rdname theme_cpal_variants
#' @export
theme_cpal_dark <- function(...) {
  theme_cpal(style = "dark", ...)
}

#' @rdname theme_cpal_variants
#' @export
theme_cpal_classic <- function(...) {
  theme_cpal(style = "classic", grid = "none", axis_line = "both", ...)
}

#' Child Poverty Action Lab [ggplot2] Theme for Print
#'
#' \code{theme_cpal_print} provides a [ggplot2] theme formatted according to the CPAL style guide for print, with sensible defaults.
#'
#' @param base_size Base font size (default is 8.5).
#' @param base_family Base font family (default is Inter if available).
#' @param base_line_size Base size for lines (default is 0.5).
#' @param base_rect_size Base size for rectangle elements (default is 0.5).
#' @param line_color Default line color (default is "#222222").
#' @param rect_fill Background color for rectangles (default is "#E7ECEE").
#' @param grid_color Grid line color (default is "#E7ECEE").
#' @import ggplot2
#' @md
#' @export
theme_cpal_print <- function(base_size = 8.5,
                             base_family = cpal_font_family(),
                             base_line_size = 0.5,
                             base_rect_size = 0.5,
                             line_color = "#222222",
                             rect_fill = "#E7ECEE",
                             grid_color = "#E7ECEE") {

  # Load CPAL colors
  midnight <- "#004855"
  neutral <- "#EBEBEB"
  neutral_dark <- "#919191"
  axis_line_color <- "#4a4a4a"  # Darker gray for axis

  half_line <- base_size / 2L
  ggplot2::theme(
    line = ggplot2::element_line(colour = line_color, linewidth = base_line_size),
    rect = ggplot2::element_rect(fill = rect_fill, colour = line_color, linewidth = base_rect_size),
    text = ggplot2::element_text(family = base_family, colour = line_color, size = base_size, lineheight = 0.9),
    # Plot attributes - Updated with new specifications
    plot.title = ggplot2::element_text(
      size = base_size * 12 / 8.5,
      family = base_family,
      face = "bold",
      color = midnight,
      hjust = 0
    ),
    plot.subtitle = ggplot2::element_text(
      size = base_size * 9.5 / 8.5,
      family = base_family,
      color = midnight,
      hjust = 0
    ),
    plot.caption = ggplot2::element_text(size = base_size * 7 / 8.5, family = base_family),
    plot.tag = ggplot2::element_text(size = base_size * 1.5, family = base_family, face = "bold"),
    plot.tag.position = "topleft",
    plot.title.position = "plot",
    plot.caption.position = "plot",
    # Axis attributes - Updated
    axis.text.x = ggplot2::element_text(
      family = base_family,
      size = base_size * 1.1,
      face = "bold",
      color = midnight
    ),
    axis.text.y = ggplot2::element_text(
      family = base_family,
      size = base_size * 0.9,
      face = "bold",
      color = neutral_dark
    ),
    axis.title = ggplot2::element_text(
      family = base_family,
      face = "italic",
      size = base_size,
      color = midnight
    ),
    axis.ticks = ggplot2::element_line(color = neutral_dark),
    axis.line.x.bottom = ggplot2::element_line(colour = axis_line_color, linewidth = 0.5),  # Thinner, darker
    # Legend attributes
    legend.position = "bottom",
    legend.background = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = base_size * 9.5 / 8.5, family = base_family),
    legend.title = ggplot2::element_text(
      size = base_size,
      face = "bold",
      color = midnight
    ),
    # Panel attributes
    panel.background = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(colour = neutral, linewidth = 0.25),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    # Facet strip attributes
    strip.background = ggplot2::element_rect(fill = neutral),
    strip.text = ggplot2::element_text(
      family = base_family,
      face = "bold",
      size = base_size * 9.5 / 8.5,
      color = midnight
    )
  )
}

#' Child Poverty Action Lab [ggplot2] Theme for Maps
#'
#' \code{theme_cpal_map} provides a [ggplot2] theme formatted according to the Child Poverty Action Lab style guide for maps, with sensible defaults for map visualizations.
#'
#' @param scale A string specifying the type of legend. "continuous" creates a vertical legend on the right of the map, while "discrete" creates a horizontal legend above the map.
#' @param base_size Base font size for the theme (default is 8.5).
#' @param base_family Base font family for the theme (default is Inter if available).
#' @param base_line_size Base line size for the theme (default is 0.5).
#' @param base_rect_size Base rectangle size for the theme (default is 0.5).
#'
#' @import ggplot2
#' @md
#' @export
theme_cpal_map <- function(scale = "continuous",
                           base_size = 8.5,
                           base_family = cpal_font_family(),
                           base_line_size = 0.5,
                           base_rect_size = 0.5) {

  # Load CPAL colors
  midnight <- "#004855"

  # Start with the CPAL print theme as a base
  gg <- theme_cpal_print(
    base_size = base_size,
    base_family = base_family,
    base_line_size = base_line_size,
    base_rect_size = base_rect_size
  )

  # Customize for map style visuals
  gg <- gg + ggplot2::theme(
    plot.background = ggplot2::element_rect(fill = "#FFFFFF"),
    panel.background = ggplot2::element_rect(fill = "#FFFFFF"),
    axis.text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    axis.title = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    legend.margin = ggplot2::margin(t = 6L, r = 6L, b = 6L, l = 6L, unit = "pt"),
    # Ensure titles use midnight color even for maps
    plot.title = ggplot2::element_text(
      size = base_size * 12 / 8.5,
      face = "bold",
      color = midnight,
      hjust = 0
    ),
    plot.subtitle = ggplot2::element_text(
      size = base_size * 9.5 / 8.5,
      color = midnight,
      hjust = 0
    )
  )

  # Adjust legend based on scale type
  if (scale == "continuous") {
    gg <- gg + ggplot2::theme(
      legend.position = "right",
      legend.direction = "vertical",
      legend.title = ggplot2::element_text(
        size = base_size,
        color = midnight,
        face = "bold"
      )
    )
  } else if (scale == "discrete") {
    gg <- gg + ggplot2::theme(
      legend.position = "top",
      legend.direction = "horizontal",
      legend.title = ggplot2::element_text(
        size = base_size,
        color = midnight,
        face = "bold"
      )
    )
  } else {
    stop('Invalid "scale" argument. Valid options are "continuous" or "discrete".')
  }

  return(gg)
}

#' Set CPAL Theme as Default
#'
#' Sets theme_cpal() as the default ggplot2 theme for the session
#'
#' @param ... Arguments passed to theme_cpal()
#' @export
set_theme_cpal <- function(...) {
  ggplot2::theme_set(theme_cpal(...))
}

#' Setup CPAL fonts for interactive plots
#'
#' Helper function to register Inter font for ggiraph compatibility
#' This should be called before creating interactive plots
#'
#' @param force_register Logical. Force re-registration of fonts (default: FALSE)
#' @return Logical indicating success
#' @export
setup_cpal_fonts_interactive <- function(force_register = FALSE) {
  success <- FALSE

  # Check if gdtools is available for font registration
  if (!requireNamespace("gdtools", quietly = TRUE)) {
    message("Package 'gdtools' is recommended for interactive font support.")
    message("Install with: install.packages('gdtools')")
    return(FALSE)
  }

  if (!requireNamespace("systemfonts", quietly = TRUE)) {
    message("Package 'systemfonts' is required for font detection.")
    message("Install with: install.packages('systemfonts')")
    return(FALSE)
  }

  tryCatch({
    # Check if Inter is already registered
    if (!force_register) {
      registered_fonts <- gdtools::gfonts()
      if ("Inter" %in% registered_fonts) {
        message("Inter font already registered for interactive plots")
        return(TRUE)
      }
    }

    # Try to register Inter from Google Fonts
    gdtools::register_gfont("Inter")
    message("✅ Successfully registered Inter font for interactive plots")
    success <- TRUE

  }, error = function(e) {
    # Fallback: try to register system Inter font
    tryCatch({
      available_fonts <- systemfonts::system_fonts()
      inter_fonts <- available_fonts[grepl("Inter", available_fonts$family, ignore.case = TRUE), ]

      if (nrow(inter_fonts) > 0) {
        # Register the first Inter font found
        systemfonts::register_font(
          name = "Inter",
          plain = inter_fonts$path[1]
        )
        message("✅ Registered system Inter font for interactive plots")
        success <- TRUE
      } else {
        message("ℹ️  Inter font not found. Interactive plots will use Arial fallback.")
        message("   You can install Inter font system-wide or use Google Fonts integration.")
      }
    }, error = function(e2) {
      message("⚠️  Could not register Inter font: ", e2$message)
      message("   Interactive plots will use Arial fallback.")
    })
  })

  return(success)
}

#' Import and setup all CPAL fonts
#'
#' Comprehensive font setup for both regular plots (showtext) and interactive plots (ggiraph)
#'
#' @param setup_interactive Logical. Also setup fonts for interactive plots (default: TRUE)
#' @return Logical indicating success
#' @export
import_cpal_fonts <- function(setup_interactive = TRUE) {
  # Import Inter for regular plots
  regular_success <- import_inter_font()

  # Setup fonts for interactive plots
  interactive_success <- TRUE
  if (setup_interactive) {
    interactive_success <- setup_cpal_fonts_interactive()
  }

  if (regular_success && interactive_success) {
    message("🎉 All CPAL fonts ready for both regular and interactive plots!")
  } else if (regular_success) {
    message("✅ CPAL fonts ready for regular plots. Interactive plots will use fallback fonts.")
  } else {
    message("⚠️  Using fallback fonts for all plots.")
  }

  return(regular_success && interactive_success)
}
