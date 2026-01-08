#' CPAL Color Palettes
#'
#' Official color palettes for Child Poverty Action Lab data visualizations.
#' All colors are loaded from `_brand.yml` as the single source of truth.
#'
#' @name cpal_colors
#' @rdname cpal_colors
#' @importFrom grDevices colorRampPalette
#' @importFrom graphics axis barplot mtext par plot.new rect text
NULL

# Declare global variables used in ggplot2 aes() to avoid R CMD check notes
utils::globalVariables(c("position", "color", "label", "text_color"))

# ============================================================================
# Brand Configuration Loading
# ============================================================================

# Brand configuration cache
.cpal_brand_env <- new.env(parent = emptyenv())

#' Load CPAL Brand Configuration
#'
#' Internal function to load and cache the brand configuration from _brand.yml.
#' Uses the brand.yml package from Posit if available, falls back to yaml.
#'
#' @param force_reload Logical. If TRUE, reloads the brand configuration even if cached.
#' @return The brand configuration object.
#' @keywords internal
.load_cpal_brand <- function(force_reload = FALSE) {
  if (force_reload || is.null(.cpal_brand_env$brand)) {
    # First try package location
    brand_path <- system.file("brand", "_brand.yml", package = "cpaltemplates")

    # Fallback to local file for development/demo app
    if (!file.exists(brand_path) || brand_path == "") {
      if (file.exists("_brand.yml")) {
        brand_path <- "_brand.yml"
      } else if (file.exists("../_brand.yml")) {
        brand_path <- "../_brand.yml"
      }
    }

    if (file.exists(brand_path) && brand_path != "") {
      if (requireNamespace("brand.yml", quietly = TRUE)) {
        .cpal_brand_env$brand <- brand.yml::read_brand_yml(brand_path)
        .cpal_brand_env$use_brand_pkg <- TRUE
      } else {
        # Fallback to yaml parsing if brand.yml package not available
        .cpal_brand_env$brand <- yaml::read_yaml(brand_path)
        .cpal_brand_env$use_brand_pkg <- FALSE
      }
    } else {
      cli::cli_warn("Brand configuration file (_brand.yml) not found. Using fallback colors.")
      .cpal_brand_env$brand <- NULL
      .cpal_brand_env$use_brand_pkg <- FALSE
    }
  }
  .cpal_brand_env$brand
}

#' Get a color from the brand palette
#'
#' Internal helper to get a single color from the brand configuration.
#'
#' @param color_name Name of the color in the palette
#' @param fallback Fallback hex color if not found
#' @return Hex color string
#' @keywords internal
.get_brand_color <- function(color_name, fallback = "#000000") {

  brand <- .load_cpal_brand()

  if (is.null(brand)) {
    return(fallback)
  }

  # Use brand.yml package function if available
 if (isTRUE(.cpal_brand_env$use_brand_pkg) && requireNamespace("brand.yml", quietly = TRUE)) {
    hex_code <- tryCatch(
      brand.yml::brand_color_pluck(brand, color_name),
      error = function(e) NULL
    )
    if (!is.null(hex_code)) return(hex_code)
  }

  # Fallback: direct access for yaml-parsed brand
  hex_code <- brand$color$palette[[color_name]]

  if (is.null(hex_code)) {
    return(fallback)
  }

  return(hex_code)
}

# ============================================================================
# Primary Colors (loaded from _brand.yml)
# ============================================================================

#' CPAL Primary Colors
#'
#' Core brand colors for CPAL visualizations. These are loaded from `_brand.yml`.
#'
#' @return Named character vector of primary brand colors
#' @export
#' @examples
#' cpal_colors_primary
cpal_colors_primary <- function() {
  c(
    "midnight"   = .get_brand_color("midnight", "#004855"),
    "deep_teal"  = .get_brand_color("deep_teal", "#006878"),
    "coral"      = .get_brand_color("coral", "#E86A50"),
    "sage"       = .get_brand_color("sage", "#5A8A6F"),
    "slate"      = .get_brand_color("slate", "#5C6B73"),
    "warm_gray"  = .get_brand_color("warm_gray", "#9BA8AB")
  )
}

# ============================================================================
# Extended Palette (loaded from _brand.yml)
# ============================================================================

#' CPAL Extended Color Palette
#'
#' Extended colors including additional shades for data visualization.
#' All colors are loaded from `_brand.yml`.
#'
#' @return Named character vector of extended colors
#' @export
#' @examples
#' cpal_colors_extended
cpal_colors_extended <- function() {
  c(
    # Core Brand Colors
    "midnight"     = .get_brand_color("midnight", "#004855"),
    "deep_teal"    = .get_brand_color("deep_teal", "#006878"),
    "coral"        = .get_brand_color("coral", "#E86A50"),
    "sage"         = .get_brand_color("sage", "#5A8A6F"),
    "slate"        = .get_brand_color("slate", "#5C6B73"),
    "warm_gray"    = .get_brand_color("warm_gray", "#9BA8AB"),

    # Legacy Colors (backward compatibility)
    "teal"         = .get_brand_color("teal", "#007A8C"),
    "gold"         = .get_brand_color("gold", "#B8860B"),
    "plum"         = .get_brand_color("plum", "#8B5E83"),
    "coral_dark"   = .get_brand_color("coral_dark", "#C75540"),

    # Neutral
    "neutral"      = .get_brand_color("neutral", "#E8ECEE"),

    # Sequential Palette - Midnight shades
    "midnight_1"   = .get_brand_color("midnight_1", "#E8F4F6"),
    "midnight_2"   = .get_brand_color("midnight_2", "#B8D9E0"),
    "midnight_3"   = .get_brand_color("midnight_3", "#88BECA"),
    "midnight_4"   = .get_brand_color("midnight_4", "#58A3B4"),
    "midnight_5"   = .get_brand_color("midnight_5", "#28889E"),
    "midnight_6"   = .get_brand_color("midnight_6", "#006D88"),
    "midnight_7"   = .get_brand_color("midnight_7", "#004855"),
    "midnight_8"   = .get_brand_color("midnight_8", "#002D38"),

    # Status Colors
    "success"      = .get_brand_color("success", "#5A8A6F"),
    "warning"      = .get_brand_color("warning", "#D4A84B"),
    "error"        = .get_brand_color("error", "#C75540"),
    "info"         = .get_brand_color("info", "#006878")
  )
}

# ============================================================================
# Sequential Palettes (built from _brand.yml colors)
# ============================================================================

#' CPAL Sequential Color Palettes
#'
#' Sequential palettes for continuous data, built from colors in `_brand.yml`.
#' Uses the new Midnight sequential palette system.
#'
#' @return List of sequential color palettes
#' @export
#' @examples
#' cpal_palettes_sequential
cpal_palettes_sequential <- function() {
  list(
    # Midnight sequential (4 colors - light to dark)
    midnight_seq_4 = c(
      .get_brand_color("midnight_2", "#B8D9E0"),
      .get_brand_color("midnight_4", "#58A3B4"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    ),

    # Midnight sequential (5 colors)
    midnight_seq_5 = c(
      .get_brand_color("midnight_1", "#E8F4F6"),
      .get_brand_color("midnight_3", "#88BECA"),
      .get_brand_color("midnight_5", "#28889E"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    ),

    # Midnight sequential (6 colors)
    midnight_seq_6 = c(
      .get_brand_color("midnight_1", "#E8F4F6"),
      .get_brand_color("midnight_2", "#B8D9E0"),
      .get_brand_color("midnight_3", "#88BECA"),
      .get_brand_color("midnight_5", "#28889E"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    ),

    # Midnight sequential (8 colors - full range)
    midnight_seq_8 = c(
      .get_brand_color("midnight_1", "#E8F4F6"),
      .get_brand_color("midnight_2", "#B8D9E0"),
      .get_brand_color("midnight_3", "#88BECA"),
      .get_brand_color("midnight_4", "#58A3B4"),
      .get_brand_color("midnight_5", "#28889E"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("midnight_8", "#002D38")
    ),

    # Legacy aliases for backward compatibility
    teal_seq_4 = c(
      .get_brand_color("midnight_2", "#B8D9E0"),
      .get_brand_color("midnight_4", "#58A3B4"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    ),
    teal_seq_5 = c(
      .get_brand_color("midnight_1", "#E8F4F6"),
      .get_brand_color("midnight_3", "#88BECA"),
      .get_brand_color("midnight_5", "#28889E"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    ),
    teal_seq_6 = c(
      .get_brand_color("midnight_1", "#E8F4F6"),
      .get_brand_color("midnight_2", "#B8D9E0"),
      .get_brand_color("midnight_3", "#88BECA"),
      .get_brand_color("midnight_5", "#28889E"),
      .get_brand_color("midnight_6", "#006D88"),
      .get_brand_color("midnight", "#004855")
    )
  )
}

# ============================================================================
# Diverging Palettes (built from _brand.yml colors)
# ============================================================================

#' CPAL Diverging Color Palettes
#'
#' Diverging palettes for data with a meaningful midpoint,
#' built from colors in `_brand.yml`. Uses Coral to Midnight diverging scale.
#'
#' @return List of diverging color palettes
#' @export
#' @examples
#' cpal_palettes_diverging
cpal_palettes_diverging <- function() {
  list(
    # Coral to Midnight diverging (3 colors)
    coral_midnight_3 = c(
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("neutral", "#E8ECEE"),
      .get_brand_color("midnight", "#004855")
    ),

    # Coral to Midnight diverging (5 colors)
    coral_midnight_5 = c(
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("div_coral_4", "#F5ADA0"),
      .get_brand_color("neutral", "#E8ECEE"),
      .get_brand_color("div_teal_1", "#88BECA"),
      .get_brand_color("midnight", "#004855")
    ),

    # Coral to Midnight diverging (7 colors)
    coral_midnight_7 = c(
      .get_brand_color("coral_dark", "#C75540"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("div_coral_4", "#F5ADA0"),
      .get_brand_color("neutral", "#E8ECEE"),
      .get_brand_color("div_teal_1", "#88BECA"),
      .get_brand_color("deep_teal", "#006878"),
      .get_brand_color("midnight", "#004855")
    ),

    # Coral to Midnight diverging (9 colors - full range)
    coral_midnight_9 = c(
      .get_brand_color("div_coral_1", "#C75540"),
      .get_brand_color("div_coral_2", "#E86A50"),
      .get_brand_color("div_coral_3", "#F08B78"),
      .get_brand_color("div_coral_4", "#F5ADA0"),
      .get_brand_color("div_neutral", "#E8ECEE"),
      .get_brand_color("div_teal_1", "#88BECA"),
      .get_brand_color("div_teal_2", "#58A3B4"),
      .get_brand_color("div_teal_3", "#006878"),
      .get_brand_color("div_teal_4", "#004855")
    ),

    # Legacy aliases for backward compatibility
    pink_teal_3 = c(
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("neutral", "#E8ECEE"),
      .get_brand_color("midnight", "#004855")
    ),
    pink_teal_5 = c(
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("div_coral_4", "#F5ADA0"),
      .get_brand_color("neutral", "#E8ECEE"),
      .get_brand_color("div_teal_1", "#88BECA"),
      .get_brand_color("midnight", "#004855")
    ),
    pink_teal_6 = c(
      .get_brand_color("coral_dark", "#C75540"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("div_coral_4", "#F5ADA0"),
      .get_brand_color("div_teal_1", "#88BECA"),
      .get_brand_color("deep_teal", "#006878"),
      .get_brand_color("midnight", "#004855")
    )
  )
}

# ============================================================================
# Categorical Palettes (built from _brand.yml colors)
# ============================================================================

#' CPAL Categorical Color Palettes
#'
#' Palettes for categorical data, built from colors in `_brand.yml`.
#' Maximum 8 colors for categorical data.
#'
#' @return List of categorical color palettes
#' @export
#' @examples
#' cpal_palettes_categorical
cpal_palettes_categorical <- function() {
  list(
    # Full categorical palette (8 colors max)
    main = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("teal", "#007A8C"),
      .get_brand_color("gold", "#B8860B"),
      .get_brand_color("plum", "#8B5E83"),
      .get_brand_color("slate", "#5C6B73"),
      .get_brand_color("coral_dark", "#C75540")
    ),

    # 3-color categorical
    main_3 = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F")
    ),

    # 4-color categorical
    main_4 = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("teal", "#007A8C")
    ),

    # 5-color categorical
    main_5 = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("teal", "#007A8C"),
      .get_brand_color("gold", "#B8860B")
    ),

    # 6-color categorical
    main_6 = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("teal", "#007A8C"),
      .get_brand_color("gold", "#B8860B"),
      .get_brand_color("plum", "#8B5E83")
    ),

    # With gray for additional category (legacy)
    main_gray = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("coral", "#E86A50"),
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("teal", "#007A8C"),
      .get_brand_color("gold", "#B8860B"),
      .get_brand_color("warm_gray", "#9BA8AB")
    ),

    # 2-color palettes
    blues = c(
      .get_brand_color("midnight", "#004855"),
      .get_brand_color("deep_teal", "#006878")
    ),
    compare = c(
      .get_brand_color("warm_gray", "#9BA8AB"),
      .get_brand_color("deep_teal", "#006878")
    ),

    # Binary palette (positive/negative)
    binary = c(
      .get_brand_color("sage", "#5A8A6F"),
      .get_brand_color("coral", "#E86A50")
    ),

    # Status colors palette
    status = c(
      .get_brand_color("success", "#5A8A6F"),
      .get_brand_color("warning", "#D4A84B"),
      .get_brand_color("error", "#C75540"),
      .get_brand_color("info", "#006878")
    )
  )
}

# ============================================================================
# Helper Functions
# ============================================================================

#' Get CPAL Colors
#'
#' Access CPAL color palettes. All colors are sourced from `_brand.yml`.
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
#' cpal_colors("coral")
#' cpal_colors(c("coral", "sage"))
#'
#' # Get a sequential palette
#' cpal_colors("midnight_seq_5")
#'
#' # Get n colors from a palette
#' cpal_colors("main", n = 3)
cpal_colors <- function(palette = "primary", n = NULL, reverse = FALSE) {

  # Get extended colors for name lookup
  extended <- cpal_colors_extended()

  # If requesting specific colors by name
  if (all(palette %in% names(extended))) {
    return(extended[palette])
  }

  # Get the requested palette
  pal <- switch(palette,
    "primary" = cpal_colors_primary(),
    "extended" = extended,

    # Sequential palettes (new)
    "midnight_seq_4" = cpal_palettes_sequential()$midnight_seq_4,
    "midnight_seq_5" = cpal_palettes_sequential()$midnight_seq_5,
    "midnight_seq_6" = cpal_palettes_sequential()$midnight_seq_6,
    "midnight_seq_8" = cpal_palettes_sequential()$midnight_seq_8,
    # Sequential palettes (legacy)
    "teal_seq_4" = cpal_palettes_sequential()$teal_seq_4,
    "teal_seq_5" = cpal_palettes_sequential()$teal_seq_5,
    "teal_seq_6" = cpal_palettes_sequential()$teal_seq_6,

    # Diverging palettes (new)
    "coral_midnight_3" = cpal_palettes_diverging()$coral_midnight_3,
    "coral_midnight_5" = cpal_palettes_diverging()$coral_midnight_5,
    "coral_midnight_7" = cpal_palettes_diverging()$coral_midnight_7,
    "coral_midnight_9" = cpal_palettes_diverging()$coral_midnight_9,
    # Diverging palettes (legacy)
    "pink_teal_3" = cpal_palettes_diverging()$pink_teal_3,
    "pink_teal_5" = cpal_palettes_diverging()$pink_teal_5,
    "pink_teal_6" = cpal_palettes_diverging()$pink_teal_6,

    # Categorical palettes
    "main" = cpal_palettes_categorical()$main,
    "main_3" = cpal_palettes_categorical()$main_3,
    "main_4" = cpal_palettes_categorical()$main_4,
    "main_5" = cpal_palettes_categorical()$main_5,
    "main_6" = cpal_palettes_categorical()$main_6,
    "main_gray" = cpal_palettes_categorical()$main_gray,
    "blues" = cpal_palettes_categorical()$blues,
    "compare" = cpal_palettes_categorical()$compare,
    "binary" = cpal_palettes_categorical()$binary,
    "status" = cpal_palettes_categorical()$status,

    # Default to primary
    cpal_colors_primary()
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

#' Get CPAL Primary Brand Color
#'
#' Retrieves the hex code for the primary brand color (Teal) as defined
#' in the `_brand.yml` palette.
#'
#' @return A character string containing the hex color code (e.g., "#007A8C").
#' @export
#' @examples
#' cpal_get_primary_color()
cpal_get_primary_color <- function() {
  .get_brand_color("teal", "#007A8C")
}

#' Get CPAL Color by Palette Name
#'
#' Generic helper to retrieve a specific hex code from the brand palette
#' by providing its name (e.g., "coral", "sage", "midnight").
#'
#' @param palette_color_name Character string matching a key in the
#'   `color: palette:` section of _brand.yml.
#'
#' @return A character string hex code.
#' @export
#'
#' @examples
#' cpal_get_color("coral")
#' cpal_get_color("midnight")
cpal_get_color <- function(palette_color_name) {
  brand <- .load_cpal_brand()

  if (is.null(brand)) {
    cli::cli_abort("Brand configuration not loaded. Ensure _brand.yml exists.")
  }

  # Use brand.yml package function if available
  if (isTRUE(.cpal_brand_env$use_brand_pkg) && requireNamespace("brand.yml", quietly = TRUE)) {
    hex_code <- tryCatch(
      brand.yml::brand_color_pluck(brand, palette_color_name),
      error = function(e) NULL
    )
    if (!is.null(hex_code)) return(hex_code)
  }

  # Fallback: direct access for yaml-parsed brand
  hex_code <- brand$color$palette[[palette_color_name]]

  if (is.null(hex_code)) {
    cli::cli_abort("Color {.val {palette_color_name}} not found in palette.")
  }

  return(hex_code)
}

#' Get CPAL Color Palette
#'
#' Helper function to retrieve CPAL color palettes with optional reversal.
#' This is a wrapper around cpal_colors() for use in scale functions.
#'
#' @param palette Name of the palette to retrieve
#' @param reverse Logical. Should the palette be reversed?
#' @return A vector of colors (unnamed for ggplot2 compatibility)
#' @export
cpal_palette <- function(palette = "primary", reverse = FALSE) {
  colors <- cpal_colors(palette)
  if (reverse) {
    colors <- rev(colors)
  }
  # Remove names to ensure compatibility with ggplot2 scale functions
  return(unname(colors))
}

# ============================================================================
# ggplot2 Scale Functions
# ============================================================================

#' CPAL Color Scales for ggplot2
#'
#' @param palette Character. Name of palette
#' @param discrete Logical. Is data discrete?
#' @param reverse Logical. Reverse palette?
#' @param ... Additional arguments passed to scale functions
#' @name scale_cpal
#' @return A ggplot2 scale object for adding CPAL colors to plots
#' @export
scale_color_cpal <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- cpal_colors(palette, reverse = reverse)
  pal <- unname(pal)

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
  pal <- unname(pal)

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

# ============================================================================
# Palette Visualization Functions
# ============================================================================

#' View CPAL Color Palettes
#'
#' Display CPAL color palettes with clean, modern visualization using ggplot2
#'
#' @param palette Character. Name of specific palette to display, or "all" for overview.
#'   Can also be a vector of palette names.
#' @param show_hex Logical. Whether to display hex codes on color swatches (default: FALSE)
#' @param show_names Logical. Whether to display color names if available (default: FALSE)
#' @param compact Logical. Use compact layout for overview (default: FALSE)
#' @return A ggplot2 object displaying the color palette(s)
#' @export
#' @examples
#' \dontrun{
#' # Show all palettes in overview
#' view_cpal_palettes()
#'
#' # Show specific palette
#' view_cpal_palettes("main")
#' view_cpal_palettes("teal_seq_5")
#'
#' # Show multiple palettes
#' view_cpal_palettes(c("main", "midnight_seq_5", "coral_midnight_5"))
#' }
view_cpal_palettes <- function(palette = "all", show_hex = FALSE, show_names = FALSE, compact = FALSE) {

  # Get available palettes
  available_palettes <- list(
    # Categorical
    "primary" = cpal_colors("primary"),
    "main" = cpal_colors("main"),
    "main_3" = cpal_colors("main_3"),
    "main_4" = cpal_colors("main_4"),
    "main_5" = cpal_colors("main_5"),
    "main_6" = cpal_colors("main_6"),
    "blues" = cpal_colors("blues"),
    "compare" = cpal_colors("compare"),
    "binary" = cpal_colors("binary"),
    "status" = cpal_colors("status"),
    # Sequential
    "midnight_seq_4" = cpal_colors("midnight_seq_4"),
    "midnight_seq_5" = cpal_colors("midnight_seq_5"),
    "midnight_seq_6" = cpal_colors("midnight_seq_6"),
    "midnight_seq_8" = cpal_colors("midnight_seq_8"),
    # Diverging
    "coral_midnight_3" = cpal_colors("coral_midnight_3"),
    "coral_midnight_5" = cpal_colors("coral_midnight_5"),
    "coral_midnight_7" = cpal_colors("coral_midnight_7"),
    "coral_midnight_9" = cpal_colors("coral_midnight_9"),
    # Legacy (backward compatibility)
    "main_gray" = cpal_colors("main_gray"),
    "teal_seq_5" = cpal_colors("teal_seq_5"),
    "pink_teal_5" = cpal_colors("pink_teal_5")
  )

  # Palette categories for grouping in display
  palette_categories <- list(
    "Categorical" = c("primary", "main", "main_3", "main_4", "main_5", "main_6", "blues", "compare", "binary", "status"),
    "Sequential" = c("midnight_seq_4", "midnight_seq_5", "midnight_seq_6", "midnight_seq_8"),
    "Diverging" = c("coral_midnight_3", "coral_midnight_5", "coral_midnight_7", "coral_midnight_9")
  )

  # Determine which palettes to show
  show_all <- length(palette) == 1 && palette == "all"

  if (show_all) {
    palettes_to_show <- names(available_palettes)
  } else {
    # Check that all requested palettes exist
    invalid <- palette[!palette %in% names(available_palettes)]
    if (length(invalid) > 0) {
      stop("Palette(s) not found: ", paste(invalid, collapse = ", "),
           ". Available palettes: ", paste(names(available_palettes), collapse = ", "))
    }
    palettes_to_show <- palette
  }

  # Helper function to determine text color for contrast
  get_text_color <- function(hex_color) {
    # Convert hex to RGB
    rgb_vals <- grDevices::col2rgb(hex_color)
    # Calculate relative luminance
    luminance <- (0.299 * rgb_vals[1] + 0.587 * rgb_vals[2] + 0.114 * rgb_vals[3]) / 255
    if (luminance > 0.5) "#333333" else "#FFFFFF"
  }

  # Build data frame for plotting
  plot_data <- do.call(rbind, lapply(palettes_to_show, function(pal_name) {
    colors <- available_palettes[[pal_name]]
    n <- length(colors)
    data.frame(
      palette = pal_name,
      color = colors,
      position = seq_len(n),
      color_name = if (!is.null(names(colors))) names(colors) else paste0("Color ", seq_len(n)),
      stringsAsFactors = FALSE
    )
  }))

  # Calculate text colors for each swatch
  plot_data$text_color <- sapply(plot_data$color, get_text_color)

  # Create label text
  if (show_hex && show_names) {
    plot_data$label <- paste0(plot_data$color_name, "\n", plot_data$color)
  } else if (show_hex) {
    plot_data$label <- plot_data$color
  } else if (show_names) {
    plot_data$label <- plot_data$color_name
  } else {
    plot_data$label <- ""
  }

  # Order palettes for display
  plot_data$palette <- factor(plot_data$palette, levels = rev(palettes_to_show))

  # Create the plot
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = position, y = palette, fill = I(color))) +
    ggplot2::geom_tile(color = "white", linewidth = 1, height = 0.85) +
    ggplot2::scale_x_continuous(expand = c(0.02, 0.02)) +
    ggplot2::scale_y_discrete(expand = c(0.02, 0.02)) +
    ggplot2::coord_fixed(ratio = 0.8) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 11, face = "bold", hjust = 1, color = "#333333"),
      axis.ticks = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      plot.title = ggplot2::element_text(size = 16, face = "bold", hjust = 0, color = "#004855"),
      plot.subtitle = ggplot2::element_text(size = 11, color = "#666666", hjust = 0),
      plot.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      legend.position = "none"
    )

  # Add labels if requested
  if (show_hex || show_names) {
    p <- p + ggplot2::geom_text(
      ggplot2::aes(label = label, color = I(text_color)),
      size = if (compact) 2 else 3,
      fontface = "bold",
      lineheight = 0.9
    )
  }

  # Add title
  if (show_all) {
    p <- p + ggplot2::labs(
      title = "CPAL Color Palettes",
      subtitle = "Categorical, Sequential, and Diverging palettes for data visualization"
    )
  } else if (length(palettes_to_show) == 1) {
    p <- p + ggplot2::labs(
      title = paste("CPAL Palette:", palettes_to_show)
    )
  } else {
    p <- p + ggplot2::labs(
      title = "Selected CPAL Palettes"
    )
  }

  p
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
#' \dontrun{
#' quick_palette("main")
#' quick_palette("teal_seq_6", n_colors = 3)
#' }
quick_palette <- function(palette, n_colors = NULL) {
  colors <- cpal_colors(palette)

  if (!is.null(n_colors) && n_colors < length(colors)) {
    colors <- colors[1:n_colors]
  }

  old_par <- par(no.readonly = TRUE)
  on.exit(par(old_par))

  n <- length(colors)
  par(mar = c(1, 1, 3, 1))

  barplot(rep(1, n), col = colors, border = "white", space = 0.1,
          axes = FALSE, main = paste("CPAL", toupper(palette)),
          cex.main = 1.2, horiz = FALSE)

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
#' list_cpal_palettes()
#' list_cpal_palettes(details = TRUE)
list_cpal_palettes <- function(details = FALSE) {
  palette_info <- list(
    # Categorical palettes
    "primary" = list(name = "Brand Colors", type = "Categorical", colors = 6,
                     description = "Core CPAL brand colors"),
    "main" = list(name = "Main Categorical (8)", type = "Categorical", colors = 8,
                  description = "Full categorical palette for data visualization"),
    "main_3" = list(name = "Main (3 colors)", type = "Categorical", colors = 3,
                    description = "Minimal categorical for simple comparisons"),
    "main_4" = list(name = "Main (4 colors)", type = "Categorical", colors = 4,
                    description = "Compact categorical for moderate comparisons"),
    "main_5" = list(name = "Main (5 colors)", type = "Categorical", colors = 5,
                    description = "Standard categorical for most use cases"),
    "main_6" = list(name = "Main (6 colors)", type = "Categorical", colors = 6,
                    description = "Extended categorical for complex comparisons"),
    "blues" = list(name = "Blues", type = "Categorical", colors = 2,
                   description = "Midnight and deep teal for blue comparisons"),
    "compare" = list(name = "Compare", type = "Categorical", colors = 2,
                     description = "Warm gray and deep teal for before/after"),
    "binary" = list(name = "Binary", type = "Categorical", colors = 2,
                    description = "Sage (positive) and coral (negative)"),
    "status" = list(name = "Status", type = "Categorical", colors = 4,
                    description = "Success, warning, error, and info colors"),
    # Sequential palettes
    "midnight_seq_4" = list(name = "Midnight Sequential (4)", type = "Sequential", colors = 4,
                            description = "Light to dark midnight progression"),
    "midnight_seq_5" = list(name = "Midnight Sequential (5)", type = "Sequential", colors = 5,
                            description = "Light to dark midnight progression"),
    "midnight_seq_6" = list(name = "Midnight Sequential (6)", type = "Sequential", colors = 6,
                            description = "Light to dark midnight progression"),
    "midnight_seq_8" = list(name = "Midnight Sequential (8)", type = "Sequential", colors = 8,
                            description = "Full midnight progression"),
    # Diverging palettes
    "coral_midnight_3" = list(name = "Coral-Midnight Diverging (3)", type = "Diverging", colors = 3,
                              description = "Coral to midnight with neutral center"),
    "coral_midnight_5" = list(name = "Coral-Midnight Diverging (5)", type = "Diverging", colors = 5,
                              description = "Coral to midnight with neutral center"),
    "coral_midnight_7" = list(name = "Coral-Midnight Diverging (7)", type = "Diverging", colors = 7,
                              description = "Coral to midnight with neutral center"),
    "coral_midnight_9" = list(name = "Coral-Midnight Diverging (9)", type = "Diverging", colors = 9,
                              description = "Full coral to midnight diverging"),
    # Legacy palettes (backward compatibility)
    "main_gray" = list(name = "Main + Gray (Legacy)", type = "Categorical", colors = 6,
                       description = "Legacy palette with warm gray"),
    "teal_seq_5" = list(name = "Teal Sequential (Legacy)", type = "Sequential", colors = 5,
                        description = "Legacy alias for midnight_seq_5"),
    "pink_teal_5" = list(name = "Pink-Teal Diverging (Legacy)", type = "Diverging", colors = 5,
                         description = "Legacy alias for coral_midnight_5")
  )

  if (details) {
    return(palette_info)
  } else {
    return(names(palette_info))
  }
}

# ============================================================================
# Unified Palette Accessor
# ============================================================================

#' Get All CPAL Palettes
#'
#' Unified accessor for all CPAL color palettes. Returns palettes organized
#' by type (sequential, diverging, categorical) or a specific palette by name.
#'
#' @param name Character. Optional name of specific palette to retrieve.
#'   If NULL (default), returns all palettes organized by type.
#' @param type Character. Filter palettes by type: "all", "sequential",
#'   "diverging", or "categorical". Ignored if `name` is specified.
#'
#' @return If `name` is specified, returns a character vector of colors.
#'   Otherwise, returns a list of palettes organized by type.
#'
#' @export
#'
#' @examples
#' # Get all palettes organized by type
#' cpal_palettes()
#'
#' # Get only sequential palettes
#' cpal_palettes(type = "sequential")
#'
#' # Get a specific palette by name
#' cpal_palettes("teal_seq_5")
#' cpal_palettes("main")
cpal_palettes <- function(name = NULL, type = c("all", "sequential", "diverging", "categorical")) {
  type <- match.arg(type)

  # If specific palette requested, return it directly
  if (!is.null(name)) {
    return(cpal_colors(name))
  }

  # Build palette collection
  all_palettes <- list(
    sequential = cpal_palettes_sequential(),
    diverging = cpal_palettes_diverging(),
    categorical = cpal_palettes_categorical()
  )

  # Filter by type if requested
  if (type == "all") {
    return(all_palettes)
  } else {
    return(all_palettes[[type]])
  }
}

# ============================================================================
# Color Validation Functions
# ============================================================================

#' Validate Color Contrast for Accessibility
#'
#' Checks if colors meet WCAG contrast requirements. Calculates the contrast
#' ratio between foreground and background colors and reports whether they
#' meet AA or AAA accessibility standards.
#'
#' @param foreground Character. Hex color code for foreground (text/element).
#' @param background Character. Hex color code for background.
#' @param level Character. WCAG level to check: "AA" (4.5:1) or "AAA" (7:1).
#' @param large_text Logical. If TRUE, uses large text thresholds (3:1 for AA, 4.5:1 for AAA).
#'
#' @return List with contrast ratio, pass/fail status, and recommendations.
#'
#' @export
#'
#' @examples
#' # Check if teal text on white passes AA
#' validate_color_contrast("#007A8C", "#FFFFFF")
#'
#' # Check AAA compliance
#' validate_color_contrast("#004855", "#FFFFFF", level = "AAA")
validate_color_contrast <- function(foreground, background,
                                     level = c("AA", "AAA"),
                                     large_text = FALSE) {
  level <- match.arg(level)

  # Convert hex to RGB
  hex_to_rgb <- function(hex) {
    hex <- gsub("^#", "", hex)
    r <- strtoi(substr(hex, 1, 2), 16L)
    g <- strtoi(substr(hex, 3, 4), 16L)
    b <- strtoi(substr(hex, 5, 6), 16L)
    c(r, g, b)
  }

  # Calculate relative luminance (WCAG formula)
  relative_luminance <- function(rgb) {
    rgb_norm <- rgb / 255
    rgb_linear <- ifelse(
      rgb_norm <= 0.03928,
      rgb_norm / 12.92,
      ((rgb_norm + 0.055) / 1.055)^2.4
    )
    0.2126 * rgb_linear[1] + 0.7152 * rgb_linear[2] + 0.0722 * rgb_linear[3]
  }

  # Calculate contrast ratio
  fg_rgb <- hex_to_rgb(foreground)
  bg_rgb <- hex_to_rgb(background)

  fg_lum <- relative_luminance(fg_rgb)
  bg_lum <- relative_luminance(bg_rgb)

  lighter <- max(fg_lum, bg_lum)
  darker <- min(fg_lum, bg_lum)
  contrast_ratio <- (lighter + 0.05) / (darker + 0.05)

  # Determine thresholds
  if (large_text) {
    threshold_aa <- 3.0
    threshold_aaa <- 4.5
  } else {
    threshold_aa <- 4.5
    threshold_aaa <- 7.0
  }

  threshold <- if (level == "AA") threshold_aa else threshold_aaa

  # Build result
  result <- list(
    foreground = foreground,
    background = background,
    contrast_ratio = round(contrast_ratio, 2),
    level = level,
    large_text = large_text,
    threshold = threshold,
    passes = contrast_ratio >= threshold,
    recommendation = NULL
  )

  # Add recommendation
  if (result$passes) {
    result$recommendation <- sprintf(
      "Passes WCAG %s (ratio: %.2f:1, required: %.1f:1)",
      level, contrast_ratio, threshold
    )
  } else {
    result$recommendation <- sprintf(
      "FAILS WCAG %s (ratio: %.2f:1, required: %.1f:1). Consider using darker foreground or lighter background.",
      level, contrast_ratio, threshold
    )
  }

  result
}

#' Validate All CPAL Palette Colors
#'
#' Checks all colors in CPAL palettes for accessibility against white and
#' dark backgrounds. Returns a summary of which colors pass WCAG requirements.
#'
#' @param level Character. WCAG level to check: "AA" or "AAA".
#' @param verbose Logical. Print detailed results (default: TRUE).
#'
#' @return Data frame with validation results for each color.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Check all palette colors against AA standard
#' validate_brand_colors()
#'
#' # Check against stricter AAA standard
#' validate_brand_colors(level = "AAA")
#' }
validate_brand_colors <- function(level = c("AA", "AAA"), verbose = TRUE) {
  level <- match.arg(level)

  # Get all extended colors
  colors <- cpal_colors_extended()

  # Test backgrounds
  white_bg <- "#FFFFFF"
  dark_bg <- "#1A1A1A"

  results <- data.frame(
    color_name = names(colors),
    hex = unname(colors),
    passes_on_white = NA,
    contrast_white = NA,
    passes_on_dark = NA,
    contrast_dark = NA,
    stringsAsFactors = FALSE
  )

  for (i in seq_along(colors)) {
    # Check on white background
    white_check <- validate_color_contrast(colors[i], white_bg, level = level)
    results$passes_on_white[i] <- white_check$passes
    results$contrast_white[i] <- white_check$contrast_ratio

    # Check on dark background
    dark_check <- validate_color_contrast(colors[i], dark_bg, level = level)
    results$passes_on_dark[i] <- dark_check$passes
    results$contrast_dark[i] <- dark_check$contrast_ratio
  }

  if (verbose) {
    cli::cli_h3("CPAL Brand Color Accessibility Report (WCAG {level})")

    # Count passes
    white_pass <- sum(results$passes_on_white)
    dark_pass <- sum(results$passes_on_dark)
    total <- nrow(results)

    cli::cli_alert_info("On white background: {white_pass}/{total} colors pass")
    cli::cli_alert_info("On dark background: {dark_pass}/{total} colors pass")

    # Show failing colors
    white_fails <- results[!results$passes_on_white, ]
    if (nrow(white_fails) > 0) {
      cli::cli_text("")
      cli::cli_alert_warning("Colors that fail on white background:")
      for (i in seq_len(nrow(white_fails))) {
        cli::cli_li("{white_fails$color_name[i]} ({white_fails$hex[i]}) - ratio: {white_fails$contrast_white[i]}:1")
      }
    }

    dark_fails <- results[!results$passes_on_dark, ]
    if (nrow(dark_fails) > 0) {
      cli::cli_text("")
      cli::cli_alert_warning("Colors that fail on dark background:")
      for (i in seq_len(nrow(dark_fails))) {
        cli::cli_li("{dark_fails$color_name[i]} ({dark_fails$hex[i]}) - ratio: {dark_fails$contrast_dark[i]}:1")
      }
    }
  }

  invisible(results)
}

# ============================================================================
# Color Interpolation Functions
# ============================================================================

#' Generate Color Ramp Between CPAL Colors
#'
#' Creates a smooth gradient of colors between two specified colors.
#' Useful for creating custom continuous color scales.
#'
#' @param from Character. Starting color (hex code or CPAL color name).
#' @param to Character. Ending color (hex code or CPAL color name).
#' @param n Integer. Number of colors to generate (default: 5).
#' @param include_ends Logical. Include the start and end colors (default: TRUE).
#'
#' @return Character vector of hex color codes.
#'
#' @export
#'
#' @examples
#' # Generate 5 colors from coral to midnight
#' cpal_color_ramp("coral", "midnight", n = 5)
#'
#' # Generate 10 colors from a light to dark midnight
#' cpal_color_ramp("midnight_1", "midnight", n = 10)
#'
#' # Use custom hex codes
#' cpal_color_ramp("#FFFFFF", "#004855", n = 7)
cpal_color_ramp <- function(from, to, n = 5, include_ends = TRUE) {
  # Resolve color names to hex codes
  resolve_color <- function(color) {
    if (grepl("^#[0-9A-Fa-f]{6}$", color)) {
      return(color)
    }
    # Try to get from extended palette
    extended <- cpal_colors_extended()
    if (color %in% names(extended)) {
      return(extended[[color]])
    }
    # Try primary palette
    primary <- cpal_colors_primary()
    if (color %in% names(primary)) {
      return(primary[[color]])
    }
    cli::cli_abort("Color '{color}' not found. Use a hex code or CPAL color name.")
  }

  from_hex <- resolve_color(from)
  to_hex <- resolve_color(to)

  # Generate color ramp
  ramp_func <- colorRampPalette(c(from_hex, to_hex))
  colors <- ramp_func(n)

  if (!include_ends && n > 2) {
    # Remove first and last if not including ends
    colors <- colors[2:(n - 1)]
  }

  return(colors)
}

#' Create Multi-Color Gradient
#'
#' Creates a smooth gradient through multiple colors. Useful for creating
#' custom palettes that transition through several CPAL brand colors.
#'
#' @param colors Character vector. Colors to transition through (hex codes or CPAL names).
#' @param n Integer. Total number of colors to generate (default: length(colors) * 2).
#'
#' @return Character vector of hex color codes.
#'
#' @export
#'
#' @examples
#' # Create gradient through brand colors
#' cpal_color_gradient(c("coral", "neutral", "midnight"), n = 9)
#'
#' # Create extended sequential palette
#' cpal_color_gradient(c("midnight_1", "deep_teal", "midnight"), n = 12)
cpal_color_gradient <- function(colors, n = NULL) {
  if (is.null(n)) {
    n <- length(colors) * 2
  }

  if (n < length(colors)) {
    cli::cli_abort("n must be at least {length(colors)} (number of input colors)")
  }

  # Resolve all colors to hex
  resolve_color <- function(color) {
    if (grepl("^#[0-9A-Fa-f]{6}$", color)) {
      return(color)
    }
    extended <- cpal_colors_extended()
    if (color %in% names(extended)) {
      return(extended[[color]])
    }
    primary <- cpal_colors_primary()
    if (color %in% names(primary)) {
      return(primary[[color]])
    }
    cli::cli_abort("Color '{color}' not found. Use a hex code or CPAL color name.")
  }

  hex_colors <- sapply(colors, resolve_color, USE.NAMES = FALSE)

  # Generate gradient
  ramp_func <- colorRampPalette(hex_colors)
  ramp_func(n)
}
