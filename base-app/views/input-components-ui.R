# Load and prepare data
mtcars_enhanced <- mtcars %>%
  tibble::rownames_to_column("car_name") %>%
  mutate(
    car_brand = sapply(strsplit(car_name, " "), `[`, 1),
    efficiency_category = case_when(
      mpg >= 25 ~ "High Efficiency",
      mpg >= 20 ~ "Medium Efficiency",
      TRUE ~ "Low Efficiency"
    ),
    power_category = case_when(hp >= 200 ~ "High Power", hp >= 110 ~ "Medium Power", TRUE ~ "Low Power")
  )

# Input Components UI
input_components_ui <- div(
  h1("Input Components Showcase"),
  p(
    "Explore the full range of input widgets available in Shiny and shinyWidgets packages.",
    class = "lead"
  ),
  layout_columns(
    col_widths = c(6, 6),

    # Input Widgets Showcase in Tabbed Interface
    card(
      card_header("Input Widgets with Package Information"),
      style = "height: 80vh;",

      # Tabbed interface for different input categories
      tabsetPanel(
        id = "input_tabs",
        type = "tabs",

        # Basic Shiny Inputs Tab
        tabPanel(
          "Basic Shiny",
          div(
            class = "overflow-auto p-3",

            # Basic Shiny Sliders
            div(
              class = "mb-5",
              h5("Slider Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Function: "),
                tags$code("sliderInput()"),
                class = "small text-muted mb-3"
              ),
              sliderInput(
                "mpg_range",
                "MPG Range (Range Slider)",
                min = min(mtcars$mpg),
                max = max(mtcars$mpg),
                value = c(15, 25),
                step = 0.5
              ),
              sliderInput(
                "hp_single",
                "Horsepower Threshold (Single Value)",
                min = min(mtcars$hp),
                max = max(mtcars$hp),
                value = 150
              ),
              sliderInput(
                "transparency",
                "Transparency (Standard Slider)",
                value = 0.8,
                min = 0,
                max = 1,
                step = 0.1
              )
            ),

            # Basic Shiny Select Inputs
            div(
              class = "mb-5",
              h5("Select Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Functions: "),
                tags$code("selectInput(), selectizeInput()"),
                class = "small text-muted mb-3"
              ),
              selectInput(
                "cyl_select",
                "Cylinders (Basic Multi-Select)",
                choices = sort(unique(mtcars$cyl)),
                selected = unique(mtcars$cyl),
                multiple = TRUE
              ),
              selectizeInput(
                "gear_select",
                "Gears (Selectize with Placeholder)",
                choices = sort(unique(mtcars$gear)),
                selected = unique(mtcars$gear),
                multiple = TRUE,
                options = list(placeholder = "Select gears...")
              )
            ),

            # Basic Shiny Checkboxes
            div(
              class = "mb-5",
              h5("Checkbox Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Functions: "),
                tags$code("checkboxInput(), checkboxGroupInput()"),
                class = "small text-muted mb-3"
              ),
              checkboxInput("show_trend", "Show trend line (Single Checkbox)", value = TRUE),
              checkboxGroupInput(
                "transmission",
                "Transmission Type (Checkbox Group)",
                choices = list("Automatic (0)" = 0, "Manual (1)" = 1),
                selected = c(0, 1)
              )
            ),

            # Basic Shiny Radio Buttons
            div(
              class = "mb-5",
              h5("Radio Button Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Function: "),
                tags$code("radioButtons()"),
                class = "small text-muted mb-3"
              ),
              radioButtons(
                "chart_type",
                "Chart Type (Basic Radio):",
                choices = list(
                  "Scatter" = "scatter",
                  "Box Plot" = "box",
                  "Histogram" = "hist"
                ),
                selected = "scatter"
              )
            ),

            # Basic Shiny Text Inputs
            div(
              class = "mb-5",
              h5("Text Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Functions: "),
                tags$code("textInput(), textAreaInput(), numericInput()"),
                class = "small text-muted mb-3"
              ),
              textInput("chart_title", "Chart Title (Text Input):", value = "Motor Trend Car Analysis"),
              textAreaInput(
                "chart_notes",
                "Chart Notes (Text Area)",
                value = "Analysis of 1974 Motor Trend data",
                rows = 3
              ),
              numericInput(
                "point_size",
                "Point Size (Numeric Input)",
                value = 3,
                min = 1,
                max = 10
              )
            ),

            # Basic Shiny Date and File Inputs
            div(
              class = "mb-5",
              h5("Date & File Inputs", class = "text-primary mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Functions: "),
                tags$code("dateRangeInput(), fileInput()"),
                class = "small text-muted mb-3"
              ),
              dateRangeInput(
                "date_range",
                "Analysis Period (Date Range):",
                start = Sys.Date() - 30,
                end = Sys.Date()
              ),
              fileInput(
                "upload_data",
                "Upload Custom Data (File Input)",
                accept = c(".csv", ".xlsx")
              )
            )
          )
        ),

        # shinyWidgets Tab
        tabPanel(
          "shinyWidgets",
          div(
            class = "overflow-auto p-3",

            # shinyWidgets Pretty Checkboxes
            div(
              class = "mb-5",
              h5("Enhanced Checkboxes", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("prettyCheckboxGroup()"),
                class = "small text-muted mb-3"
              ),
              prettyCheckboxGroup(
                "carb_pretty",
                "Carburetors (Pretty Checkboxes):",
                choices = sort(unique(mtcars$carb)),
                selected = sort(unique(mtcars$carb)),
                inline = TRUE,
                status = "primary",
                shape = "curve"
              )
            ),

            # shinyWidgets Pretty Radio Buttons
            div(
              class = "mb-5",
              h5("Enhanced Radio Buttons", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("prettyRadioButtons()"),
                class = "small text-muted mb-3"
              ),
              prettyRadioButtons(
                "color_scheme",
                "Color Scheme (Pretty Radio):",
                choices = list(
                  "CPAL Primary" = "primary",
                  "CPAL Secondary" = "secondary",
                  "Viridis" = "viridis"
                ),
                selected = "primary",
                inline = TRUE,
                status = "info",
                fill = TRUE
              )
            ),

            # shinyWidgets Picker Input
            div(
              class = "mb-5",
              h5("Picker Input", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("pickerInput()"),
                class = "small text-muted mb-3"
              ),
              pickerInput(
                "brand_picker",
                "Car Brands (Picker with Actions):",
                choices = unique(mtcars_enhanced$car_brand),
                selected = unique(mtcars_enhanced$car_brand),
                multiple = TRUE,
                options = list(`actions-box` = TRUE)
              )
            ),

            # shinyWidgets Color Input
            div(
              class = "mb-5",
              h5("Color Picker", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("colorPickr()"),
                class = "small text-muted mb-3"
              ),
              colorPickr(
                "custom_color",
                "Custom Color (Color Picker):",
                selected = "#1f77b4"
              )
            ),

            # shinyWidgets Advanced Inputs
            div(
              class = "mb-5",
              h5("Advanced Widget Inputs", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Functions: "),
                tags$code("materialSwitch(), searchInput(), airDatepickerInput()"),
                class = "small text-muted mb-3"
              ),
              materialSwitch(
                "show_labels",
                "Show Labels (Material Switch)",
                value = TRUE,
                status = "primary"
              ),
              searchInput(
                "search_cars",
                "Search Cars (Search Input)",
                placeholder = "Enter car name...",
                btnSearch = icon("magnifying-glass"),
                btnReset = icon("xmark"),
              ),
              airDatepickerInput(
                "air_date",
                "Select Date (Air Date Picker)",
                value = Sys.Date(),
                dateFormat = "mm/dd/yyyy"
              )
            ),

            # shinyWidgets Numeric Range
            div(
              class = "mb-5",
              h5("Numeric Range Input", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("numericRangeInput()"),
                class = "small text-muted mb-3"
              ),
              numericRangeInput("weight_range", "Weight Range:", value = c(2, 4))
            ),

            # Progress Bars (shinyWidgets)
            div(
              class = "mb-5",
              h5("Progress Indicators", class = "mb-3"),
              p(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("progressBar()"),
                class = "small text-muted mb-3"
              ),
              progressBar(
                "demo_progress1",
                value = 65,
                status = "info",
                display_pct = TRUE,
                striped = TRUE,
                title = "Demo Progress 1"
              ),
              br(),
              progressBar(
                "demo_progress2",
                value = 85,
                status = "success",
                display_pct = TRUE,
                title = "Demo Progress 2"
              )
            )
          )
        ),

        # Action Buttons Tab
        tabPanel(
          "Action Buttons",
          div(
            class = "overflow-auto p-3",

            # Standard Action Buttons
            div(
              class = "mb-5",
              h5("Standard Shiny Buttons", class = "mb-3"),
              p(
                tags$strong("Package: "),
                tags$code("shiny"),
                " | ",
                tags$strong("Functions: "),
                tags$code("actionButton(), downloadButton()"),
                class = "small text-muted mb-3"
              ),
              actionButton("refresh_data", "Refresh Analysis", class = "btn-primary me-2 mb-2"),
              actionButton("refresh_data", "Refresh Analysis", class = "btn-outline-primary me-2 mb-2"),
              downloadButton("download_report", "Download Report", class = "btn-primary me-2 mb-2"),
              actionButton("show_notification", "Show Notification", class = "btn-info me-2 mb-2"),
              actionButton("update_progress", "Update Progress Bars", class = "btn-secondary me-2 mb-2"),
              actionLink(
                "show_static_charts",
                class = "sidebar-link",
                label = tagList(icon("line-chart", class = "sidebar-icon"), "Static Charts")
              ),
            ),


            # Dropdown Button
            div(
              class = "mb-5",
              h5("Dropdown Button", class = "mb-3"),
              div(
                tags$strong("Package: "),
                tags$code("shinyWidgets"),
                " | ",
                tags$strong("Function: "),
                tags$code("dropdown()"),
                class = "small text-muted mb-3"
              ),
              dropdown(
                h5("Additional Options"),
                br(),
                checkboxInput("dropdown_opt1", "Option 1", TRUE),
                checkboxInput("dropdown_opt2", "Option 2", FALSE),
                sliderInput("dropdown_slider", "Value", 1, 10, 5),
                style = "simple",
                status = "primary",
                icon = icon("gear"),
                width = "300px"
              )
            ),

            # Dropdown Button
            div(
              class = "mb-3 p-3 bg-primary-subtle rounded",
              h5("Primary Section", class = "text-primary mb-3"),
              p(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
              )
            ),
            div(
              class = "mb-3 p-3 bg-success-subtle rounded",
              h5("Success Section", class = "text-success mb-3"),
              p(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
              )
            ),
            div(
              class = "mb-3 p-3 bg-info-subtle rounded",
              h5("Information Section", class = "text-info mb-3"),
              p(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
              )
            ),
            div(
              class = "mb-3 p-3 bg-warning-subtle rounded",
              h5("Warning Section", class = "text-warning mb-3"),
              p(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
              )
            ),
            div(
              class = "mb-3 p-3 bg-danger-subtle rounded",
              h5("Danger Section", class = "text-danger mb-3"),
              p(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
              )
            )
          )
        )
      )
    ),

    # Main Visualization Area
    card(
      card_header("Dynamic Visualization"),
      plotOutput("main_plot", height = "500px"),
      br(),

      # Value boxes
      layout_columns(
        col_widths = c(3, 3, 3, 3),
        value_box(
          title = "Average MPG",
          value = textOutput("avg_mpg"),
          showcase = icon("gas-pump"),
          theme = value_box_theme(bg = cpal_colors("gold"))
        ),
        value_box(
          title = "Total Cars",
          value = textOutput("total_cars"),
          showcase = icon("car"),
          theme = value_box_theme(bg = cpal_colors("teal"))
        ),
        value_box(
          title = "Max Horsepower",
          value = textOutput("max_hp"),
          showcase = icon("bolt"),
          theme = value_box_theme(bg = cpal_colors("orange"))
        ),
        value_box(
          title = "Avg Weight",
          value = textOutput("avg_weight"),
          showcase = icon("weight-hanging"),
          theme = value_box_theme(bg = cpal_colors("pink"))
        )
      )
    )
  )
)
