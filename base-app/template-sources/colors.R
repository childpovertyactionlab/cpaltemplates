#' @importFrom grDevices colorRampPalette
#' @importFrom graphics axis barplot mtext par plot.new rect text
#' #' CPAL Color Palettes
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
  "midnight" = "#007A8C",
  # Midnight
  "teal"     = "#008097",
  # Teal
  "pink"     = "#C3257B",
  # Pink
  "orange"   = "#ED683F",
  # Orange
  "gold"     = "#AB8C01"   # Gold
)

# Extended Palette ----

#' CPAL Extended Color Palette
#'
#' Extended colors including additional shades for data visualization
#' @export
cpal_colors_extended <- c(
  # Brand Colors
  "midnight"      = "#007A8C",
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
  teal_seq_6 = c(
    "#D8EFF4",
    "#C0E7EE",
    "#95CFDA",
    "#47ACBD",
    "#008097",
    "#004855"
  ),

  # Multi-hue sequential (from Image 2)
  yellow_teal_seq_4 = c("#E5CB50", "#499881", "#016678", "#004855"),
  yellow_teal_seq_5 = c("#E5CB50", "#76A772", "#018097", "#025968", "#043037"),
  yellow_teal_seq_6 = c(
    "#E5CB50",
    "#82AA6F",
    "#2A8E8A",
    "#017084",
    "#03515E",
    "#004855"
  )
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
  pink_teal_6 = c(
    "#C3257B",
    "#B979A2",
    "#C2BBCB",
    "#A0BFC5",
    "#588993",
    "#008097"
  )
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
  main_gray = c(
    "#004855",
    "#008097",
    "#C3257B",
    "#ED683F",
    "#AB8C01",
    "#798AA1"
  ),

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
cpal_colors <- function(palette = "primary",
                        n = NULL,
                        reverse = FALSE) {
  # If requesting specific colors by name
  if (all(palette %in% names(cpal_colors_extended))) {
    return(cpal_colors_extended[palette])
  }

  # Get the requested palette
  pal <- switch(
    palette,
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

  if (reverse)
    pal <- rev(pal)

  # Return n colors if specified
  if (!is.null(n)) {
    if (n <= length(pal)) {
      return(pal[1:n])
    } else {
      warning("Requested ",
              n,
              " colors but palette has only ",
              length(pal),
              " colors")
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
  # Fix: Remove names to ensure compatibility with ggplot2 scale functions
  return(unname(colors))
}

#' CPAL Color Scales for ggplot2
#'
#' @param palette Character. Name of palette
#' @param discrete Logical. Is data discrete?
#' @param reverse Logical. Reverse palette?
#' @param ... Additional arguments passed to scale functions
#' @name scale_cpal
#' @return A ggplot2 scale object for adding CPAL colors to plots
#' @export
scale_color_cpal <- function(palette = "main",
                             discrete = TRUE,
                             reverse = FALSE,
                             ...) {
  pal <- cpal_colors(palette, reverse = reverse)

  # Fix: Remove names from color vectors before passing to ggplot2
  pal <- unname(pal)

  if (discrete) {
    ggplot2::discrete_scale(
      "colour",
      "cpal",
      palette = function(n) {
        if (n <= length(pal)) {
          pal[1:n]
        } else {
          colorRampPalette(pal)(n)
        }
      },
      ...
    )
  } else {
    ggplot2::scale_color_gradientn(colours = pal, ...)
  }
}

#' @rdname scale_cpal
#' @export
scale_colour_cpal <- scale_color_cpal

#' @rdname scale_cpal
#' @export
scale_fill_cpal <- function(palette = "main",
                            discrete = TRUE,
                            reverse = FALSE,
                            ...) {
  pal <- cpal_colors(palette, reverse = reverse)

  # Fix: Remove names from color vectors before passing to ggplot2
  pal <- unname(pal)

  if (discrete) {
    ggplot2::discrete_scale(
      "fill",
      "cpal",
      palette = function(n) {
        if (n <= length(pal)) {
          pal[1:n]
        } else {
          colorRampPalette(pal)(n)
        }
      },
      ...
    )
  } else {
    ggplot2::scale_fill_gradientn(colours = pal, ...)
  }
}

#' View CPAL Color Palettes
#'
#' Display CPAL color palettes with improved readability and flexibility
#'
#' @param palette Character. Name of specific palette to display, or "all" for overview
#' @param show_hex Logical. Whether to display hex codes (default: TRUE)
#' @param show_names Logical. Whether to display color names if available (default: TRUE)
#' @param compact Logical. Use compact layout for overview (default: FALSE)
#' @return Displays color palette visualization (called for side effects)
#' @export
#' @examples
#' # Show all palettes in overview
#' view_cpal_palettes()
#'
#' # Show specific palette
#' view_cpal_palettes("main")
#' view_cpal_palettes("teal_seq_5")
#'
#' # Compact overview without hex codes
#' view_cpal_palettes("all", show_hex = FALSE, compact = TRUE)
view_cpal_palettes <- function(palette = "all",
                               show_hex = TRUE,
                               show_names = TRUE,
                               compact = FALSE) {
  # Helper function to plot a single palette with improved layout
  plot_single_palette <- function(colors,
                                  name,
                                  show_hex = TRUE,
                                  show_names = TRUE,
                                  single_plot = FALSE) {
    n <- length(colors)
    if (n == 0) {
      plot(
        1,
        1,
        type = "n",
        xlab = "",
        ylab = "",
        main = name,
        axes = FALSE,
        xlim = c(0, 1),
        ylim = c(0, 1)
      )
      text(0.5, 0.5, "No colors available", cex = 0.8)
      return()
    }

    # Use horizontal barplot for left-to-right color bars
    tryCatch({
      if (single_plot) {
        # For single plots, use more space and better formatting
        barplot(
          rep(1, n),
          col = colors,
          border = "white",
          space = 0.1,
          axes = FALSE,
          main = name,
          cex.main = 1.3,
          horiz = TRUE,
          # Make bars horizontal (left to right)
          names.arg = if (show_hex)
            colors
          else
            NULL,
          las = 1,
          cex.names = 0.8
        ) # las = 1 for horizontal text

        # Add color names if available
        if (show_names && !is.null(names(colors))) {
          mtext(
            paste(names(colors), collapse = " | "),
            side = 4,
            line = 1,
            cex = 0.9
          )
        }
      } else {
        # For multi-panel plots, horizontal bars with hex on left
        barplot(
          rep(1, n),
          col = colors,
          border = NA,
          space = 0,
          axes = FALSE,
          main = name,
          cex.main = 0.9,
          horiz = TRUE
        ) # Horizontal bars

        # Add hex codes on the left side if requested
        if (show_hex && !compact && n <= 6) {
          # Place hex codes on the left (y-axis area)
          axis(
            2,
            at = (1:n - 1) + 0.5,
            labels = colors,
            las = 1,
            cex.axis = 0.5,
            tick = FALSE,
            line = -0.5
          )
        }
      }
    }, error = function(e) {
      # Fallback to simple plot if barplot fails
      plot(
        1:n,
        rep(1, n),
        type = "n",
        xlim = c(0.5, n + 0.5),
        ylim = c(0.5, 1.5),
        axes = FALSE,
        xlab = "",
        ylab = "",
        main = name
      )
      for (i in 1:n) {
        rect(i - 0.4,
             0.7,
             i + 0.4,
             1.3,
             col = colors[i],
             border = "white")
      }
    })
  }

  # Get available palettes
  available_palettes <- list(
    "primary" = cpal_colors("primary"),
    "main" = cpal_colors("main"),
    "main_3" = cpal_colors("main_3"),
    "main_4" = cpal_colors("main_4"),
    "main_gray" = cpal_colors("main_gray"),
    "blues" = cpal_colors("blues"),
    "compare" = cpal_colors("compare"),
    "teal_seq_4" = cpal_colors("teal_seq_4"),
    "teal_seq_5" = cpal_colors("teal_seq_5"),
    "teal_seq_6" = cpal_colors("teal_seq_6"),
    "yellow_teal_seq_4" = cpal_colors("yellow_teal_seq_4"),
    "yellow_teal_seq_5" = cpal_colors("yellow_teal_seq_5"),
    "yellow_teal_seq_6" = cpal_colors("yellow_teal_seq_6"),
    "pink_teal_3" = cpal_colors("pink_teal_3"),
    "pink_teal_5" = cpal_colors("pink_teal_5"),
    "pink_teal_6" = cpal_colors("pink_teal_6")
  )

  if (palette == "all") {
    # Save current par settings
    old_par <- par(no.readonly = TRUE)
    on.exit(par(old_par))

    # Calculate how many palettes we actually have
    n_palettes <- length(available_palettes)

    # Set up appropriate grid layout
    if (compact) {
      par(
        mfrow = c(4, 4),
        mar = c(2, 1, 2, 1),
        oma = c(1, 1, 3, 1)
      )
    } else {
      # For 16 palettes, use 4x4 grid for normal view too
      par(
        mfrow = c(4, 4),
        mar = c(3, 1, 2.5, 1),
        oma = c(1, 1, 3, 1)
      )
    }

    # Create display names that match the order of available_palettes
    palette_display_names <- list(
      "primary" = "Brand Colors",
      "main" = "Main",
      "main_3" = "Main (3)",
      "main_4" = "Main (4)",
      "main_gray" = "Main+Gray",
      "blues" = "Blues",
      "compare" = "Compare",
      "teal_seq_4" = "Teal-4",
      "teal_seq_5" = "Teal-5",
      "teal_seq_6" = "Teal-6",
      "yellow_teal_seq_4" = "Y-Teal-4",
      "yellow_teal_seq_5" = "Y-Teal-5",
      "yellow_teal_seq_6" = "Y-Teal-6",
      "pink_teal_3" = "P-Teal-3",
      "pink_teal_5" = "P-Teal-5",
      "pink_teal_6" = "P-Teal-6"
    )

    # Plot all palettes with error handling
    for (i in 1:n_palettes) {
      tryCatch({
        palette_name <- names(available_palettes)[i]
        display_name <- palette_display_names[[palette_name]]
        colors <- available_palettes[[palette_name]]

        # Check that we have valid colors
        if (length(colors) > 0) {
          plot_single_palette(
            colors,
            display_name,
            show_hex = show_hex && !compact,
            show_names = FALSE,
            single_plot = FALSE
          )
        } else {
          # Create empty plot if no colors
          plot.new()
          text(0.5, 0.5, paste("No colors\n", display_name), cex = 0.8)
        }
      }, error = function(e) {
        # Skip problematic plots and show error info
        plot.new()
        text(0.5, 0.5, paste("Error:", palette_name), cex = 0.6)
      })
    }

    # Add overall title
    title_text <- if (compact)
      "CPAL Palettes (Compact)"
    else
      "CPAL Color Palettes"
    mtext(
      title_text,
      outer = TRUE,
      cex = 1.3,
      font = 2,
      line = 0.5
    )

  } else {
    # Display single palette - much simpler approach
    if (!palette %in% names(available_palettes)) {
      stop(
        "Palette '",
        palette,
        "' not found. Available palettes: ",
        paste(names(available_palettes), collapse = ", ")
      )
    }

    # Save current par settings
    old_par <- par(no.readonly = TRUE)
    on.exit(par(old_par))

    # Set margins for single plot
    par(mar = c(if (show_hex)
      4
      else
        2, 2, 3, 2))

    colors <- available_palettes[[palette]]
    display_name <- paste("CPAL Palette:", toupper(palette))

    plot_single_palette(
      colors,
      display_name,
      show_hex = show_hex,
      show_names = show_names,
      single_plot = TRUE
    )

    # Add palette information to console
    cat("\nPalette:", palette, "\n")
    cat("Number of colors:", length(colors), "\n")
    if (show_hex) {
      cat("Hex codes:", paste(colors, collapse = ", "), "\n")
    }
  }
}

#' Quick Palette Preview
#'
#' Display a simple, clean preview of any CPAL palette
#'
#' @param palette Character. Name of palette to display
#' @param n_colors Integer. Number of colors to show (if palette has more)
#' @return Displays simple color palette preview (called for side effects)
#' @export
#' @examples
#' # Quick preview of main palette
#' quick_palette("main")
#'
#' # Preview first 3 colors of a sequential palette
#' quick_palette("teal_seq_6", n_colors = 3)
quick_palette <- function(palette, n_colors = NULL) {
  colors <- cpal_colors(palette)

  if (!is.null(n_colors) && n_colors < length(colors)) {
    colors <- colors[1:n_colors]
  }

  # Save current par settings
  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  n <- length(colors)
  par(mar = c(1, 1, 3, 1))

  # Simple horizontal bar display
  barplot(
    rep(1, n),
    col = colors,
    border = "white",
    space = 0.1,
    axes = FALSE,
    main = paste("CPAL", toupper(palette)),
    cex.main = 1.2,
    horiz = FALSE
  )

  # Print color info to console
  cat("Palette:", palette, "\n")
  cat("Colors:", paste(colors, collapse = " "), "\n")
}

#' List Available CPAL Palettes
#'
#' Get a list of all available CPAL color palettes with descriptions
#'
#' @param details Logical. If TRUE, show detailed information about each palette
#' @return Character vector of palette names, or detailed list if details=TRUE
#' @export
#' @examples
#' # Simple list
#' list_cpal_palettes()
#'
#' # Detailed information
#' list_cpal_palettes(details = TRUE)
list_cpal_palettes <- function(details = FALSE) {
  palette_info <- list(
    "primary" = list(
      name = "Brand Colors",
      type = "Categorical",
      colors = 5,
      description = "CPAL brand colors for institutional use"
    ),
    "main" = list(
      name = "Main Categorical",
      type = "Categorical",
      colors = 5,
      description = "Primary categorical palette for data visualization"
    ),
    "main_3" = list(
      name = "Main (3 colors)",
      type = "Categorical",
      colors = 3,
      description = "Reduced main palette for simple comparisons"
    ),
    "main_4" = list(
      name = "Main (4 colors)",
      type = "Categorical",
      colors = 4,
      description = "Extended main palette for moderate comparisons"
    ),
    "main_gray" = list(
      name = "Main + Gray",
      type = "Categorical",
      colors = 6,
      description = "Main palette with gray for highlighting"
    ),
    "blues" = list(
      name = "Blues",
      type = "Categorical",
      colors = 2,
      description = "Blue tones for simple comparisons"
    ),
    "compare" = list(
      name = "Compare",
      type = "Categorical",
      colors = 2,
      description = "Gray and teal for before/after comparisons"
    ),
    "teal_seq_4" = list(
      name = "Teal Sequential (4)",
      type = "Sequential",
      colors = 4,
      description = "Light to dark teal progression"
    ),
    "teal_seq_5" = list(
      name = "Teal Sequential (5)",
      type = "Sequential",
      colors = 5,
      description = "Light to dark teal progression"
    ),
    "teal_seq_6" = list(
      name = "Teal Sequential (6)",
      type = "Sequential",
      colors = 6,
      description = "Light to dark teal progression"
    ),
    "yellow_teal_seq_4" = list(
      name = "Yellow-Teal Sequential (4)",
      type = "Sequential",
      colors = 4,
      description = "Yellow to teal progression"
    ),
    "yellow_teal_seq_5" = list(
      name = "Yellow-Teal Sequential (5)",
      type = "Sequential",
      colors = 5,
      description = "Yellow to teal progression"
    ),
    "yellow_teal_seq_6" = list(
      name = "Yellow-Teal Sequential (6)",
      type = "Sequential",
      colors = 6,
      description = "Yellow to teal progression"
    ),
    "pink_teal_3" = list(
      name = "Pink-Teal Diverging (3)",
      type = "Diverging",
      colors = 3,
      description = "Pink to teal with neutral center"
    ),
    "pink_teal_5" = list(
      name = "Pink-Teal Diverging (5)",
      type = "Diverging",
      colors = 5,
      description = "Pink to teal with neutral center"
    ),
    "pink_teal_6" = list(
      name = "Pink-Teal Diverging (6)",
      type = "Diverging",
      colors = 6,
      description = "Pink to teal with neutral center"
    )
  )

  if (details) {
    return(palette_info)
  } else {
    return(names(palette_info))
  }
}
