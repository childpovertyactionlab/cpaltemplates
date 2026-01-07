#' @importFrom magrittr %>%
#' @importFrom gt gt tab_header tab_source_note tab_options cols_align opt_row_striping px
NULL

#' CPAL GT Table
#'
#' Generates a static, publication-quality table using the `gt` framework,
#' styled according to CPAL brand guidelines.
#'
#' @param data A data frame or tibble.
#' @param title Character. The main title of the table.
#' @param subtitle Character. The subtitle of the table (appears below the title).
#' @param source Character. Source attribution text; automatically prefixed with "Source: ".
#'
#' @return A `gt_tbl` object.
#'
#' @family Tables
#' @seealso [cpal_table_reactable()] for interactive versions.
#'
#' @export
cpal_table_gt <- function(data,
                          title            = NULL,
                          subtitle         = NULL,
                          source           = NULL) {
  # Create GT table with modern foundation
  gt_table <- data %>%
    gt()

  # Add title, subtitle, source
  if (!is.null(title) || !is.null(subtitle)) {
    gt_table <- gt_table %>%
      tab_header(title = title, subtitle = subtitle)
  }

  if (!is.null(source)) {
    gt_table <- gt_table %>%
      tab_source_note(source_note = paste("Source:", source))
  }

  return(gt_table)
}

#' CPAL Reactable Table - Complete Interactive Table System
#'
#' Creates a CPAL-styled interactive table using `reactable`. This function 
#' integrates with the CPAL SCSS theme and provides advanced features like 
#' row highlighting and data bars.
#'
#' @param data Data frame to display.
#' @param title Character. Optional table title rendered as an <h3> tag.
#' @param subtitle Character. Optional table subtitle rendered as a <p> tag.
#' @param source Character. Optional source attribution rendered in the footer.
#' @param highlight_columns Character vector. Names of columns to apply specific highlighting.
#' @param bold_rows Column name (string). Column should contain 1/0 values; 1 triggers a highlighted background.
#' @param bold_only_rows Column name (string). Column should contain 1/0 values; 1 triggers bold text only.
#' @param data_bar_columns Character vector. Names of columns to render as inline data bars.
#' @param searchable Logical. Enable a global search bar (default: TRUE).
#' @param pagination Logical. Enable pagination (default: TRUE).
#' @param page_size Integer. Number of rows per page (default: 10).
#' @param sortable Logical. Enable column sorting (default: TRUE).
#' @param filterable Logical. Enable per-column filtering (default: FALSE).
#' @param show_page_size_options Logical. Show the "rows per page" selector (default: TRUE).
#' @param striped Logical. Enable zebra-striping for rows (default: FALSE).
#' @param compact Logical. Use reduced cell padding (default: FALSE).
#' @param ... Additional arguments passed to [reactable::reactable()].
#'
#' @return A `reactable` HTML widget object.
#' 
#' @section Custom Styling:
#' This function applies the CSS class `.reactable-cpal` to the container. 
#' Styling (colors, fonts) should be managed via the `cpal-enhanced.scss` file.
#'
#' @importFrom reactable reactable reactableTheme
#' @importFrom htmltools tags
#' @importFrom htmlwidgets prependContent appendContent
#' 
#' @family Tables
#' @export
#'
#' @examples
#' # Basic interactive table
#' cpal_table_reactable(mtcars, title = "Car Data", source = "Motor Trend")
#'
#' # All features combined
#' mtcars$high_performance <- ifelse(mtcars$hp > 200, 1, 0)
#' cpal_table_reactable(mtcars,
#'                      title = "Complete Car Analysis",
#'                      source = "CPAL Data Team",
#'                      highlight_columns = c("mpg", "hp"),
#'                      bold_rows = "high_performance",
#'                      filterable = TRUE)
cpal_table_reactable <- function(data,
                                 title            = NULL,
                                 subtitle         = NULL,
                                 source           = NULL,
                                 highlight_columns = NULL,
                                 bold_rows        = NULL,
                                 bold_only_rows   = NULL,
                                 data_bar_columns = NULL,

                                 # Interactive features
                                 searchable       = TRUE,
                                 pagination       = TRUE,
                                 page_size        = 10,
                                 sortable         = TRUE,
                                 filterable       = FALSE,
                                 show_page_size_options = TRUE,
                                 striped          = FALSE,
                                 compact          = FALSE,
                                 ...) {
  # Load required packages
  if (!requireNamespace("reactable", quietly = TRUE)) {
    stop("Package 'reactable' is required but not installed.")
  }
  if (!requireNamespace("htmltools", quietly = TRUE)) {
    stop("Package 'htmltools' is required but not installed.")
  }

  header_block <- if (!is.null(title) || !is.null(subtitle)) {
    # Use standard CSS classes for header elements instead of inline styles
    htmltools::tags$div(class = "cpal-table-header", if (!is.null(title)) {
      htmltools::tags$h3(title, class = "cpal-table-title")
    }, if (!is.null(subtitle)) {
      htmltools::tags$p(subtitle, class = "cpal-table-subtitle")
    })
  } else {
    NULL
  }

  footer_block <- if (!is.null(source)) {
    # Use standard CSS class for footer element
    htmltools::tags$div(class = "cpal-table-footer", paste("Source:", source))
  } else {
    NULL
  }

  # Build the table
  reactable_table <- reactable::reactable(
    data,
    height = 530,
    showSortable = TRUE,
    searchable = searchable,
    pagination = pagination,
    defaultPageSize = page_size,
    showPageSizeOptions = show_page_size_options,
    pageSizeOptions = c(10, 15, 25, 50),
    striped = striped,
    compact = compact,
    highlight = TRUE,

    # Apply a base class name to the entire table for global theming control
    # 'reactable-cpal' class is used as a hook for all our SCSS styles
    class = "reactable-cpal",

    # If a custom theme object is still desired for specific reactable options not available via CSS,
    # it can be defined here without color values
    theme = reactable::reactableTheme(
      headerStyle = list(
        fontWeight = "bold",
        textAlign = "center",
        borderRadius = "0"
      ),

      searchInputStyle = list(width = "30%"),

      pageButtonActiveStyle = list(fontWeight = "700")
    ),
    ...
  )

  # Inject header and footer
  if (!is.null(header_block)) {
    reactable_table <- htmlwidgets::prependContent(reactable_table, header_block)
  }
  if (!is.null(footer_block)) {
    reactable_table <- htmlwidgets::appendContent(reactable_table, footer_block)
  }

  return(reactable_table)
}
