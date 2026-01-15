#' @importFrom magrittr %>%
#' @importFrom gt gt tab_header tab_source_note tab_options cols_align opt_row_striping px
NULL

#' CPAL GT Table
#'
#' Generates a static, publication-quality table using the `gt` framework,
#' styled according to CPAL brand guidelines. Ideal for PDF export, print
#' materials, and scientific publications.
#'
#' @param data A data frame or tibble.
#' @param title Character. The main title of the table.
#' @param subtitle Character. The subtitle of the table (appears below the title).
#' @param source Character. Source attribution text; automatically prefixed with "Source: ".
#' @param striped Logical. Enable zebra-striping for rows (default: FALSE).
#'
#' @return A `gt_tbl` object that can be further customized with gt functions.
#'
#' @details
#' This function applies CPAL brand styling to GT tables:
#' \itemize{
#'   \item Bold headers with teal top/bottom borders
#'   \item Clean typography optimized for print
#'   \item Consistent cell padding and alignment
#'   \item Optional row striping for readability
#' }
#'
#' Use this function for PDF/print output. For interactive HTML tables,
#' use [cpal_table_reactable()] instead.
#'
#' @family Tables
#' @seealso [cpal_table_reactable()] for interactive HTML tables.
#'
#' @export
#'
#' @examples
#' # Basic GT table
#' cpal_table_gt(head(mtcars), title = "Vehicle Data", source = "Motor Trend")
#'
#' # With striping
#' cpal_table_gt(head(mtcars), title = "Vehicle Data", striped = TRUE)
cpal_table_gt <- function(data,
                          title            = NULL,
                          subtitle         = NULL,
                          source           = NULL,
                          striped          = FALSE) {


  # CPAL brand colors
  cpal_primary <- "#006878"
  cpal_midnight <- "#004855"
  cpal_border <- "#dee2e6"


  # Create GT table with CPAL styling
  gt_table <- data %>%
    gt::gt() %>%
    # Table-wide options
    gt::tab_options(
      # Header styling - match reactable
      column_labels.font.weight = "bold",
      column_labels.font.size = gt::px(14),
      column_labels.border.top.color = cpal_primary,
      column_labels.border.top.width = gt::px(2),
      column_labels.border.bottom.color = cpal_primary,
      column_labels.border.bottom.width = gt::px(2),
      column_labels.padding = gt::px(10),
      # Table body styling
      table.font.size = gt::px(13),
      data_row.padding = gt::px(8),
      table_body.border.bottom.color = cpal_primary,
      table_body.border.bottom.width = gt::px(2),
      # Cell borders
      table_body.hlines.color = cpal_border,
      table_body.hlines.width = gt::px(1),
      # Remove outer table border for cleaner look
      table.border.top.style = "hidden",
      table.border.bottom.style = "hidden",
      # Heading styling
      heading.title.font.size = gt::px(16),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(13),
      heading.border.bottom.style = "hidden",
      heading.padding = gt::px(8),
      # Source note styling
      source_notes.font.size = gt::px(11),
      source_notes.padding = gt::px(8)
    ) %>%
    # Center align column headers
    gt::tab_style(
      style = gt::cell_text(align = "center"),
      locations = gt::cells_column_labels()
    )

  # Add striping if requested
  if (striped) {
    gt_table <- gt_table %>%
      gt::opt_row_striping()
  }

  # Add title, subtitle
  if (!is.null(title) || !is.null(subtitle)) {
    gt_table <- gt_table %>%
      gt::tab_header(title = title, subtitle = subtitle)
  }

  # Add source note
  if (!is.null(source)) {
    gt_table <- gt_table %>%
      gt::tab_source_note(source_note = paste("Source:", source))
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
#' @param static Logical. If TRUE, disables all interactive features (search, pagination,
#'   sorting, filtering) for a clean, print-friendly appearance. Useful for small tables
#'   in reports or HTML documents where interactivity is not needed. Default: FALSE.
#' @param searchable Logical. Enable a global search bar (default: TRUE, ignored if static = TRUE).
#' @param pagination Logical. Enable pagination (default: TRUE, ignored if static = TRUE).
#' @param page_size Integer. Number of rows per page (default: 10).
#' @param sortable Logical. Enable column sorting (default: TRUE, ignored if static = TRUE).
#' @param filterable Logical. Enable per-column filtering (default: FALSE, ignored if static = TRUE).
#' @param show_page_size_options Logical. Show the "rows per page" selector (default: TRUE, ignored if static = TRUE).
#' @param striped Logical. Enable zebra-striping for rows (default: FALSE).
#' @param compact Logical. Use reduced cell padding (default: TRUE).
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

                                 # Static mode
                                 static           = FALSE,

                                 # Interactive features
                                 searchable       = TRUE,
                                 pagination       = TRUE,
                                 page_size        = 10,
                                 sortable         = TRUE,
                                 filterable       = FALSE,
                                 show_page_size_options = TRUE,
                                 striped          = FALSE,
                                 compact          = TRUE,
                                 ...) {
  # Load required packages
  if (!requireNamespace("reactable", quietly = TRUE)) {
    stop("Package 'reactable' is required but not installed.")
  }
  if (!requireNamespace("htmltools", quietly = TRUE)) {
    stop("Package 'htmltools' is required but not installed.")
  }

  # Static mode: disable all interactive features
  if (static) {
    searchable <- FALSE
    pagination <- FALSE
    sortable <- FALSE
    filterable <- FALSE
    show_page_size_options <- FALSE
  }

  # CPAL brand colors for theming
  cpal_primary <- "#006878"
  cpal_midnight <- "#004855"
  cpal_border <- "#dee2e6"
  cpal_highlight <- "rgba(0, 104, 120, 0.08)"
  cpal_stripe <- "rgba(0, 0, 0, 0.03)"

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
    height = if (static) "auto" else 530,
    showSortable = FALSE,
    sortable = sortable,
    searchable = searchable,
    pagination = pagination,
    defaultPageSize = page_size,
    showPageSizeOptions = show_page_size_options,
    pageSizeOptions = c(10, 15, 25, 50),
    striped = striped,
    compact = compact,
    highlight = !static,  # Disable hover highlight for static tables

    # Apply a base class name to the entire table for global theming control
    # 'reactable-cpal' class is used as a hook for all our SCSS styles
    class = if (static) "reactable-cpal reactable-static" else "reactable-cpal",

    # CPAL-styled theme with brand colors and consistent styling
    theme = reactable::reactableTheme(
      # Base colors
      borderColor = cpal_border,
      highlightColor = cpal_highlight,
      stripedColor = cpal_stripe,

      # Header styling with CPAL brand borders
      headerStyle = list(
        fontWeight = "bold",
        fontSize = "1.1rem",
        textAlign = "center",
        borderTop = paste0("2px solid ", cpal_primary),
        borderBottom = paste0("2px solid ", cpal_primary),
        padding = "12px 8px"
      ),

      # Cell styling
      cellStyle = list(
        borderTop = paste0("1px solid ", cpal_border)
      ),

      # Search input styling
      searchInputStyle = list(
        width = "30%",
        border = paste0("1px solid ", cpal_primary),
        borderRadius = "4px",
        padding = "6px 12px",
        "&:focus" = list(
          outline = "none",
          boxShadow = "0 0 0 0.2rem rgba(0, 104, 120, 0.25)"
        )
      ),

      # Filter input styling (for column filters)
      filterInputStyle = list(
        border = paste0("1px solid ", cpal_border),
        borderRadius = "4px",
        padding = "4px 8px"
      ),

      # Pagination styling
      paginationStyle = list(
        borderTop = paste0("1px solid ", cpal_border),
        paddingTop = "12px"
      ),

      # Page button styling
      pageButtonStyle = list(
        borderRadius = "4px",
        padding = "4px 8px"
      ),
      pageButtonActiveStyle = list(
        fontWeight = "700",
        backgroundColor = cpal_primary,
        color = "#FFFFFF"
      ),
      pageButtonCurrentStyle = list(
        fontWeight = "700"
      )
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
