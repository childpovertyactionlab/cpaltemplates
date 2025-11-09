# Static Charts UI
static_charts_ui <- div(
  h1("Static Charts"),
  p("Static visualizations using ggplot2 with CPAL theming.", class = "lead"),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Scatter Plot"),
      plotOutput("ggplot_scatter", height = "400px")
    ),
    card(
      card_header("Line Chart"),
      plotOutput("ggplot_line", height = "400px")
    ),
    card(
      card_header("Bar Chart"),
      plotOutput("ggplot_bar", height = "400px")
    ),
    card(
      card_header("Correlation Matrix"),
      plotOutput("ggplot_heatmap", height = "400px")
    )
  )
)