
#' Save CPAL-styled plots
#'
#' Save ggplot2 plots with standard CPAL dimensions and settings
#'
#' @param plot ggplot object to save
#' @param filename Output filename
#' @param size Size preset: "default", "slide", "half", "third", or custom c(width, height) in inches
#' @param dpi Resolution in dots per inch (default: 300)
#' @param bg Background color (default: "white")
#' @param ... Additional arguments passed to ggsave()
#'
#' @return Invisible NULL (side effect: saves plot to file)
#' @export
#' @examples
#' \dontrun{
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   theme_cpal()
#'
#' # Save with default dimensions
#' save_cpal_plot(p, "my_plot.png")
#'
#' # Save for slides
#' save_cpal_plot(p, "slide_plot.png", size = "slide")
#'
#' # Custom dimensions
#' save_cpal_plot(p, "custom_plot.png", size = c(10, 6))
#' }
save_cpal_plot <- function(plot,
                          filename,
                          size = "default",
                          dpi = 300,
                          bg = "white",
                          ...) {

  # Define standard sizes (in inches)
  sizes <- list(
    default = c(8, 5),      # Standard plot
    slide = c(10, 5.625),   # 16:9 slide
    half = c(4, 3),         # Half-width for reports
    third = c(2.5, 2),      # Third-width for dashboards
    square = c(5, 5),       # Square plots
    wide = c(12, 4),        # Wide banner plots
    tall = c(5, 8)          # Tall infographic style
  )

  # Get dimensions
  if (is.character(size)) {
    if (!size %in% names(sizes)) {
      stop("Size must be one of: ", paste(names(sizes), collapse = ", "),
           " or a numeric vector c(width, height)")
    }
    dims <- sizes[[size]]
  } else if (is.numeric(size) && length(size) == 2) {
    dims <- size
  } else {
    stop("Size must be a preset name or numeric vector c(width, height)")
  }

  # Save plot
  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    width = dims[1],
    height = dims[2],
    dpi = dpi,
    bg = bg,
    ...
  )

  message("Plot saved: ", filename, " (", dims[1], "x", dims[2], " inches at ", dpi, " dpi)")
  invisible(NULL)
}

#' Create CPAL-branded color/fill scales
#'
#' These functions provide additional options beyond the basic scale_color_cpal()
#' and scale_fill_cpal() for specific use cases.
#'
#' @return A ggplot2 scale object for continuous or discrete color/fill mappings
#' @name scale_cpal_extended
NULL

#' @rdname scale_cpal_extended
#' @param palette Palette name or custom colors
#' @param reverse Reverse the palette order
#' @param ... Additional arguments passed to scale functions
#' @export
scale_color_cpal_c <- function(palette = "sequential_teal", reverse = FALSE, ...) {
  pal <- cpal_palette(palette, reverse = reverse)
  # Note: cpal_palette is now fixed to return unname(colors)
  ggplot2::scale_color_gradientn(colors = pal, ...)
}

#' @rdname scale_cpal_extended
#' @export
scale_fill_cpal_c <- function(palette = "sequential_teal", reverse = FALSE, ...) {
  pal <- cpal_palette(palette, reverse = reverse)
  # Note: cpal_palette is now fixed to return unname(colors)
  ggplot2::scale_fill_gradientn(colors = pal, ...)
}

#' @rdname scale_cpal_extended
#' @export
scale_color_cpal_d <- function(palette = "categorical", reverse = FALSE, ...) {
  pal <- cpal_palette(palette, reverse = reverse)
  # Note: cpal_palette is now fixed to return unname(colors)
  ggplot2::scale_color_manual(values = pal, ...)
}

#' @rdname scale_cpal_extended
#' @export
scale_fill_cpal_d <- function(palette = "categorical", reverse = FALSE, ...) {
  pal <- cpal_palette(palette, reverse = reverse)
  # Note: cpal_palette is now fixed to return unname(colors)
  ggplot2::scale_fill_manual(values = pal, ...)
}

#' Add CPAL logo to plots
#'
#' Add the CPAL logo to a ggplot2 plot in a specified position.
#' Automatically detects dark themes and uses appropriate logo color.
#'
#' @param plot ggplot object
#' @param position Position for logo: "top-right", "top-left", "bottom-right", "bottom-left"
#' @param size Logo size as proportion of plot (default: 0.08)
#' @param logo_path Path to logo file (uses package default if NULL)
#'
#' @return ggplot object with logo
#' @export
add_cpal_logo <- function(plot,
                          position = "top-right",
                          size = 0.09,
                          logo_path = NULL) {

  # Check if cowplot is available
  if (!requireNamespace("cowplot", quietly = TRUE)) {
    message("Package 'cowplot' needed for logo functionality. Please install it.")
    return(plot)
  }

  # Check if magick is available for image handling
  if (!requireNamespace("magick", quietly = TRUE)) {
    message("Package 'magick' needed for logo functionality. Please install it.")
    return(plot)
  }

  # Determine which logo to use if not specified
  if (is.null(logo_path)) {
    # Detect if this is a dark theme by checking plot background
    plot_bg <- "white"  # default

    # Try to extract theme background color
    if (!is.null(plot$theme)) {
      if (!is.null(plot$theme$plot.background)) {
        if (!is.null(plot$theme$plot.background$fill)) {
          plot_bg <- plot$theme$plot.background$fill
        }
      }
      if (!is.null(plot$theme$panel.background)) {
        if (!is.null(plot$theme$panel.background$fill)) {
          panel_bg <- plot$theme$panel.background$fill
          # If panel background is dark, use that as indicator
          if (panel_bg %in% c("#1a1a1a", "#2a2a2a", "#333333", "black", "#000000")) {
            plot_bg <- panel_bg
          }
        }
      }
    }

    # Choose logo based on background darkness
    if (plot_bg %in% c("#1a1a1a", "#2a2a2a", "#333333", "black", "#000000")) {
      # Dark background - use white logo
      logo_path <- get_cpal_asset("CPAL_Icon_White.png", "icons")
    } else {
      # Light background - use teal logo
      logo_path <- get_cpal_asset("CPAL_Icon_Teal.png", "icons")
    }

    # Fallback if asset function not available or file not found
    if (is.null(logo_path) || !file.exists(logo_path)) {
      # Try system.file approach
      if (plot_bg %in% c("#1a1a1a", "#2a2a2a", "#333333", "black", "#000000")) {
        logo_path <- system.file("assets/icons/CPAL_Icon_White.png", package = "cpaltemplates")
      } else {
        logo_path <- system.file("assets/icons/CPAL_Icon_Teal.png", package = "cpaltemplates")
      }

      # Final fallback to any available logo
      if (!file.exists(logo_path)) {
        logo_path <- system.file("assets", "cpal_logo.png", package = "cpaltemplates")
      }
    }
  }

  # Check if logo file exists
  if (!file.exists(logo_path)) {
    message("Logo file not found. Returning plot without logo.")
    message("Searched for: ", logo_path)
    return(plot)
  }

  # Read logo
  logo <- magick::image_read(logo_path)

  # Determine position coordinates (updated default to top-right)
  positions <- list(
    "top-right" = c(0.95, 0.97),
    "top-left" = c(0.05, 0.97),
    "bottom-right" = c(0.95, 0.03),
    "bottom-left" = c(0.05, 0.03)
  )

  if (!position %in% names(positions)) {
    stop("Position must be one of: ", paste(names(positions), collapse = ", "))
  }

  coords <- positions[[position]]

  # Adjust for alignment
  hjust <- ifelse(grepl("right", position), 1, 0)
  vjust <- ifelse(grepl("top", position), 1, 0)

  # Add logo using cowplot
  cowplot::ggdraw() +
    cowplot::draw_plot(plot) +
    cowplot::draw_image(
      logo,
      x = coords[1],
      y = coords[2],
      hjust = hjust,
      vjust = vjust,
      width = size,
      height = size
    )
}

#' Create a formatted table with CPAL styling
#'
#' This is a wrapper around gt that applies CPAL styling automatically
#'
#' @param data Data frame to display as table
#' @param title Optional table title
#' @param subtitle Optional table subtitle
#' @param font_family Font family to use (default: "Inter")
#' @param ... Additional arguments passed to gt()
#'
#' @return gt table object
#' @export
cpal_table <- function(data, title = NULL, subtitle = NULL,
                       font_family = cpal_font_family(), ...) {

  if (!requireNamespace("gt", quietly = TRUE)) {
    stop("Package 'gt' needed for table functionality. Please install it.")
  }

  # Create base table
  tbl <- gt::gt(data, ...)

  # Add title and subtitle if provided
  if (!is.null(title) || !is.null(subtitle)) {
    tbl <- tbl |>
      gt::tab_header(
        title = title,
        subtitle = subtitle
      )
  }

  # Apply CPAL styling
  tbl <- tbl |>
    gt::tab_options(
      # Overall table styling
      table.font.names = c(font_family, "Arial", "sans-serif"),
      table.font.size = gt::px(14),

      # Header styling
      heading.title.font.size = gt::px(20),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(16),

      # Column labels
      column_labels.font.weight = "bold",
      column_labels.background.color = "#004855",  # midnight
      column_labels.padding = gt::px(10),

      # Data rows
      table_body.hlines.color = "#E7ECEE",
      table_body.border.bottom.color = "#004855",
      table_body.border.bottom.width = gt::px(2),

      # Row striping
      row.striping.include_stub = FALSE,
      row.striping.include_table_body = TRUE,
      row.striping.background_color = "#f5f5f5",

      # Footer
      source_notes.font.size = gt::px(12),
      source_notes.padding = gt::px(10)
    )

  return(tbl)
}

#' Check plot accessibility
#'
#' Performs basic accessibility checks on a ggplot object
#'
#' @param plot ggplot object to check
#' @param verbose Print detailed results (default: TRUE)
#'
#' @return List with accessibility check results
#' @export
check_plot_accessibility <- function(plot, verbose = TRUE) {

  results <- list(
    color_contrast = NULL,
    color_blind_safe = NULL,
    text_size = NULL,
    alt_text = NULL
  )

  # Extract plot components
  build <- ggplot2::ggplot_build(plot)

  # Check text size
  theme_elements <- plot$theme
  base_size <- theme_elements$text$size
  if (is.null(base_size)) base_size <- 11  # ggplot2 default

  results$text_size <- list(
    base_size = base_size,
    adequate = base_size >= 10,
    recommendation = if(base_size < 10) "Consider increasing base_size to at least 10pt" else "Text size is adequate"
  )

  # Check if colorblind-safe palette is being used
  # This is a simplified check - in practice you'd want more sophisticated checking
  colors_used <- unique(unlist(lapply(build$data, function(x) {
    c(x$colour, x$fill)
  })))
  colors_used <- colors_used[!is.na(colors_used)]

  # Simple check if using CPAL palettes (which are designed to be colorblind-safe)
  cpal_colors_all <- unlist(lapply(list(cpal_palettes_sequential, cpal_palettes_diverging, cpal_palettes_categorical), unname))
  using_cpal <- any(colors_used %in% cpal_colors_all)

  results$color_blind_safe <- list(
    using_cpal_palette = using_cpal,
    recommendation = if(!using_cpal) "Consider using CPAL color palettes which are colorblind-safe" else "Using CPAL palette"
  )

  # Print results if verbose
  if (verbose) {
    cat("=== CPAL Plot Accessibility Check ===\n\n")

    cat("Text Size:\n")
    cat("  Base size:", results$text_size$base_size, "pt\n")
    cat("  Status:", ifelse(results$text_size$adequate, "OK PASS", "FAIL FAIL"), "\n")
    cat("  ", results$text_size$recommendation, "\n\n")

    cat("Color Accessibility:\n")
    cat("  Using CPAL palette:", ifelse(results$color_blind_safe$using_cpal_palette, "OK Yes", "NO No"), "\n")
    cat("  ", results$color_blind_safe$recommendation, "\n\n")

    cat("Recommendations:\n")
    cat("  - Add descriptive titles and captions\n")
    cat("  - Consider using shapes/patterns in addition to colors\n")
    cat("  - Test with colorblindness simulators\n")
    cat("  - Provide alternative text descriptions for web/document use\n")
  }

  invisible(results)
}

