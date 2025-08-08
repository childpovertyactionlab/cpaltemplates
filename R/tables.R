#' CPAL GT Table
#'
#' Creates a CPAL-styled GT table.
#'
#' @param data Data frame
#' @param title Table title
#' @param subtitle Table subtitle
#' @param source Source note
#' @param theme Theme ('light' or 'dark')
#' @param highlight_columns Columns to highlight
#' @param bold_rows Rows to make bold
#' @param bold_color Color for bold text
#' @param row_fill Row fill color
#' @param gradient_direction Gradient direction
#' @param title_font Title font
#' @param data_font Data font
#' @importFrom magrittr %>%
#' @importFrom gt gt tab_header tab_source_note tab_options tab_style opt_css
#' @importFrom gt pct px cell_borders cells_title cell_text cell_fill
#' @importFrom gt cells_column_labels cells_body
#' @importFrom dplyr all_of
#' @importFrom stats quantile
#' @return GT table object
#' @export
cpal_table_gt <- function(data,
                    title            = NULL,
                    subtitle         = NULL,
                    source           = NULL,
                    theme            = "light",
                    highlight_columns= NULL,
                    bold_rows        = NULL,
                    bold_color       = NULL,
                    row_fill         = NULL,
                    gradient_direction = "high_to_low",
                    title_font       = "Inter",
                    data_font        = "Inter") {

  # Set smart defaults for colors
  if (is.null(bold_color)) {
    bold_color <- cpal_colors("pink_medium")[1]
  }

  # Get theme colors
  midnight <- cpal_colors("midnight")

  if (theme == "light") {
    bg_color <- "#FFFFFF"
    text_color <- "#2D3436"
    subtitle_color <- "#6B7280"
    row_border_color <- "#E8E8E8"
    if (is.null(row_fill)) row_fill <- "#FFE4E1"  # Light pink
  } else {
    bg_color <- "#1A1A1A"
    text_color <- "#F8F9FA"
    subtitle_color <- "#9CA3AF"
    row_border_color <- "#404040"
    if (is.null(row_fill)) row_fill <- "#4A2A2A"  # Dark pink
  }

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

  # Apply modern foundation styling
  gt_table <- gt_table %>%
    tab_options(
      table.width = pct(100),
      table.background.color = bg_color,
      table.border.top.style = "none",
      table.border.bottom.style = "none",
      table.border.left.style = "none",
      table.border.right.style = "none",

      column_labels.background.color = midnight,
      column_labels.font.size = px(14),
      column_labels.font.weight = "bold",
      column_labels.border.top.style = "solid",
      column_labels.border.top.width = px(4),
      column_labels.border.top.color = midnight,
      column_labels.border.bottom.style = "none",
      column_labels.padding = px(16),

      table_body.hlines.style = "solid",
      table_body.hlines.width = px(0.5),
      table_body.hlines.color = row_border_color,
      table_body.vlines.style = "none",
      data_row.padding = px(12),

      table.font.names = c(data_font, "system-ui", "-apple-system", "sans-serif"),
      heading.background.color = bg_color,
      source_notes.background.color = bg_color,
      source_notes.font.size = px(10)
    ) %>%

    # Foundation text styling
    tab_style(
      style = list(
        cell_borders(sides = "top", color = text_color, weight = px(2), style = "solid")
      ),
      locations = cells_title()
    ) %>%
    tab_style(
      style = list(
        cell_text(color = "#FFFFFF", weight = "bold", size = px(14)),
        cell_fill(color = midnight)
      ),
      locations = cells_column_labels()
    ) %>%
    tab_style(
      style = list(
        cell_text(color = text_color, size = px(13), weight = "normal")
      ),
      locations = cells_body()
    ) %>%
    tab_style(
      style = list(
        cell_text(color = text_color, size = px(18), weight = "bold")
      ),
      locations = cells_title()
    )

  # SMART FEATURE 1: Column gradient highlighting (lighter teals for readability)
  if (!is.null(highlight_columns)) {

    # Use LIGHTER teal shades so text stays readable
    teal_colors <- c(
      "#F0FDFA",  # Very light teal (almost white)
      cpal_colors("teal_lightest")[1],  # Lightest from palette
      cpal_colors("teal_light")[1],     # Light from palette
      cpal_colors("teal_medium")[1]     # Medium (NOT dark - keeps text readable)
    )

    for (col in highlight_columns) {
      if (col %in% names(data) && is.numeric(data[[col]])) {

        col_values <- data[[col]]
        breaks <- quantile(col_values, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE)

        for (i in 1:nrow(data)) {
          value <- col_values[i]
          if (!is.na(value)) {

            # Determine quartile
            color_index <- if (value <= breaks[2]) 1
            else if (value <= breaks[3]) 2
            else if (value <= breaks[4]) 3
            else 4

            # Reverse if needed
            if (gradient_direction == "low_to_high") {
              color_index <- 5 - color_index
            }

            # Apply color
            gt_table <- gt_table %>%
              tab_style(
                style = list(cell_fill(color = teal_colors[color_index])),
                locations = cells_body(columns = all_of(col), rows = i)
              )
          }
        }
      }
    }
  }

  # SMART FEATURE 2: Row highlighting
  if (!is.null(bold_rows) && bold_rows %in% names(data)) {
    rows_to_style <- which(data[[bold_rows]] == 1)
    if (length(rows_to_style) > 0) {

      # White text for dark theme, pink text for light theme
      highlight_text_color <- if (theme == "dark") "#FFFFFF" else bold_color

      gt_table <- gt_table %>%
        tab_style(
          style = list(
            cell_fill(color = row_fill),
            cell_text(color = highlight_text_color, weight = "bold", size = px(13))
          ),
          locations = cells_body(rows = rows_to_style)
        )
    }
  }

  # Add CSS for modern styling
  gt_table <- gt_table %>%
    opt_css(
      css = paste0("
      .gt_col_headings {
        border-radius: 8px 8px 0 0;
        overflow: hidden;
        border-bottom: none !important;
      }
      .gt_heading .gt_title {
        font-size: 18px !important;
        font-weight: bold !important;
        color: ", text_color, " !important;
      }
      .gt_heading .gt_subtitle {
        font-size: 12px !important;
        font-weight: normal !important;
        color: ", subtitle_color, " !important;
        margin-top: 4px;
      }
      .gt_sourcenote {
        text-align: right;
        font-size: 10px;
        color: ", subtitle_color, ";
        font-style: italic;
        padding-top: 8px;
      }
      ")
    )

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
#' @param theme "light" or "dark"
#' @param highlight_columns Vector of column names to highlight with teal gradient (optional)
#' @param bold_rows Column name containing 1/0 values for row highlighting with background (optional)
#' @param bold_only_rows Column name containing 1/0 values for bold text only (no background) (optional)
#' @param data_bar_columns Vector of column names to add horizontal data bars (optional)
#' @param bold_color Color for bold text (default: CPAL pink)
#' @param row_fill Background color for highlighted rows (default: theme-appropriate)
#' @param gradient_direction "high_to_low" or "low_to_high" for column gradients
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
#' # With gradient columns and data bars
#' cpal_table_reactable(mtcars,
#'                      highlight_columns = c("mpg", "hp"),
#'                      data_bar_columns = c("disp", "qsec"))
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
#'                      data_bar_columns = c("disp"),
#'                      bold_rows = "high_performance",
#'                      theme = "light",
#'                      filterable = TRUE)
#'
cpal_table_reactable <- function(data,
                                 title            = NULL,
                                 subtitle         = NULL,
                                 source           = NULL,
                                 theme            = "light",
                                 highlight_columns= NULL,
                                 bold_rows        = NULL,
                                 bold_only_rows   = NULL,
                                 data_bar_columns = NULL,
                                 bold_color       = NULL,
                                 row_fill         = NULL,
                                 gradient_direction = "high_to_low",

                                 # Interactive features
                                 searchable       = TRUE,
                                 pagination       = TRUE,
                                 page_size        = 10,
                                 sortable         = TRUE,
                                 filterable       = FALSE,
                                 show_page_size_options = TRUE,
                                 striped          = FALSE,
                                 compact          = FALSE) {

  # Load required packages
  if (!requireNamespace("reactable", quietly = TRUE)) {
    stop("Package 'reactable' is required but not installed.")
  }
  if (!requireNamespace("htmltools", quietly = TRUE)) {
    stop("Package 'htmltools' is required but not installed.")
  }

  # Get CPAL colors
  midnight <- cpal_colors("midnight")  # #004855
  pink_medium <- cpal_colors("pink_medium")[3]  # #C3257B
  teal_medium <- cpal_colors("teal_medium")[2]  # #008097
  teal_light <- cpal_colors("teal_light")  # #95CFDA
  teal_lightest <- cpal_colors("teal_lightest")  # #D8EFF4

  # Set smart defaults for colors
  if (is.null(bold_color)) {
    bold_color <- pink_medium
  }

  if (theme == "light") {
    bg_color <- "#FFFFFF"
    text_color <- "#2D3436"
    subtitle_color <- "#6B7280"
    border_color <- "#E8E8E8"
    search_bg <- "#F8F9FA"
    hover_color <- "#F5F5F5"  # Light gray instead of teal
    striped_color <- "#F9F9F9"  # Light gray for striped rows
    if (is.null(row_fill)) row_fill <- "#F8E5F0"  # Very light pink
  } else {
    bg_color <- "#1A1A1A"
    text_color <- "#F8F9FA"
    subtitle_color <- "#9CA3AF"
    border_color <- "#404040"
    search_bg <- "#404448"
    hover_color <- "#2A2A2A"  # Dark gray
    striped_color <- "#2A2A2A"  # Dark gray for striped
    if (is.null(row_fill)) row_fill <- "#4A2A2A"  # Dark pink
  }

  # Define CPAL teal gradient colors (excludes midnight for better text contrast)
  cpal_teal_colors <- c(
    teal_lightest,  # #D8EFF4 - Very light teal
    teal_light,     # #95CFDA - Light teal
    teal_medium,    # #008097 - Medium teal
    "#005F6B"       # Darker teal but not as dark as midnight for better text contrast
  )

  # Create style functions with proper closure to avoid loop variable issues
  create_combined_style <- function(current_col_name) {
    # Pre-calculate gradient info if needed for this column
    gradient_info <- NULL
    if (!is.null(highlight_columns) && current_col_name %in% highlight_columns && is.numeric(data[[current_col_name]])) {
      col_values <- data[[current_col_name]]
      breaks <- quantile(col_values, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE)
      gradient_info <- list(breaks = breaks, colors = cpal_teal_colors, direction = gradient_direction)
    }

    # Return style function with proper closure
    function(value, index) {
      # Row highlighting takes priority over gradients
      if (!is.null(bold_rows) && bold_rows %in% names(data) &&
          length(data[[bold_rows]]) >= index && data[[bold_rows]][index] == 1) {
        return(list(backgroundColor = row_fill, fontWeight = "bold", color = bold_color))
      }

      if (!is.null(bold_only_rows) && bold_only_rows %in% names(data) &&
          length(data[[bold_only_rows]]) >= index && data[[bold_only_rows]][index] == 1) {
        return(list(fontWeight = "bold"))
      }

      # Apply gradient highlighting if configured and no row highlighting
      if (!is.null(gradient_info) && !is.na(value)) {
        color_index <- if (value <= gradient_info$breaks[2]) 1
        else if (value <= gradient_info$breaks[3]) 2
        else if (value <= gradient_info$breaks[4]) 3
        else 4

        if (gradient_info$direction == "low_to_high") {
          color_index <- 5 - color_index
        }

        return(list(backgroundColor = gradient_info$colors[color_index]))
      }

      return(NULL)
    }
  }

  # Prepare column definitions
  columns_list <- list()

  # Process each column
  for (col_name in names(data)) {
    col_def <- reactable::colDef(
      name = col_name,
      sortable = sortable,
      filterable = filterable
    )

    # Hide indicator columns
    should_hide <- FALSE
    if (!is.null(bold_rows) && col_name == bold_rows) should_hide <- TRUE
    if (!is.null(bold_only_rows) && col_name == bold_only_rows) should_hide <- TRUE

    if (should_hide) {
      col_def$show <- FALSE
    } else {
      # Apply the style function with proper closure
      col_def$style <- create_combined_style(col_name)
    }

    # Add CPAL data bars with row styling integration
    if (!is.null(data_bar_columns) && col_name %in% data_bar_columns && is.numeric(data[[col_name]])) {
      col_values <- data[[col_name]]
      max_val <- max(col_values, na.rm = TRUE)
      min_val <- min(col_values, na.rm = TRUE)

      col_def$cell <- function(value, index) {
        if (is.na(value)) return("")

        # Calculate bar width as percentage (0-100%)
        if (max_val == min_val) {
          normalized_value <- 0.5
        } else {
          normalized_value <- (value - min_val) / (max_val - min_val)
        }
        bar_width <- paste0(pmax(0, pmin(100, normalized_value * 100)), "%")

        # Apply row styling to data bar cells
        cell_style <- list(position = "relative", background = "transparent")
        if (!is.null(bold_rows) && bold_rows %in% names(data) &&
            length(data[[bold_rows]]) >= index && data[[bold_rows]][index] == 1) {
          cell_style <- c(cell_style, list(backgroundColor = row_fill, fontWeight = "bold", color = bold_color))
        } else if (!is.null(bold_only_rows) && bold_only_rows %in% names(data) &&
                   length(data[[bold_only_rows]]) >= index && data[[bold_only_rows]][index] == 1) {
          cell_style <- c(cell_style, list(fontWeight = "bold"))
        }

        htmltools::div(
          style = cell_style,
          # Background bar
          htmltools::div(
            style = list(
              position = "absolute",
              top = "0",
              left = "0",
              width = bar_width,
              height = "100%",
              backgroundColor = teal_medium,  # Use CPAL teal medium
              opacity = "0.4",
              borderRadius = "2px"
            )
          ),
          # Text overlay
          htmltools::div(
            style = list(
              position = "relative",
              padding = "4px 8px",
              zIndex = "1"
            ),
            as.character(value)
          )
        )
      }
    }

    columns_list[[col_name]] <- col_def
  }

  # Construct header and footer blocks
  header_block <- if (!is.null(title) || !is.null(subtitle)) {
    title_color <- if (theme == "light") midnight else "#FFFFFF"
    subtitle_color_final <- if (theme == "light") "#6B7280" else "#9CA3AF"

    htmltools::tags$div(
      style = "text-align: center; margin-bottom: 16px; font-family: Inter, system-ui, sans-serif;",
      if (!is.null(title)) {
        htmltools::tags$h3(
          title,
          style = paste0("margin: 0; font-weight: bold; font-size: 20px; color: ", title_color, "; border-top: 3px solid ", midnight, "; padding-top: 8px;")
        )
      },
      if (!is.null(subtitle)) {
        htmltools::tags$p(
          subtitle,
          style = paste0("margin: 4px 0 0 0; font-size: 14px; color: ", subtitle_color_final, ";")
        )
      }
    )
  } else {
    NULL
  }

  footer_block <- if (!is.null(source)) {
    subtitle_color_final <- if (theme == "light") "#6B7280" else "#9CA3AF"
    htmltools::tags$div(
      style = paste0("text-align: right; margin-top: 8px; font-size: 10px; color: ", subtitle_color_final, "; font-style: italic; font-family: Inter, system-ui, sans-serif;"),
      paste("Source:", source)
    )
  } else {
    NULL
  }

  # Build the table
  reactable_table <- reactable::reactable(
    data,
    columns = columns_list,
    searchable = searchable,
    pagination = pagination,
    defaultPageSize = page_size,
    showPageSizeOptions = show_page_size_options,
    pageSizeOptions = c(5, 10, 15, 25, 50),
    striped = striped,
    compact = compact,
    highlight = TRUE,

    # CPAL Theme with correct colors
    theme = reactable::reactableTheme(
      color = text_color,
      backgroundColor = bg_color,
      borderColor = border_color,
      stripedColor = if(striped) striped_color else "transparent",
      highlightColor = hover_color,

      # Header styling with CPAL midnight - centered text, only end corners rounded
      headerStyle = list(
        backgroundColor = midnight,  # CPAL midnight #004855
        color = "#FFFFFF",
        fontWeight = "bold",
        fontSize = "14px",
        fontFamily = "Inter, system-ui, sans-serif",
        textAlign = "center",  # Center header text
        borderTop = paste0("4px solid ", midnight),
        borderRadius = "0px"  # Remove individual cell rounding
      ),

      # Cell styling
      cellStyle = list(
        fontSize = "13px",
        fontFamily = "Inter, system-ui, sans-serif",
        padding = "12px 16px"
      ),

      # Search box styling
      searchInputStyle = list(
        backgroundColor = search_bg,
        border = paste0("1px solid ", border_color),
        borderRadius = "6px",
        fontSize = "13px",
        fontFamily = "Inter, system-ui, sans-serif",
        color = text_color,
        padding = "8px 12px"
      ),

      # Pagination styling
      paginationStyle = list(
        color = text_color,
        fontSize = "13px",
        fontFamily = "Inter, system-ui, sans-serif"
      ),

      # Page size selector styling
      selectStyle = list(
        backgroundColor = search_bg,
        border = paste0("1px solid ", border_color),
        borderRadius = "6px",
        color = text_color,
        fontSize = "13px",
        fontFamily = "Inter, system-ui, sans-serif"
      )
    )
  )

  # Enhanced CSS for headers - force CPAL styling
  enhanced_css <- htmltools::tags$style(paste0("
    /* Force header colors and styling */
    .ReactTable .rt-thead .rt-tr .rt-th {
      background-color: ", midnight, " !important;
      color: #FFFFFF !important;
      border-top: 4px solid ", midnight, " !important;
      text-align: center !important;
      font-family: 'Inter', system-ui, sans-serif !important;
      font-weight: bold !important;
      font-size: 14px !important;
      border-radius: 0px !important;
    }
    /* Round only the end header corners */
    .ReactTable .rt-thead .rt-tr .rt-th:first-child {
      border-top-left-radius: 8px !important;
    }
    .ReactTable .rt-thead .rt-tr .rt-th:last-child {
      border-top-right-radius: 8px !important;
    }
  "))

  reactable_table <- htmlwidgets::prependContent(reactable_table, enhanced_css)

  # Inject header and footer
  if (!is.null(header_block)) {
    reactable_table <- htmlwidgets::prependContent(reactable_table, header_block)
  }
  if (!is.null(footer_block)) {
    reactable_table <- htmlwidgets::appendContent(reactable_table, footer_block)
  }

  return(reactable_table)
}
