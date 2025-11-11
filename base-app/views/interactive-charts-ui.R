# Interactive Charts UI
interactive_charts_ui <- div(
  h1("Interactive Charts"),
  p("Explore interactive visualizations using highcharter.", class = "lead"),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Scatter Plot"),
      highchartOutput("highchart_scatter", height = "400px")
    ),
    card(
      card_header("Line Chart"),
      highchartOutput("highchart_line", height = "400px")
    ),
    card(
      card_header("Bar Chart"),
      highchartOutput("highchart_bar", height = "400px")
    ),
    card(
      card_header("Correlation Matrix"),
      highchartOutput("highchart_heatmap", height = "400px")
    )
  )
)
