#' CPAL GT Table
#'
#' Creates a CPAL-styled GT table.
#'
#' @param data Data frame
#' @param title Table title
#' @param subtitle Table subtitle
#' @param source Source note
#' @return GT table object
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
#' Creates a CPAL-styled interactive table with modern foundation and smart features.
#' Sister function to cpal_table_gt() with enhanced interactivity.
#'
#' @param data Data frame to display
#' @param title Optional table title
#' @param subtitle Optional table subtitle
#' @param source Optional source attribution
#' @param bold_rows Column name containing 1/0 values for row highlighting with background (optional)
#' @param bold_only_rows Column name containing 1/0 values for bold text only (no background) (optional)
#' @param bold_color Color for bold text
#' @param searchable Enable search functionality (default: TRUE)
#' @param pagination Enable pagination (default: TRUE)
#' @param page_size Default number of rows per page (default: 10)
#' @param sortable Enable column sorting (default: TRUE)
#' @param filterable Enable column filtering (default: FALSE)
#' @param show_page_size_options Show page size selector (default: TRUE)
#' @param striped Enable striped rows (default: FALSE)
#' @param compact Use compact styling (default: FALSE)
#' @return Reactable table object with CPAL styling
#' @export
#'
#' @examples
#' # Basic interactive table
#' cpal_table_reactable(mtcars, title = "Car Data", source = "Motor Trend")
#'
#'
#' # With row highlighting (requires 1/0 column)
#' mtcars$high_performance <- ifelse(mtcars$hp > 200, 1, 0)
#' cpal_table_reactable(mtcars, bold_rows = "high_performance")
#'
#' # Bold text only (no background)
#' cpal_table_reactable(mtcars, bold_only_rows = "high_performance")
#'
#' # All features combined
#' cpal_table_reactable(mtcars,
#'                      title = "Complete Car Analysis",
#'                      subtitle = "All features working together",
#'                      source = "CPAL Data Team",
#'                      highlight_columns = c("mpg", "hp"),
#'                      bold_rows = "high_performance",
#'                      theme = "light",
#'                      filterable = TRUE)
#'
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
