# Comprehensive CPAL Shiny Dashboard Template
# Author: Generated for CPAL template showcase
# Dataset: mtcars (built-in R dataset)

# Load required libraries
library(shiny)
library(bslib)
library(bsicons)
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

# Set environment variables
Sys.setenv(MAPBOX_PUBLIC_TOKEN = "pk.eyJ1IjoiY3BhbGFuYWx5dGljcyIsImEiOiJjbHg5ODAwMGUxaTRtMmpwdGNscms3ZnJmIn0.D6yaemYNkijMo1naveeLbw")

# Source utility and template files
source("template-sources/dashboards.R")
source("template-sources/colors.R")
source("template-sources/themes.R")
source("template-sources/interactive.R")
source("template-sources/tables.R")
source("template-sources/utils.R")
source("template-sources/projects.R")
source("template-sources/plots.R")

setup_cpal_google_fonts()

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
  # App Title and Mode switcher
  title = source("views/header-ui.R")$value,
  theme = cpal_dasbhoard_theme(),

  # Collapsible Sidebar Navigation
  sidebar = source("views/sidebar-ui.R")$value,

  # Main Content Area
  div(
    id = "main_content",

    # Input Components Section
    conditionalPanel(condition = "output.current_section == 'inputs'", source("views/input-components-ui.R")$value),

    # Interactive Charts Section
    conditionalPanel(condition = "output.current_section == 'charts'", source("views/interactive-charts-ui.R")$value),

    # Static Charts Section
    conditionalPanel(condition = "output.current_section == 'static_charts'", source("views/static-charts-ui.R")$value),

    # Data Tables Section
    conditionalPanel(condition = "output.current_section == 'tables'", source("views/data-tables-ui.R")$value),

    # Typography Section (unchanged)
    conditionalPanel(condition = "output.current_section == 'typography'", source("views/typography-ui.R")$value),

    # Advanced Features Section
    conditionalPanel(condition = "output.current_section == 'advanced'", source("views/advanced-features-ui.R")$value),

    # Maps Section
    conditionalPanel(condition = "output.current_section == 'maps'", source("views/maps-ui.R")$value),
  )
)

# Define Server
server <- function(input, output, session) {

  observeEvent(input$dark_mode, {
    toggle_dark_mode(mode = input$dark_mode)
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
      cpal_table_gt(title = "Top 10 Cars (Filtered Data)", subtitle = "Sorted by original dataset order") %>%
      cols_label(
        car_name = "Car Model",
        mpg = "MPG (Miles Per Gallon)",
        cyl = "Cylinders",
        hp = "Horsepower",
        wt = "Weight (lbs)",
        efficiency_category = "Efficiency"
      )
  })

    output$gt_table_reactable <- render_gt({
    filtered_data() %>%
      select(car_name, mpg, cyl, hp, wt, efficiency_category) %>%
      #slice_head(n = 10) %>%
      cpal_table_gt(title = "Top 10 Cars (Filtered Data)", subtitle = "Sorted by original dataset order") %>%
      cols_label(
        car_name = "Car Model",
        mpg = "MPG (Miles Per Gallon)",
        cyl = "Cylinders",
        hp = "Horsepower",
        wt = "Weight (lbs)",
        efficiency_category = "Efficiency"
      ) %>%
      opt_interactive(
        use_pagination = TRUE,
        use_page_size_select = TRUE, # Allows users to select page size
        page_size_default = 10,      # Default number of rows per page
        use_search = TRUE,            # Optional: Adds a global search bar
      )%>%
      opt_row_striping()
  })

  output$reactable_table <- renderReactable({
    filtered_data() %>%
    select(car_name, mpg, cyl, hp, wt, efficiency_category) %>%
      cpal_table_reactable(
        searchable = TRUE,
        pagination = TRUE,
        filterable = TRUE,
        striped = TRUE,
        highlight = TRUE,
        columns = list(
          car_name = colDef(name = "Car Model", sticky = "left"),
          mpg = colDef(name = "Miles/Gallon"),
          wt = colDef(name = "Weight"),
          efficiency_category = colDef(name = "Efficiency")
        )
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
                     duration = NULL)
  })

  observeEvent(input$notif_default, {
    showNotification("Default notification", duration = NULL)
  })

  observeEvent(input$notif_error, {
    showNotification("Error notification",
                     type = "error",
                     duration = NULL)
  })

  observeEvent(input$notif_warning, {
    showNotification("Warning notification",
                     type = "warning",
                     duration = NULL)
  })

  observeEvent(input$notif_message, {
    showNotification("Message notification",
                     type = "message",
                     duration = NULL)
  })

  observeEvent(input$sweet_success, {
    sendSweetAlert(
      session = session,
      title = "Success!",
      text = "Your operation completed successfully.",
      type = "success",
      btn_colors = "#007A8C"
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
      cancelButtonText = "Cancel",
      btn_colors = c("", "#007A8C")
    )
  })

  observeEvent(input$show_loading, {
    showNotification("Loading...",
                     id = "loading",
                     duration = NULL,
                     type = "default")
    Sys.sleep(2) # Simulate loading
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
          modalButton("Close"),
          actionButton("modal_submit", "Submit", class = "btn-primary")
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
