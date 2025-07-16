# CPAL Shiny Dashboard
# Created: Sys.Date()

# Load packages ----
library(shiny)
library(shinydashboard)
library(tidyverse)
library(here)
library(DT)
library(plotly)

# Source modules ----
module_files <- list.files(here("modules"), pattern = "\\.R$", full.names = TRUE)
walk(module_files, source)

# Source helper functions ----
if (file.exists(here("R", "functions.R"))) {
  source(here("R", "functions.R"))
}

# Load data ----
# data <- read_csv(here("data", "processed_data.csv"))

# UI ----
ui <- dashboardPage(
  dashboardHeader(
    title = "CPAL Dashboard"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Data Explorer", tabName = "data", icon = icon("table")),
      menuItem("Analysis", tabName = "analysis", icon = icon("chart-line")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),
  
  dashboardBody(
    # Include custom CSS
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "cpal-style.css")
    ),
    
    tabItems(
      # Overview tab
      tabItem(
        tabName = "overview",
        h2("Dashboard Overview"),
        fluidRow(
          valueBoxOutput("box1"),
          valueBoxOutput("box2"),
          valueBoxOutput("box3")
        ),
        fluidRow(
          box(
            title = "Key Metrics",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("overview_plot")
          )
        )
      ),
      
      # Data Explorer tab
      tabItem(
        tabName = "data",
        h2("Data Explorer"),
        fluidRow(
          box(
            title = "Filters",
            status = "primary",
            solidHeader = TRUE,
            width = 3,
            # Add filter UI here
            selectInput("filter_var", "Select Variable:", choices = NULL)
          ),
          box(
            title = "Data Table",
            status = "primary",
            solidHeader = TRUE,
            width = 9,
            DTOutput("data_table")
          )
        )
      ),
      
      # Analysis tab
      tabItem(
        tabName = "analysis",
        h2("Analysis"),
        # Use the example module here
        example_module_ui("example1")
      ),
      
      # About tab
      tabItem(
        tabName = "about",
        h2("About This Dashboard"),
        box(
          width = 12,
          p("This dashboard was created by the Child Poverty Action Lab."),
          p("For questions or feedback, please contact: "),
          a("datalab@childpovertyactionlab.org",
            href = "mailto:datalab@childpovertyactionlab.org")
        )
      )
    )
  )
)

# Server ----
server <- function(input, output, session) {
  
  # Overview outputs
  output$box1 <- renderValueBox({
    valueBox(
      value = "1,234",
      subtitle = "Total Records",
      icon = icon("database"),
      color = "blue"
    )
  })
  
  output$box2 <- renderValueBox({
    valueBox(
      value = "567",
      subtitle = "Active Cases",
      icon = icon("users"),
      color = "green"
    )
  })
  
  output$box3 <- renderValueBox({
    valueBox(
      value = "89%",
      subtitle = "Completion Rate",
      icon = icon("check-circle"),
      color = "yellow"
    )
  })
  
  output$overview_plot <- renderPlotly({
    # Create sample plot
    plot_ly(
      x = month.name[1:6],
      y = c(100, 120, 140, 110, 160, 150),
      type = "scatter",
      mode = "lines+markers",
      name = "Trend"
    ) %>%
      layout(
        title = "Monthly Trends",
        xaxis = list(title = "Month"),
        yaxis = list(title = "Count")
      )
  })
  
  # Data table output
  output$data_table <- renderDT({
    # Use sample data for now
    datatable(
      mtcars,
      options = list(
        pageLength = 25,
        scrollX = TRUE
      )
    )
  })
  
  # Call module
  example_module_server("example1")
}

# Run app ----
shinyApp(ui, server)

