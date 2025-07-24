
#' Create interactive CPAL plots with ggiraph
#'
#' Wrapper functions to create interactive versions of ggplot2 plots
#' while maintaining CPAL styling
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
          "font-family:Inter, Arial, sans-serif;",
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

#' Interactive table with reactable
#' 
#' Create an interactive table with CPAL styling using reactable
#' 
#' @param data Data frame to display
#' @param ... Additional arguments passed to reactable()
#' @return A reactable object
#' @export
cpal_table_interactive <- function(data, ...) {
  if (!requireNamespace("reactable", quietly = TRUE)) {
    stop("Package 'reactable' is required. Install with: install.packages('reactable')")
  }
  
  reactable::reactable(
    data,
    theme = reactable::reactableTheme(
      color = "#222222",
      backgroundColor = "white",
      borderColor = "#E7ECEE",
      stripedColor = "#f8f8f8",
      highlightColor = "#FFF4F0",  # Light tint of CPAL orange
      headerStyle = list(
        backgroundColor = "#004855",
        color = "white",
        fontWeight = "bold",
        fontFamily = "Inter, Arial, sans-serif",
        borderColor = "#004855"
      ),
      style = list(
        fontFamily = "Inter, Arial, sans-serif"
      ),
      searchInputStyle = list(
        width = "100%"
      )
    ),
    defaultPageSize = 10,
    showPageInfo = TRUE,
    searchable = TRUE,
    striped = TRUE,
    highlight = TRUE,
    bordered = TRUE,
    ...
  )
}

