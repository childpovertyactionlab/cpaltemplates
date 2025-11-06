# Comprehensive CPAL Shiny Dashboard Template
# Author: Generated for CPAL template showcase
# Dataset: mtcars (built-in R dataset)

# Load required libraries
library(shiny)
library(bslib)
library(cpaltemplates)
library(ggplot2)
library(dplyr)
library(scales)
library(shinyWidgets)
library(DT)
library(reactable)
library(gt)
library(highcharter)
library(mapgl)
library(sf)
library(tigris)

# Mapbox access token setup (uncomment and set your token if needed)
Sys.setenv(MAPBOX_PUBLIC_TOKEN = 'pk.eyJ1IjoiY3BhbGFuYWx5dGljcyIsImEiOiJjbHg5ODAwMGUxaTRtMmpwdGNscms3ZnJmIn0.D6yaemYNkijMo1naveeLbw')

source("template sources/dashboards.R")

# Load and prepare data
data(mtcars)
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

# Load geographic data
message("Loading geographic data...")
states_sf <- states(cb = TRUE, resolution = "20m") %>%
  sf::st_transform(4326) %>%
  mutate(random_value = runif(n(), 0, 100),
         category = sample(c("Low", "Medium", "High"), n(), replace = TRUE))

texas_counties_sf <- counties(state = "TX",
                              cb = TRUE,
                              resolution = "20m") %>%
  sf::st_transform(4326) %>%
  mutate(
    population_category = sample(c("Small", "Medium", "Large"), n(), replace = TRUE),
    random_metric = runif(n(), 0, 100)
  )

# Define UI
ui <- page_sidebar(
  title = div(
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
    input_dark_mode(id = "mode", class = "mode-switcher")
  ),

  theme = cpal_shiny(variant = "default"),

  # Collapsible Sidebar Navigation
  sidebar = sidebar(
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
    ),

    # Quick filters that apply globally
    #    h5("Global Filters", class = "text-secondary"),

    #    sliderInput("global_mpg_range", "MPG Range:",
    #                min = min(mtcars$mpg), max = max(mtcars$mpg),
    #                value = c(15, 25), step = 0.5),

    #    selectInput("global_cyl_select", "Cylinders:",
    #                choices = sort(unique(mtcars$cyl)),
    #                selected = unique(mtcars$cyl),
    #                multiple = TRUE)
  ),

  # Main Content Area
  div(
    id = "main_content",

    # Input Components Section
    conditionalPanel(
      condition = "output.current_section == 'inputs'",
      h1("Input Components Showcase"),
      p(
        "Explore the full range of input widgets available in Shiny and shinyWidgets packages.",
        class = "lead"
      ),

      layout_columns(
        col_widths = c(5, 7),

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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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
                  class = "mb-3 p-3",
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

                  br(),
                  br(),

                  actionButton("show_notification", "Show Notification", class = "btn-info me-2 mb-2"),

                  actionButton("update_progress", "Update Progress Bars", class = "btn-secondary me-2 mb-2")
                ),


                # Dropdown Button
                div(
                  class = "mb-3 p-3",
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
  ),

  # Interactive Charts Section
  conditionalPanel(
    condition = "output.current_section == 'charts'",
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
  ),

  # Static Charts Section
  conditionalPanel(
    condition = "output.current_section == 'static_charts'",
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
  ),

  # Data Tables Section
  conditionalPanel(
    condition = "output.current_section == 'tables'",
    h1("Data Tables"),
    p("Compare different table packages with CPAL theming.", class = "lead"),

    layout_columns(
      col_widths = c(6, 6),

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
  ),

  # Typography Section (unchanged)
  conditionalPanel(
    condition = "output.current_section == 'typography'",
    h1("Typography Showcase"),
    p(
      "Demonstration of text styling options available in the CPAL theme.",
      class = "lead"
    ),

    layout_columns(
      col_widths = 12,

      card(
        card_header("CPAL Typography Showcase"),

        # Headers
        h1("H1 Header - Main Dashboard Title", class = "text-primary"),
        h2("H2 Header - Section Title", class = "text-secondary"),
        h3("H3 Header - Subsection Title", class = "text-info"),
        h4("H4 Header - Component Title"),
        h5("H5 Header - Small Section"),
        h6("H6 Header - Minor Detail"),

        hr(),

        # Body text variations
        p(
          "This is regular body text demonstrating the standard paragraph styling used throughout the CPAL dashboard template.",
          class = "fs-5"
        ),

        p(
          "This is a highlighted paragraph with important information that should stand out to users.",
          class = "bg-light p-3 border-start border-5 border-primary"
        ),

        p(
          "This is muted text typically used for additional context or secondary information.",
          class = "text-muted"
        ),

        p(
          "This is small text used for captions, footnotes, or fine print.",
          class = "small"
        ),

        # Emphasis and styling
        p(
          HTML(
            "<strong>Bold text</strong> and <em>italic text</em> for emphasis within paragraphs."
          )
        ),

        p(
          HTML(
            '<span class="text-success">Success text</span>,
                 <span class="text-danger">danger text</span>,
                 <span class="text-warning">warning text</span>, and
                 <span class="text-info">info text</span>.'
          )
        ),

        # Code styling
        p("Inline code example:", code("mtcars %>% filter(mpg > 20)")),

        # Blockquote
        tags$blockquote(
          p(
            "This is a blockquote used for highlighting important quotes or key insights from the analysis."
          ),
          tags$footer("CPAL Data Analysis Team")
        ),

        # Lists
        h4("List Examples"),
        p("Unordered list:"),
        tags$ul(
          tags$li("First insight from data analysis"),
          tags$li("Second key finding"),
          tags$li("Third important observation")
        ),

        p("Ordered list:"),
        tags$ol(
          tags$li("Data collection and cleaning"),
          tags$li("Exploratory data analysis"),
          tags$li("Statistical modeling"),
          tags$li("Results interpretation")
        )
      )
    )
  ),

  # Advanced Features Section
  conditionalPanel(
    condition = "output.current_section == 'advanced'",
    h1("Advanced Features"),
    p("Progress indicators, alerts, and notifications.", class = "lead"),

    layout_columns(
      col_widths = c(6, 6),

      card(
        card_header("Progress Indicators"),

        h5("Standard Progress Bars"),
        progressBar(
          "progress1",
          value = 65,
          status = "info",
          display_pct = TRUE,
          striped = TRUE
        ),

        progressBar(
          "progress2",
          value = 85,
          status = "success",
          display_pct = TRUE
        ),

        br(),

        h5("Circular Progress (shinyWidgets)"),
        circleButton(
          "circle1",
          icon = icon("check"),
          status = "primary",
          size = "lg"
        ),

        br(),
        br(),

        h5("Loading Indicators"),
        actionButton("show_loading", "Show Loading Spinner", class = "btn-primary"),

        br(),
        br(),

        h5("Update Progress"),
        actionButton("update_progress_advanced", "Update All Progress", class = "btn-info")
      ),

      card(
        card_header("Alerts & Notifications"),

        h5("Bootstrap Alerts"),
        div(
          class = "alert alert-info alert-dismissible",
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "alert"
          ),
          tags$strong("Info!"),
          " This is an informational alert."
        ),

        div(
          class = "alert alert-success alert-dismissible",
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "alert"
          ),
          tags$strong("Success!"),
          " Operation completed successfully."
        ),

        div(
          class = "alert alert-warning alert-dismissible",
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "alert"
          ),
          tags$strong("Warning!"),
          " Please review before proceeding."
        ),

        div(
          class = "alert alert-danger alert-dismissible",
          tags$button(
            type = "button",
            class = "btn-close",
            `data-bs-dismiss` = "alert"
          ),
          tags$strong("Error!"),
          " An error has occurred."
        ),

        br(),

        h5("Notification Actions"),
        actionButton("notif_default", "Default Notification", class = "btn-secondary me-2"),
        actionButton("notif_error", "Error Notification", class = "btn-danger me-2"),
        actionButton("notif_warning", "Warning Notification", class = "btn-warning me-2"),
        actionButton("notif_message", "Message Notification", class = "btn-info"),

        br(),
        br(),

        h5("Sweet Alerts (shinyWidgets)"),
        actionButton("sweet_success", "Success Alert", class = "btn-success me-2"),
        actionButton("sweet_confirm", "Confirmation Dialog", class = "btn-primary")
      ),

      card(
        card_header("Tooltips & Popovers"),

        h5("Tooltips"),
        p("Hover over these elements to see tooltips:"),

        div(
          class = "d-flex gap-3",
          actionButton("tooltip1", "Top Tooltip", class = "btn-outline-primary") %>%
            bslib::tooltip("This tooltip appears on top"),

          actionButton("tooltip2", "Right Tooltip", class = "btn-outline-secondary") %>%
            bslib::tooltip("This tooltip appears on the right", placement = "right"),

          actionButton("tooltip3", "Bottom Tooltip", class = "btn-outline-info") %>%
            bslib::tooltip("This tooltip appears on the bottom", placement = "bottom")
        ),

        br(),

        h5("Accordions"),
        accordion(
          accordion_panel(
            title = "Data Processing Options",
            "Configure advanced data processing parameters here.",
            checkboxInput("adv_option1", "Enable advanced processing"),
            sliderInput("adv_threshold", "Threshold", 0, 100, 50)
          ),
          accordion_panel(
            title = "Export Settings",
            "Choose export formats and customize output parameters.",
            radioButtons("export_format", "Format:", choices = c("CSV", "Excel", "JSON"))
          ),
          accordion_panel(
            title = "Performance Options",
            "Optimize dashboard performance settings.",
            checkboxInput("enable_cache", "Enable caching"),
            numericInput("cache_time", "Cache duration (minutes):", 60)
          )
        )
      ),

      card(
        card_header("Modal Dialogs"),

        actionButton("show_modal", "Show Modal Dialog", class = "btn-primary"),

        br(),
        br(),

        actionButton("show_modal_form", "Show Form Modal", class = "btn-secondary"),

        br(),
        br(),

        h5("Cards with Actions"),
        div(
          class = "card",
          div(
            class = "card-header d-flex justify-content-between",
            "Collapsible Card",
            actionButton("collapse_card", icon("chevron-down"), class = "btn-sm btn-outline-secondary")
          ),
          div(
            id = "card_body",
            class = "card-body",
            "This card can be collapsed/expanded using the button in the header."
          )
        )
      )
    )
  ),

  # Maps Section
  conditionalPanel(
    condition = "output.current_section == 'maps'",
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
)
)

# Define Server
server <- function(input, output, session) {
  # Set session theme
  session$setCurrentTheme(cpal_shiny(variant = "default"))

  # Mode change
  observeEvent(input$mode, {
    variant <- if (input$mode == "dark")
      "dark"
    else
      "default"
    theme <- cpal_shiny(variant = variant)
    session$setCurrentTheme(theme)
  }, ignoreInit = TRUE)

  # Navigation state
  values <- reactiveValues(current_section = "inputs")

  # Create a reactive value for current section that can be used in conditionalPanel
  output$current_section <- reactive({
    values$current_section
  })
  outputOptions(output, "current_section", suspendWhenHidden = FALSE)

  # Navigation event handlers
  observeEvent(input$show_inputs, {
    values$current_section <- "inputs"
  })

  observeEvent(input$show_charts, {
    values$current_section <- "charts"
  })

  observeEvent(input$show_static_charts, {
    values$current_section <- "static_charts"
  })

  observeEvent(input$show_tables, {
    values$current_section <- "tables"
  })

  observeEvent(input$show_typography, {
    values$current_section <- "typography"
  })

  observeEvent(input$show_advanced, {
    values$current_section <- "advanced"
  })

  observeEvent(input$show_maps, {
    values$current_section <- "maps"
  })

  # Reactive data filtering
  filtered_data <- reactive({
    data <- mtcars_enhanced

    # Apply global filters from sidebar
    if (!is.null(input$global_mpg_range)) {
      data <- data %>% filter(mpg >= input$global_mpg_range[1] &
                                mpg <= input$global_mpg_range[2])
    }

    if (!is.null(input$global_cyl_select)) {
      data <- data %>% filter(cyl %in% input$global_cyl_select)
    }

    # Apply local filters from input components section
    if (!is.null(input$mpg_range)) {
      data <- data %>% filter(mpg >= input$mpg_range[1] &
                                mpg <= input$mpg_range[2])
    }

    if (!is.null(input$cyl_select)) {
      data <- data %>% filter(cyl %in% input$cyl_select)
    }

    if (!is.null(input$gear_select)) {
      data <- data %>% filter(gear %in% input$gear_select)
    }

    if (!is.null(input$transmission)) {
      data <- data %>% filter(am %in% input$transmission)
    }

    if (!is.null(input$carb_pretty)) {
      data <- data %>% filter(carb %in% as.numeric(input$carb_pretty))
    }

    if (!is.null(input$brand_picker)) {
      data <- data %>% filter(car_brand %in% input$brand_picker)
    }

    return(data)
  })

  # Main plot (Input Components section)
  output$main_plot <- renderPlot({
    data <- filtered_data()

    if (nrow(data) == 0) {
      return(ggplot() +
               theme_cpal_print() +
               labs(title = "No data matches current filters"))
    }

    p <- switch(
      input$chart_type,
      "scatter" = ggplot(data, aes(x = wt, y = mpg)) +
        geom_point(
          aes(color = factor(cyl)),
          size = input$point_size,
          alpha = input$transparency
        ) +
        labs(x = "Weight (1000 lbs)", y = "Miles Per Gallon", color = "Cylinders"),

      "box" = ggplot(data, aes(x = factor(cyl), y = mpg)) +
        geom_boxplot(aes(fill = factor(cyl)), alpha = 0.7) +
        labs(x = "Cylinders", y = "Miles Per Gallon", fill = "Cylinders"),

      "hist" = ggplot(data, aes(x = mpg)) +
        geom_histogram(
          bins = 15,
          fill = cpal_colors("gold"),
          alpha = 0.7,
          color = "white"
        ) +
        labs(x = "Miles Per Gallon", y = "Count")
    )

    # Add trend line if requested for scatter plot
    if (input$chart_type == "scatter" && input$show_trend) {
      p <- p + geom_smooth(method = "lm",
                           se = TRUE,
                           color = cpal_colors("orange"))
    }

    # Apply color scheme
    if (input$color_scheme == "primary") {
      p <- p + scale_color_cpal_d() + scale_fill_cpal_d()
    } else if (input$color_scheme == "secondary") {
      p <- p + scale_color_cpal_d(palette = "secondary") + scale_fill_cpal_d(palette = "secondary")
    }

    p + theme_cpal_print() +
      labs(title = input$chart_title,
           caption = input$chart_notes) +
      theme(plot.title = element_text(size = 16, color = cpal_colors("gold")))
  })

  # Value boxes
  output$avg_mpg <- renderText({
    round(mean(filtered_data()$mpg, na.rm = TRUE), 1)
  })

  output$total_cars <- renderText({
    nrow(filtered_data())
  })

  output$max_hp <- renderText({
    max(filtered_data()$hp, na.rm = TRUE)
  })

  output$avg_weight <- renderText({
    paste0(round(mean(filtered_data()$wt, na.rm = TRUE), 1), "k lbs")
  })

  # Interactive Charts (Highcharter)
  output$highchart_scatter <- renderHighchart({
    data <- filtered_data()

    if (nrow(data) == 0) {
      return(highchart() %>%
               hc_title(text = "No data matches current filters"))
    }

    # Create separate series for each cylinder group
    hc <- highchart() %>%
      hc_title(text = "Weight vs MPG by Cylinders") %>%
      hc_xAxis(title = list(text = "Weight (1000 lbs)")) %>%
      hc_yAxis(title = list(text = "Miles Per Gallon")) %>%
      hc_tooltip(pointFormat = "Weight: {point.x}<br>MPG: {point.y}<br>") %>%
      hc_plotOptions(scatter = list(marker = list(radius = 5)))

    # Add each cylinder group as a separate series
    for (cyl_val in sort(unique(data$cyl))) {
      series_data <- data %>%
        filter(cyl == cyl_val) %>%
        select(x = wt, y = mpg)

      hc <- hc %>%
        hc_add_series(
          data = list_parse2(series_data),
          type = "scatter",
          name = paste(cyl_val, "cylinders"),
          color = unname(cpal_colors(c(
            "gold", "teal", "orange"
          ))[which(sort(unique(data$cyl)) == cyl_val)])
        )
    }

    hc
  })

  output$highchart_line <- renderHighchart({
    data <- filtered_data() %>%
      group_by(cyl, hp) %>%
      summarise(avg_mpg = mean(mpg), .groups = "drop") %>%
      arrange(cyl, hp)

    if (nrow(data) == 0) {
      return(highchart() %>%
               hc_title(text = "No data matches current filters"))
    }

    # Create the base chart
    hc <- highchart() %>%
      hc_title(text = "Average MPG by Horsepower and Cylinders") %>%
      hc_xAxis(title = list(text = "Horsepower")) %>%
      hc_yAxis(title = list(text = "Average MPG")) %>%
      hc_tooltip(pointFormat = "HP: {point.x}<br>Avg MPG: {point.y:.1f}<br>")

    # Add each cylinder group as a separate series
    colors <- unname(c(
      cpal_colors("gold"),
      cpal_colors("teal"),
      cpal_colors("orange")
    ))
    color_idx <- 1

    for (cyl_val in sort(unique(data$cyl))) {
      series_data <- data %>%
        filter(cyl == cyl_val) %>%
        select(x = hp, y = avg_mpg)

      hc <- hc %>%
        hc_add_series(
          data = list_parse2(series_data),
          type = "line",
          name = paste(cyl_val, "cylinders"),
          color = colors[color_idx]
        )

      color_idx <- color_idx + 1
    }

    hc
  })

  output$highchart_bar <- renderHighchart({
    data <- filtered_data() %>%
      group_by(cyl) %>%
      summarise(
        avg_mpg = round(mean(mpg), 1),
        count = n(),
        .groups = "drop"
      ) %>%
      arrange(cyl)

    if (nrow(data) == 0) {
      return(highchart() %>%
               hc_title(text = "No data matches current filters"))
    }

    highchart() %>%
      hc_chart(type = "column") %>%
      hc_title(text = "Average MPG by Cylinder Count") %>%
      hc_xAxis(title = list(text = "Number of Cylinders"),
               categories = as.character(data$cyl)) %>%
      hc_yAxis(title = list(text = "Average MPG")) %>%
      hc_add_series(
        data = data$avg_mpg,
        name = "Average MPG",
        color = unname(cpal_colors("gold")),
        dataLabels = list(enabled = TRUE, format = "{y:.1f}")
      ) %>%
      hc_tooltip(headerFormat = "Cylinders: {point.key}<br>", pointFormat = "Avg MPG: {point.y}<br>Cars: ")
  })

  output$highchart_heatmap <- renderHighchart({
    # Create correlation matrix
    if (nrow(filtered_data()) == 0) {
      return(highchart() %>%
               hc_title(text = "No data matches current filters"))
    }

    cor_data <- filtered_data() %>%
      select(mpg, cyl, disp, hp, drat, wt, qsec) %>%
      cor()

    # Create matrix for highcharter
    highchart() %>%
      hc_chart(type = "heatmap") %>%
      hc_title(text = "Correlation Matrix") %>%
      hc_xAxis(categories = colnames(cor_data), title = "") %>%
      hc_yAxis(categories = rownames(cor_data), title = "") %>%
      hc_colorAxis(
        min = -1,
        max = 1,
        minColor = unname(cpal_colors("orange")),
        maxColor = unname(cpal_colors("gold"))
      ) %>%
      hc_add_series(
        name = "Correlation",
        data = cor_data %>%
          as.data.frame() %>%
          tibble::rownames_to_column("var1") %>%
          tidyr::pivot_longer(-var1, names_to = "var2", values_to = "value") %>%
          mutate(
            x = match(var2, colnames(cor_data)) - 1,
            y = match(var1, rownames(cor_data)) - 1
          ) %>%
          select(x, y, value) %>%
          list_parse(),
        borderWidth = 1,
        dataLabels = list(enabled = TRUE, format = "{point.value:.2f}")
      ) %>%
      hc_tooltip(
        formatter = JS(
          "function () {
          return '<b>' + this.series.xAxis.categories[this.point.x] +
                 ' - ' + this.series.yAxis.categories[this.point.y] +
                 '</b><br>Correlation: <b>' +
                 Highcharts.numberFormat(this.point.value, 2) + '</b>';
        }"
        )
      )
  })

  # Static Charts (ggplot2)
  output$ggplot_scatter <- renderPlot({
    data <- filtered_data()

    ggplot(data, aes(
      x = wt,
      y = mpg,
      color = factor(cyl)
    )) +
      geom_point(size = 3, alpha = 0.8) +
      geom_smooth(method = "lm",
                  se = TRUE,
                  alpha = 0.2) +
      scale_color_cpal_d() +
      theme_cpal_print() +
      labs(
        title = "Weight vs MPG by Cylinders",
        x = "Weight (1000 lbs)",
        y = "Miles Per Gallon",
        color = "Cylinders"
      )
  })

  output$ggplot_line <- renderPlot({
    data <- filtered_data() %>%
      group_by(cyl, hp) %>%
      summarise(avg_mpg = mean(mpg), .groups = "drop") %>%
      arrange(cyl, hp)

    ggplot(data, aes(
      x = hp,
      y = avg_mpg,
      color = factor(cyl)
    )) +
      geom_line(linewidth = 1.2) +
      geom_point(size = 3) +
      scale_color_cpal_d() +
      theme_cpal_print() +
      labs(
        title = "Average MPG by Horsepower and Cylinders",
        x = "Horsepower",
        y = "Average MPG",
        color = "Cylinders"
      )
  })

  output$ggplot_bar <- renderPlot({
    data <- filtered_data() %>%
      group_by(cyl) %>%
      summarise(`Average MPG` = mean(mpg), .groups = "drop")

    ggplot(data, aes(x = factor(cyl), y = `Average MPG`)) +
      geom_col(fill = cpal_colors("gold"), alpha = 0.8) +
      geom_text(aes(label = round(`Average MPG`, 1)), vjust = -0.5) +
      theme_cpal_print() +
      labs(title = "Average MPG by Cylinder Count", x = "Number of Cylinders", y = "Average MPG")
  })

  output$ggplot_heatmap <- renderPlot({
    # Create correlation matrix
    cor_data <- filtered_data() %>%
      select(mpg, cyl, disp, hp, drat, wt, qsec) %>%
      cor()

    # Convert to long format
    cor_long <- cor_data %>%
      as.data.frame() %>%
      tibble::rownames_to_column("var1") %>%
      tidyr::pivot_longer(-var1, names_to = "var2", values_to = "correlation")

    ggplot(cor_long, aes(x = var1, y = var2, fill = correlation)) +
      geom_tile(color = "white") +
      geom_text(aes(label = round(correlation, 2)),
                color = "black",
                size = 3) +
      scale_fill_gradient2(
        low = cpal_colors("orange"),
        mid = "white",
        high = cpal_colors("gold"),
        midpoint = 0,
        limits = c(-1, 1)
      ) +
      theme_cpal_print() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(
        title = "Variable Correlation Matrix",
        x = "",
        y = "",
        fill = "Correlation"
      )
  })

  # Tables with CPAL theming
  output$gt_table <- render_gt({
    filtered_data() %>%
      select(car_name, mpg, cyl, hp, wt, efficiency_category) %>%
      slice_head(n = 10) %>%
      cpal_table_gt(title = "Top 10 Cars (Filtered Data)", subtitle = "Sorted by original dataset order")
  })

  output$reactable_table <- renderReactable({
    filtered_data() %>%
      select(car_name, mpg, cyl, hp, wt, gear, carb, efficiency_category) %>%
      cpal_table_reactable(
        searchable = TRUE,
        pagination = TRUE,
        striped = TRUE,
        highlight = TRUE
      )
  })

  output$dt_table <- DT::renderDataTable({
    DT::datatable(
      filtered_data() %>% select(-car_brand),
      options = list(
        pageLength = 15,
        scrollX = TRUE,
        search = list(regex = TRUE, caseInsensitive = TRUE)
      ),
      filter = "top",
      rownames = FALSE
    ) %>%
      DT::formatRound(columns = c("mpg", "wt"), digits = 1)
  })

  # Summary statistics
  output$summary_stats <- renderPrint({
    summary(filtered_data() %>% select(mpg, cyl, disp, hp, drat, wt, qsec))
  })

  # Advanced Features - Event Handlers
  observeEvent(input$show_notification, {
    showNotification("This is a sample notification message!",
                     type = "message",
                     duration = 3)
  })

  observeEvent(input$notif_default, {
    showNotification("Default notification", duration = 3)
  })

  observeEvent(input$notif_error, {
    showNotification("Error notification",
                     type = "error",
                     duration = 3)
  })

  observeEvent(input$notif_warning, {
    showNotification("Warning notification",
                     type = "warning",
                     duration = 3)
  })

  observeEvent(input$notif_message, {
    showNotification("Message notification",
                     type = "message",
                     duration = 3)
  })

  observeEvent(input$sweet_success, {
    sendSweetAlert(
      session = session,
      title = "Success!",
      text = "Your operation completed successfully.",
      type = "success"
    )
  })

  observeEvent(input$sweet_confirm, {
    confirmSweetAlert(
      session = session,
      inputId = "confirm_action",
      title = "Are you sure?",
      text = "This action cannot be undone.",
      type = "warning",
      showCancelButton = TRUE,
      confirmButtonText = "Yes, proceed",
      cancelButtonText = "Cancel"
    )
  })

  observeEvent(input$show_loading, {
    showNotification("Loading...",
                     id = "loading",
                     duration = NULL,
                     type = "default")
    Sys.sleep(2)  # Simulate loading
    removeNotification("loading")
    showNotification("Loading complete!", type = "message", duration = 2)
  })

  observeEvent(input$update_progress, {
    updateProgressBar(session, "demo_progress1", value = sample(1:100, 1))
    updateProgressBar(session, "demo_progress2", value = sample(1:100, 1))
  })

  observeEvent(input$update_progress_advanced, {
    updateProgressBar(session, "progress1", value = sample(1:100, 1))
    updateProgressBar(session, "progress2", value = sample(1:100, 1))
  })

  observeEvent(input$reset_inputs, {
    updateSliderInput(session, "mpg_range", value = c(min(mtcars$mpg), max(mtcars$mpg)))
    updateSelectInput(session, "cyl_select", selected = unique(mtcars$cyl))
    updateCheckboxInput(session, "show_trend", value = TRUE)
    updateRadioButtons(session, "chart_type", selected = "scatter")
    updateTextInput(session, "chart_title", value = "Motor Trend Car Analysis")
    showNotification("All inputs have been reset!", type = "message")
  })

  # Modal dialogs
  observeEvent(input$show_modal, {
    showModal(
      modalDialog(
        title = "Modal Dialog Example",
        "This is a modal dialog. You can include any content here, including inputs and outputs.",
        br(),
        br(),
        "Modal dialogs are useful for:",
        tags$ul(
          tags$li("Collecting additional user input"),
          tags$li("Displaying detailed information"),
          tags$li("Confirming actions")
        ),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("modal_ok", "OK", class = "btn-primary")
        )
      )
    )
  })

  observeEvent(input$show_modal_form, {
    showModal(
      modalDialog(
        title = "Form Modal Example",
        textInput("modal_name", "Name:"),
        selectInput(
          "modal_category",
          "Category:",
          choices = c("Category A", "Category B", "Category C")
        ),
        textAreaInput("modal_notes", "Notes:", rows = 3),
        footer = tagList(
          modalButton("Cancel"),
          actionButton("modal_submit", "Submit", class = "btn-success")
        )
      )
    )
  })

  observeEvent(input$modal_ok, {
    removeModal()
    showNotification("Modal closed with OK", type = "message")
  })

  observeEvent(input$modal_submit, {
    removeModal()
    showNotification("Form submitted successfully", type = "success")
  })

  # Collapsible card
  observeEvent(input$collapse_card, {
    shinyjs::toggle("card_body", anim = TRUE)
  })

  # Maps
  output$us_states_map <- renderMapboxgl({
    mapboxgl(
      center = c(-98.5833, 39.8283),
      zoom = 3,
      pitch = 0
    ) %>%
      add_navigation_control() %>%
      add_fill_layer(
        id = "states",
        source = states_sf,
        fill_color = unname(cpal_colors("gold")),
        fill_opacity = 0.5
      )
  })

  output$texas_counties_map <- renderMapboxgl({
    mapboxgl(
      center = c(-99.9018, 31.9686),
      zoom = 4.5,
      pitch = 0
    ) %>%
      add_navigation_control() %>%
      add_fill_layer(
        id = "counties",
        source = texas_counties_sf,
        fill_color = unname(cpal_colors("teal")),
        fill_opacity = 0.5
      )
  })

  # Download handler
  output$download_report <- downloadHandler(
    filename = function() {
      paste("mtcars_analysis_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
