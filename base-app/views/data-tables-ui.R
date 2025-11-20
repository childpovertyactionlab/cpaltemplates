# Data Tables UI
data_tables_ui <- div(
  h1("Data Tables"),
  p("Compare different table packages with CPAL theming.", class = "lead"),
  layout_columns(
    col_widths = c(12, 12),
    card(card_header("GT Table (CPAL Themed)"), gt_output("gt_table")),
    card(
      card_header("Reactable (CPAL Themed)"),
      reactableOutput("reactable_table")
    ),
    card(
      card_header("DT Table (Full Features)"),
      DT::dataTableOutput("dt_table"),
      full_screen = TRUE
    ),
    card(
      card_header("Summary Statistics"),
      verbatimTextOutput("summary_stats")
    )
  )
)
