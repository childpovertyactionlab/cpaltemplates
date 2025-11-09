# Maps UI
maps_ui <- div(
  h1("Maps"),
  p("Interactive maps using the mapgl package.", class = "lead"),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("United States - State Level"),
      mapboxglOutput("us_states_map", height = "500px")
    ),
    card(
      card_header("Texas Counties"),
      mapboxglOutput("texas_counties_map", height = "500px")
    )
  )
)