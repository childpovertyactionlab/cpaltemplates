# Header UI
header_ui <- div(
  class = "d-flex align-items-center justify-content-between w-100",
  # Left side: logo + title
  div(
    class = "d-flex align-items-center",
    tags$img(
      src = "images/CPAL_Logo_OneColor.png",
      height = "30",
      class = "me-2"
    ),
    tags$div("Shiny Dashboard Template", class = "header-title")
  ),

  # Right side: dark mode toggle
  input_dark_mode(id = "dark_mode_toggle", class = "mode-switcher", mode = NULL)
)
