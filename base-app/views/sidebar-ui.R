# Sidebar UI
sidebar_ui <- sidebar(
  width = 300,
  h6("Dashboard Elements"),
  actionLink(
    "show_inputs",
    class = "sidebar-link",
    label = tagList(icon("wrench", class = "sidebar-icon"), "Input Components")
  ),
  actionLink(
    "show_typography",
    class = "sidebar-link",
    label = tagList(icon("font", class = "sidebar-icon"), "Typography")
  ),
  actionLink(
    "show_static_charts",
    class = "sidebar-link",
    label = tagList(icon("line-chart", class = "sidebar-icon"), "Static Charts")
  ),
  actionLink(
    "show_charts",
    class = "sidebar-link",
    label = tagList(
      icon("area-chart", class = "sidebar-icon"),
      "Interactive Charts"
    )
  ),
  actionLink(
    "show_maps",
    class = "sidebar-link",
    label = tagList(icon("map", class = "sidebar-icon"), "Maps")
  ),
  actionLink(
    "show_tables",
    class = "sidebar-link",
    label = tagList(icon("table", class = "sidebar-icon"), "Data Tables")
  ),
  actionLink(
    "show_advanced",
    class = "sidebar-link",
    label = tagList(
      icon("superpowers", class = "sidebar-icon"),
      "Advanced Features"
    )
  )
)
