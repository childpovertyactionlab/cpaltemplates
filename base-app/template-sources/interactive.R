#' @section TODO:
#' - Please verify that this function is still needed and works as intended.
#' 
#' Setup CPAL Google Fonts for all plot types
#'
#' Comprehensive font setup that downloads and registers Inter and Roboto
#' from Google Fonts for use in both regular and interactive plots
#'
#' @param force_refresh Logical. Force re-download of fonts (default: FALSE)
#' @param verbose Logical. Show detailed setup messages (default: TRUE)
#' @return List with setup results
#' @export
setup_cpal_google_fonts <- function(force_refresh = FALSE, verbose = TRUE) {

  results <- list(
    inter_regular = FALSE,
    inter_interactive = FALSE,
    roboto_regular = FALSE,
    roboto_interactive = FALSE,
    success = FALSE
  )

  if (verbose) cat("Setting up CPAL Google Fonts...\n")

  # Check required packages
  required_packages <- c("sysfonts", "showtext", "gdtools", "systemfonts")
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

  # Setup fonts for regular plots (showtext/sysfonts)
  if (verbose) cat("Setting up fonts for regular plots...\n")

  tryCatch({
    # Remove existing fonts if force refresh
    if (force_refresh) {
      if (requireNamespace("sysfonts", quietly = TRUE)) {
        if ("Inter" %in% sysfonts::font_families()) {
          # Note: font_rm may not be available in all sysfonts versions
          tryCatch({
            # sysfonts::font_rm("Inter") # Function not available
          }, error = function(e) {
            # Ignore if font_rm not available
          })
        }
        if ("Roboto" %in% sysfonts::font_families()) {
          tryCatch({
            # sysfonts::font_rm("Roboto") # Function not available
          }, error = function(e) {
            # Ignore if font_rm not available
          })
        }
      }
    }

    # Add Inter from Google Fonts
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      if (!"Inter" %in% sysfonts::font_families() || force_refresh) {
        sysfonts::font_add_google("Inter", "Inter")
        if (verbose) cat("   Inter downloaded and registered\n")
      } else {
        if (verbose) cat("   Inter already available\n")
      }
      results$inter_regular <- TRUE
    }

    # Add Roboto from Google Fonts
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      if (!"Roboto" %in% sysfonts::font_families() || force_refresh) {
        sysfonts::font_add_google("Roboto", "Roboto")
        if (verbose) cat("   Roboto downloaded and registered\n")
      } else {
        if (verbose) cat("   Roboto already available\n")
      }
      results$roboto_regular <- TRUE
    }

    # Enable showtext
    if (requireNamespace("showtext", quietly = TRUE)) {
      showtext::showtext_auto()
      if (verbose) cat("   Showtext enabled for regular plots\n")
    }

  }, error = function(e) {
    if (verbose) cat("   Error setting up regular fonts:", e$message, "\n")
  })

  # Setup fonts for interactive plots (gdtools)
  if (verbose) cat("Setting up fonts for interactive plots...\n")

  if (requireNamespace("gdtools", quietly = TRUE)) {
    tryCatch({
      # Register Inter for ggiraph
      gdtools::register_gfont("Inter")
      results$inter_interactive <- TRUE
      if (verbose) cat("   Inter registered for interactive plots\n")

      # Register Roboto for ggiraph
      gdtools::register_gfont("Roboto")
      results$roboto_interactive <- TRUE
      if (verbose) cat("   Roboto registered for interactive plots\n")

    }, error = function(e) {
      if (verbose) cat("   Interactive font registration:", e$message, "\n")
      if (verbose) cat("   Interactive plots will use fallback fonts\n")
    })
  } else {
    if (verbose) cat("   gdtools not available for interactive fonts\n")
  }

  # Overall success check
  results$success <- (results$inter_regular || results$roboto_regular) &&
    (results$inter_interactive || results$roboto_interactive)

  if (verbose) {
    if (results$success) {
      cat("CPAL Google Fonts setup complete!\n")
      cat("   Primary: Inter | Secondary: Roboto\n")
    } else {
      cat("Partial font setup - some fonts may not be available\n")
    }
  }

  return(invisible(results))
}

#' @section TODO:
#' - Please verify that this function is still needed and works as intended.
#' 
#' Get CPAL font family with Google Fonts priority
#'
#' Returns the best available CPAL font with Inter priority and Roboto fallback
#'
#' @param for_interactive Logical. Optimize for ggiraph compatibility
#' @param setup_if_missing Logical. Try to setup fonts if not available (default: TRUE)
#' @return Character string with font family
#' @export
get_cpal_font_family <- function(for_interactive = FALSE, setup_if_missing = TRUE) {

  # Try Inter first
  inter_available <- FALSE
  roboto_available <- FALSE

  if (for_interactive) {
    # Check ggiraph font availability
    if (requireNamespace("gdtools", quietly = TRUE)) {
      tryCatch({
        registered_fonts <- gdtools::sys_fonts()
        inter_available <- "Inter" %in% registered_fonts
        roboto_available <- "Roboto" %in% registered_fonts
      }, error = function(e) {
        # gdtools check failed
      })
    }
  } else {
    # Check showtext font availability
    if (requireNamespace("sysfonts", quietly = TRUE)) {
      available_fonts <- sysfonts::font_families()
      inter_available <- "Inter" %in% available_fonts
      roboto_available <- "Roboto" %in% available_fonts
    }
  }

  # If fonts not available and setup allowed, try to set them up
  if ((!inter_available && !roboto_available) && setup_if_missing) {
    setup_result <- setup_cpal_google_fonts(verbose = FALSE)

    # Recheck availability after setup
    if (for_interactive) {
      if (requireNamespace("gdtools", quietly = TRUE)) {
        tryCatch({
          registered_fonts <- gdtools::sys_fonts()
          inter_available <- "Inter" %in% registered_fonts
          roboto_available <- "Roboto" %in% registered_fonts
        }, error = function(e) {})
      }
    } else {
      if (requireNamespace("sysfonts", quietly = TRUE)) {
        available_fonts <- sysfonts::font_families()
        inter_available <- "Inter" %in% available_fonts
        roboto_available <- "Roboto" %in% available_fonts
      }
    }
  }

  # Return best available font
  if (inter_available) {
    return("Inter")
  } else if (roboto_available) {
    return("Roboto")
  } else {
    return("sans")  # Final fallback
  }
}

#' @section TODO:
#' - Please verify that this function is still needed and works as intended.
#' 
#' Create interactive CPAL plots with ggiraph
#'
#' Wrapper functions to create interactive versions of ggplot2 plots
#' while maintaining CPAL styling. Uses Google Fonts (Inter/Roboto) automatically.
#'
#' @param plot A ggplot2 object to make interactive
#' @param width_svg SVG width in inches (default: 8)
#' @param height_svg SVG height in inches (default: 5)
#' @param ... Additional arguments passed to girafe()
#' @return A girafe object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(ggiraph)
#'
#' p <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point_interactive(aes(tooltip = rownames(mtcars))) +
#'   theme_cpal()
#'
#' cpal_interactive(p)
#' }
cpal_interactive <- function(plot, width_svg = 8, height_svg = 5, ...) {
  if (!requireNamespace("ggiraph", quietly = TRUE)) {
    stop("Package 'ggiraph' is required. Install with: install.packages('ggiraph')")
  }

  # Get CPAL font family optimized for interactive plots
  primary_font <- get_cpal_font_family(for_interactive = TRUE, setup_if_missing = TRUE)

  # Create font family string with fallbacks
  if (primary_font == "Inter") {
    font_family <- "Inter, Roboto, sans-serif"
  } else if (primary_font == "Roboto") {
    font_family <- "Roboto, sans-serif"
  } else {
    font_family <- "sans-serif"
  }

  # Safely handle showtext disable/enable for ggiraph compatibility
  showtext_was_enabled <- FALSE
  if (requireNamespace("showtext", quietly = TRUE)) {
    tryCatch({
      showtext_status <- showtext::showtext_auto()
      # Robust check for showtext status
      if (length(showtext_status) > 0 &&
          !is.na(showtext_status) &&
          is.logical(showtext_status) &&
          showtext_status) {
        showtext_was_enabled <- TRUE
        showtext::showtext_auto(FALSE)
        # Set up proper restoration
        on.exit({
          if (requireNamespace("showtext", quietly = TRUE)) {
            showtext::showtext_auto(TRUE)
          }
        }, add = TRUE)
      }
    }, error = function(e) {
      # If showtext operations fail, just continue
    })
  }

  # Default ggiraph options for CPAL styling
  ggiraph::girafe(
    ggobj = plot,
    width_svg = width_svg,
    height_svg = height_svg,
    options = list(
      ggiraph::opts_hover(
        css = "fill:#ED683F;stroke:#ED683F;cursor:pointer;"  # CPAL orange on hover
      ),
      ggiraph::opts_tooltip(
        css = paste0(
          "background-color:#004855;",  # CPAL midnight
          "color:white;",
          "padding:10px;",
          "border-radius:5px;",
          "font-family:", font_family, ";",
          "font-size:14px;"
        ),
        opacity = 0.95
      ),
      ggiraph::opts_toolbar(
        position = "topright",
        saveaspng = TRUE
      ),
      ggiraph::opts_selection(
        type = "single",
        css = "fill:#C3257B;stroke:#C3257B;"  # CPAL pink for selection
      )
    ),
    ...
  )
}

#' Interactive geometry layers with CPAL defaults
#'
#' These are convenience wrappers around ggiraph interactive geoms
#' that make it easier to add interactivity with consistent styling
#'
#' @return Interactive ggplot2 layer objects with CPAL styling and ggiraph interactivity
#' @name cpal_geom_interactive
NULL

#' @rdname cpal_geom_interactive
#' @param mapping Set of aesthetic mappings created by aes()
#' @param data The data to be displayed in this layer
#' @param tooltip_var Variable to use for tooltips
#' @param onclick_var Variable to use for click actions
#' @param data_id_var Variable to use for data IDs (for linking)
#' @param ... Other arguments passed to the geom
#' @export
cpal_point_interactive <- function(mapping = NULL, data = NULL,
                                   tooltip_var = NULL,
                                   onclick_var = NULL,
                                   data_id_var = NULL, ...) {
  if (!requireNamespace("ggiraph", quietly = TRUE)) {
    stop("Package 'ggiraph' is required")
  }

  # Build interactive aesthetics
  if (!is.null(tooltip_var) || !is.null(onclick_var) || !is.null(data_id_var)) {
    if (is.null(mapping)) mapping <- ggplot2::aes()

    if (!is.null(tooltip_var)) {
      mapping$tooltip <- substitute(tooltip_var)
    }
    if (!is.null(onclick_var)) {
      mapping$onclick <- substitute(onclick_var)
    }
    if (!is.null(data_id_var)) {
      mapping$data_id <- substitute(data_id_var)
    }
  }

  ggiraph::geom_point_interactive(mapping = mapping, data = data, ...)
}

#' @rdname cpal_geom_interactive
#' @export
cpal_col_interactive <- function(mapping = NULL, data = NULL,
                                 tooltip_var = NULL,
                                 onclick_var = NULL,
                                 data_id_var = NULL, ...) {
  if (!requireNamespace("ggiraph", quietly = TRUE)) {
    stop("Package 'ggiraph' is required")
  }

  if (!is.null(tooltip_var) || !is.null(onclick_var) || !is.null(data_id_var)) {
    if (is.null(mapping)) mapping <- ggplot2::aes()

    if (!is.null(tooltip_var)) {
      mapping$tooltip <- substitute(tooltip_var)
    }
    if (!is.null(onclick_var)) {
      mapping$onclick <- substitute(onclick_var)
    }
    if (!is.null(data_id_var)) {
      mapping$data_id <- substitute(data_id_var)
    }
  }

  ggiraph::geom_col_interactive(mapping = mapping, data = data, ...)
}

#' @rdname cpal_geom_interactive
#' @export
cpal_line_interactive <- function(mapping = NULL, data = NULL,
                                  tooltip_var = NULL,
                                  onclick_var = NULL,
                                  data_id_var = NULL, ...) {
  if (!requireNamespace("ggiraph", quietly = TRUE)) {
    stop("Package 'ggiraph' is required")
  }

  if (!is.null(tooltip_var) || !is.null(onclick_var) || !is.null(data_id_var)) {
    if (is.null(mapping)) mapping <- ggplot2::aes()

    if (!is.null(tooltip_var)) {
      mapping$tooltip <- substitute(tooltip_var)
    }
    if (!is.null(onclick_var)) {
      mapping$onclick <- substitute(onclick_var)
    }
    if (!is.null(data_id_var)) {
      mapping$data_id <- substitute(data_id_var)
    }
  }

  ggiraph::geom_line_interactive(mapping = mapping, data = data, ...)
}

#' @rdname cpal_geom_interactive
#' @export
cpal_polygon_interactive <- function(mapping = NULL, data = NULL,
                                     tooltip_var = NULL,
                                     onclick_var = NULL,
                                     data_id_var = NULL, ...) {
  if (!requireNamespace("ggiraph", quietly = TRUE)) {
    stop("Package 'ggiraph' is required")
  }

  if (!is.null(tooltip_var) || !is.null(onclick_var) || !is.null(data_id_var)) {
    if (is.null(mapping)) mapping <- ggplot2::aes()

    if (!is.null(tooltip_var)) {
      mapping$tooltip <- substitute(tooltip_var)
    }
    if (!is.null(onclick_var)) {
      mapping$onclick <- substitute(onclick_var)
    }
    if (!is.null(data_id_var)) {
      mapping$data_id <- substitute(data_id_var)
    }
  }

  ggiraph::geom_polygon_interactive(mapping = mapping, data = data, ...)
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
