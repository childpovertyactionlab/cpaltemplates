
#' @importFrom grDevices colorRampPalette
#' @importFrom graphics axis barplot image mtext par plot.new rect text

#' CPAL Color Palettes
#'
#' Official color palettes for Child Poverty Action Lab data visualizations
#' Based on CPAL Data Visualization Guidelines
#'
#' @name cpal_colors
#' @rdname cpal_colors
NULL

# Primary Colors ----

#' CPAL Primary Colors
#'
#' Core brand colors for CPAL visualizations
#' @export
cpal_colors_primary <- c(
  "midnight" = "#004855",  # Midnight
  "teal"     = "#008097",  # Teal
  "pink"     = "#C3257B",  # Pink
  "orange"   = "#ED683F",  # Orange
  "gold"     = "#AB8C01"   # Gold
)

# Extended Palette ----

#' CPAL Extended Color Palette
#'
#' Extended colors including additional shades for data visualization
#' @export
cpal_colors_extended <- c(
  # Brand Colors
  "midnight"      = "#004855",
  "teal"          = "#008097",
  "pink"          = "#C3257B",
  "orange"        = "#ED683F",
  "gold"          = "#AB8C01",

  # Grays (from categorical palette)
  "gray"          = "#919191",
  "gray_blue"     = "#798AA1",

  # Additional teal shades from single-hue sequential
  "teal_lightest" = "#D8EFF4",
  "teal_lighter"  = "#C0E7EE",
  "teal_light"    = "#95CFDA",
  "teal_mid"      = "#47ACBD",

  # Additional shades from diverging palette
  "pink_light"    = "#B888AC",
  "neutral"       = "#EBEBEB",
  "teal_blue"     = "#6B9BDE",

  # Colors from multi-hue sequential
  "yellow"        = "#E5CB50",
  "green_teal"    = "#76A772",
  "teal_dark"     = "#025968"
)

# Sequential Palettes ----

#' CPAL Sequential Color Palettes
#'
#' Sequential palettes for continuous data
#' @export
cpal_palettes_sequential <- list(
  # Single-hue sequential (from Image 3)
  teal_seq_4 = c("#95CFDA", "#47ACBD", "#008097", "#004855"),
  teal_seq_5 = c("#C0E7EE", "#95CFDA", "#47ACBD", "#008097", "#004855"),
  teal_seq_6 = c("#D8EFF4", "#C0E7EE", "#95CFDA", "#47ACBD", "#008097", "#004855"),

  # Multi-hue sequential (from Image 2)
  yellow_teal_seq_4 = c("#E5CB50", "#499881", "#016678", "#004855"),
  yellow_teal_seq_5 = c("#E5CB50", "#76A772", "#018097", "#025968", "#043037"),
  yellow_teal_seq_6 = c("#E5CB50", "#82AA6F", "#2A8E8A", "#017084", "#03515E", "#004855")
)

# Diverging Palettes ----

#' CPAL Diverging Color Palettes
#'
#' Diverging palettes for data with a meaningful midpoint
#' @export
cpal_palettes_diverging <- list(
  # Pink to Teal diverging (from Image 1)
  pink_teal_3 = c("#C3257B", "#EBEBEB", "#008097"),
  pink_teal_5 = c("#C3257B", "#BB8AAC", "#EBEBEB", "#69969E", "#008097"),
  pink_teal_6 = c("#C3257B", "#B979A2", "#C2BBCB", "#A0BFC5", "#588993", "#008097")
)

# Categorical Palettes ----

#' CPAL Categorical Color Palettes
#'
#' Palettes for categorical data
#' @export
cpal_palettes_categorical <- list(
  # Brand colors for categories
  main = c("#004855", "#008097", "#C3257B", "#ED683F", "#AB8C01"),

  # With gray for additional category
  main_gray = c("#004855", "#008097", "#C3257B", "#ED683F", "#AB8C01", "#798AA1"),

  # 2-color palettes
  blues = c("#004855", "#008097"),
  compare = c("#919191", "#008097"),

  # Smaller sets
  main_3 = c("#004855", "#008097", "#C3257B"),
  main_4 = c("#004855", "#008097", "#C3257B", "#ED683F")
)

# Helper Functions ----

#' Get CPAL Colors
#'
#' Access CPAL color palettes
#'
#' @param palette Character. Name of palette or specific colors
#' @param n Integer. Number of colors needed (optional)
#' @param reverse Logical. Reverse the order of colors?
#' @return Character vector of hex colors
#' @export
#' @examples
#' # Get primary colors
#' cpal_colors()
#'
#' # Get specific colors
#' cpal_colors("teal")
#' cpal_colors(c("teal", "orange"))
#'
#' # Get a sequential palette
#' cpal_colors("teal_seq_5")
#'
#' # Get n colors from a palette
#' cpal_colors("main", n = 3)
cpal_colors <- function(palette = "primary", n = NULL, reverse = FALSE) {

  # If requesting specific colors by name
  if (all(palette %in% names(cpal_colors_extended))) {
    return(cpal_colors_extended[palette])
  }

  # Get the requested palette
  pal <- switch(palette,
    "primary" = cpal_colors_primary,
    "extended" = cpal_colors_extended,

    # Sequential palettes
    "teal_seq_4" = cpal_palettes_sequential$teal_seq_4,
    "teal_seq_5" = cpal_palettes_sequential$teal_seq_5,
    "teal_seq_6" = cpal_palettes_sequential$teal_seq_6,
    "yellow_teal_seq_4" = cpal_palettes_sequential$yellow_teal_seq_4,
    "yellow_teal_seq_5" = cpal_palettes_sequential$yellow_teal_seq_5,
    "yellow_teal_seq_6" = cpal_palettes_sequential$yellow_teal_seq_6,

    # Diverging palettes
    "pink_teal_3" = cpal_palettes_diverging$pink_teal_3,
    "pink_teal_5" = cpal_palettes_diverging$pink_teal_5,
    "pink_teal_6" = cpal_palettes_diverging$pink_teal_6,

    # Categorical palettes
    "main" = cpal_palettes_categorical$main,
    "main_gray" = cpal_palettes_categorical$main_gray,
    "blues" = cpal_palettes_categorical$blues,
    "compare" = cpal_palettes_categorical$compare,
    "main_3" = cpal_palettes_categorical$main_3,
    "main_4" = cpal_palettes_categorical$main_4,

    # Default to primary
    cpal_colors_primary
  )

  if (reverse) pal <- rev(pal)

  # Return n colors if specified
  if (!is.null(n)) {
    if (n <= length(pal)) {
      return(pal[1:n])
    } else {
      warning("Requested ", n, " colors but palette has only ", length(pal), " colors")
      return(pal)
    }
  }

  return(pal)
}

#' Get CPAL Color Palette
#'
#' Helper function to retrieve CPAL color palettes with optional reversal.
#' This is a wrapper around cpal_colors() for use in scale functions.
#'
#' @param palette Name of the palette to retrieve
#' @param reverse Logical. Should the palette be reversed?
#' @return A vector of colors
#' @keywords internal
cpal_palette <- function(palette = "primary", reverse = FALSE) {
  colors <- cpal_colors(palette)
  if (reverse) {
    colors <- rev(colors)
  }
  return(colors)
}


#' Display CPAL Color Palettes
#'
#' Show available CPAL color palettes
#'
#' @param palette Character. Name of palette to display (or "all")
#' @export
#' @examples
#' # Show all palettes
#' cpal_display_palettes("all")
#'
#' # Show specific palette
#' cpal_display_palettes("main")
cpal_display_palettes <- function(palette = "all") {

  # Function to plot a single palette
  plot_palette <- function(colors, name) {
    n <- length(colors)
    image(1:n, 1, as.matrix(1:n), col = colors,
          xlab = "", ylab = "", xaxt = "n", yaxt = "n",
          main = name, cex.main = 1.2)

    # Add color codes
    text(1:n, 0.5, colors, srt = 45, adj = 1, xpd = TRUE, cex = 0.8)

    # Add color names if available
    if (!is.null(names(colors))) {
      text(1:n, 1.5, names(colors), srt = 45, adj = 0, xpd = TRUE, cex = 0.8)
    }
  }

  if (palette == "all") {
    # Set up multi-panel plot
    old_par <- par(no.readonly = TRUE)
    on.exit(par(old_par))
    par(mfrow = c(4, 3), mar = c(5, 1, 3, 1))

    # Plot each palette
    plot_palette(cpal_colors_primary, "Primary Colors")
    plot_palette(cpal_palettes_categorical$main, "Main Categorical")
    plot_palette(cpal_palettes_categorical$blues, "Blues")

    plot_palette(cpal_palettes_sequential$teal_seq_4, "Teal Sequential (4)")
    plot_palette(cpal_palettes_sequential$teal_seq_6, "Teal Sequential (6)")
    plot_palette(cpal_palettes_sequential$yellow_teal_seq_5, "Yellow-Teal Sequential")

    plot_palette(cpal_palettes_diverging$pink_teal_3, "Pink-Teal Diverging (3)")
    plot_palette(cpal_palettes_diverging$pink_teal_5, "Pink-Teal Diverging (5)")
    plot_palette(cpal_palettes_diverging$pink_teal_6, "Pink-Teal Diverging (6)")

  } else {
    # Plot single palette
    colors <- cpal_colors(palette)
    plot_palette(colors, palette)
  }
}

#' CPAL Color Scales for ggplot2
#'
#' @param palette Character. Name of palette
#' @param discrete Logical. Is data discrete?
#' @param reverse Logical. Reverse palette?
#' @param ... Additional arguments passed to scale functions
#' @name scale_cpal
#' @export
scale_color_cpal <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- cpal_colors(palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("colour", "cpal", palette = function(n) {
      if (n <= length(pal)) {
        pal[1:n]
      } else {
        colorRampPalette(pal)(n)
      }
    }, ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal, ...)
  }
}

#' @rdname scale_cpal
#' @export
scale_colour_cpal <- scale_color_cpal

#' @rdname scale_cpal
#' @export
scale_fill_cpal <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- cpal_colors(palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", "cpal", palette = function(n) {
      if (n <= length(pal)) {
        pal[1:n]
      } else {
        colorRampPalette(pal)(n)
      }
    }, ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal, ...)
  }
}



# View Functions ----

#' View CPAL Color Palettes
#'
#' Functions to visualize all available CPAL color palettes
#'

#' Basic view of all palettes
#' @export
view_palette <- function() {
  # Save current par settings
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  # Set up the layout for multiple plots
  par(mfrow = c(5, 3), mar = c(2, 8, 3, 1), oma = c(1, 1, 3, 1))

  # Helper function to plot a palette
  plot_single_palette <- function(colors, name, show_hex = TRUE) {
    n <- length(colors)
    if (n == 0) {
      plot(1, 1, type = "n", xlab = "", ylab = "", main = name,
           axes = FALSE, xlim = c(0, 1), ylim = c(0, 1))
      text(0.5, 0.5, "No colors available", cex = 0.8)
      return()
    }

    # Create horizontal bar plot
    barplot(rep(1, n), col = colors, border = NA, space = 0,
            axes = FALSE, main = name, cex.main = 0.9,
            horiz = TRUE)

    # Add hex codes if requested
    if (show_hex && n <= 6) {
      text(x = (1:n - 0.5) * (1/n), y = 0.5, labels = colors,
           cex = 0.6, srt = 90, adj = c(0.5, 0.5))
    }

    # Add color names if available
    if (!is.null(names(colors)) && n <= 6) {
      axis(2, at = (1:n - 0.5) * (1/n), labels = names(colors),
           las = 2, cex.axis = 0.7, tick = FALSE, line = -1)
    }
  }

  # Plot all palette types
  plot_single_palette(cpal_colors("primary"), "Brand Colors (Primary)")
  plot_single_palette(cpal_colors("teal_seq_4"), "Teal Sequential (4 colors)")
  plot_single_palette(cpal_colors("teal_seq_5"), "Teal Sequential (5 colors)")
  plot_single_palette(cpal_colors("teal_seq_6"), "Teal Sequential (6 colors)")
  plot_single_palette(cpal_colors("yellow_teal_seq_4"), "Yellow-Teal Seq (4 colors)")
  plot_single_palette(cpal_colors("yellow_teal_seq_5"), "Yellow-Teal Seq (5 colors)")
  plot_single_palette(cpal_colors("yellow_teal_seq_6"), "Yellow-Teal Seq (6 colors)")
  plot_single_palette(cpal_colors("pink_teal_3"), "Pink-Teal Diverging (3)")
  plot_single_palette(cpal_colors("pink_teal_5"), "Pink-Teal Diverging (5)")
  plot_single_palette(cpal_colors("pink_teal_6"), "Pink-Teal Diverging (6)")
  plot_single_palette(cpal_colors("main"), "Main Categorical (5)")
  plot_single_palette(cpal_colors("main_gray"), "Main + Gray (6)")
  plot_single_palette(cpal_colors("blues"), "Blues (2)")
  plot_single_palette(cpal_colors("compare"), "Compare (2)")
  plot_single_palette(cpal_colors("main_3"), "Main (3 colors)")

  # Add overall title
  mtext("CPAL Color Palettes Overview", outer = TRUE, cex = 1.5, font = 2)
}

#' Grid view of all palettes with hex codes
#' @export
view_all_palettes <- function() {
  # Save current par settings
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  # Collect all available palettes
  all_palettes <- list(
    "Brand Colors" = cpal_colors("primary"),
    "Sequential Teal (4)" = cpal_colors("teal_seq_4"),
    "Sequential Teal (5)" = cpal_colors("teal_seq_5"),
    "Sequential Teal (6)" = cpal_colors("teal_seq_6"),
    "Yellow-Teal (4)" = cpal_colors("yellow_teal_seq_4"),
    "Yellow-Teal (5)" = cpal_colors("yellow_teal_seq_5"),
    "Yellow-Teal (6)" = cpal_colors("yellow_teal_seq_6"),
    "Pink-Teal Div (3)" = cpal_colors("pink_teal_3"),
    "Pink-Teal Div (5)" = cpal_colors("pink_teal_5"),
    "Pink-Teal Div (6)" = cpal_colors("pink_teal_6"),
    "Categorical Main" = cpal_colors("main"),
    "Categorical + Gray" = cpal_colors("main_gray"),
    "Blues Only" = cpal_colors("blues"),
    "Compare (Gray/Teal)" = cpal_colors("compare"),
    "Main (3 colors)" = cpal_colors("main_3"),
    "Main (4 colors)" = cpal_colors("main_4")
  )

  # Set up grid
  n_palettes <- length(all_palettes)
  n_cols <- 3
  n_rows <- ceiling(n_palettes / n_cols)

  par(mfrow = c(n_rows, n_cols), mar = c(3, 0.5, 3, 0.5), oma = c(0, 0, 3, 0))

  # Plot each palette
  for (i in 1:n_palettes) {
    colors <- all_palettes[[i]]
    name <- names(all_palettes)[i]
    n <- length(colors)

    # Create the plot
    plot(1:n, rep(1, n), type = "n", xlim = c(0.5, n + 0.5), ylim = c(0, 2),
         axes = FALSE, xlab = "", ylab = "", main = name, cex.main = 1)

    # Draw color squares
    for (j in 1:n) {
      rect(j - 0.4, 0.5, j + 0.4, 1.5, col = colors[j], border = "white", lwd = 2)
      # Add hex code below
      text(j, 0.2, colors[j], cex = 0.6, srt = 45, adj = 1)
    }
  }

  # Add any empty plots if needed
  if (n_palettes < n_rows * n_cols) {
    for (i in (n_palettes + 1):(n_rows * n_cols)) {
      plot.new()
    }
  }

  # Overall title
  mtext("CPAL Color Palettes - Complete Reference", outer = TRUE, cex = 1.5, font = 2, line = 1)
}
