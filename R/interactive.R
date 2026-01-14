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
#' Wrapper for mapgl with CPAL defaults for Dallas area
#'
#' @param style Mapbox style URL or style object
#' @param bounds Initial map bounds (defaults to Dallas area)
#' @param ... Additional arguments passed to mapboxgl()
#' @return A mapboxgl object
#' @export
cpal_mapgl <- function(style = "mapbox://styles/mapbox/light-v11",
                       bounds = NULL, ...) {
  if (!requireNamespace("mapgl", quietly = TRUE)) {
    stop("Package 'mapgl' is required. Install with: remotes::install_github('walkerke/mapgl')")
  }

  # Default to Dallas area bounds if not specified
  if (is.null(bounds)) {
    bounds <- list(
      west = -97.0,
      east = -96.5,
      south = 32.5,
      north = 33.0
    )
  }

  # Create map with defaults
  mapgl::mapboxgl(
    style = style,
    bounds = bounds,
    ...
  )
}

#' Add CPAL-styled layer to mapgl map
#'
#' Helper function to add a layer with CPAL color defaults
#'
#' @param map A mapboxgl object
#' @param id Layer ID
#' @param source Data source
#' @param type Layer type (fill, line, circle, etc.)
#' @param paint Paint properties
#' @param ... Additional arguments
#' @return Updated mapboxgl object
#' @export
cpal_mapgl_layer <- function(map, id, source, type = "fill",
                             paint = NULL, ...) {
  if (!requireNamespace("mapgl", quietly = TRUE)) {
    stop("Package 'mapgl' is required")
  }

  # Set CPAL color defaults based on layer type
  if (is.null(paint)) {
    paint <- switch(type,
                    fill = list(
                      "fill-color" = "#008097",  # CPAL teal
                      "fill-opacity" = 0.7
                    ),
                    line = list(
                      "line-color" = "#004855",  # CPAL midnight
                      "line-width" = 2
                    ),
                    circle = list(
                      "circle-color" = "#C3257B",  # CPAL pink
                      "circle-radius" = 5,
                      "circle-opacity" = 0.8
                    ),
                    # Default
                    list()
    )
  }

  mapgl::add_layer(
    map = map,
    id = id,
    source = source,
    type = type,
    paint = paint,
    ...
  )
}
