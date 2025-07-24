# CPAL Dashboard Template
# Enhanced version with custom theme integration

library(shiny)
library(shinydashboard)
library(cpaltemplates)
library(ggplot2)
library(dplyr)
library(DT)
library(plotly)

# Load CPAL setup
import_inter_font()

# UI
ui <- dashboardPage(
  
  # Header
  dashboardHeader(
    title = "{{project_name}}",
    tags$li(
      class = "dropdown",
      tags$img(
        src = "cpal-logo-wide.png", 
        height = "40px",
        style = "margin-top: 5px; margin-right: 10px;"
      )
    )
  ),
  
  # Sidebar
  dashboardSidebar(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "cpal-theme.css")
    ),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("tachometer-alt")),
      menuItem("Data Explorer", tabName = "explorer", icon = icon("chart-bar")),
      menuItem("Reports", tabName = "reports", icon = icon("file-alt"))
    )
  ),
  
  # Body
  dashboardBody(
    
    # Custom CSS
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
          background-color: #f8f9fa;
        }
      "))
    ),
    
    tabItems(
      
      # Dashboard tab
      tabItem(
        tabName = "dashboard",
        
        fluidRow(
          valueBoxOutput("total_records"),
          valueBoxOutput("avg_value"),
          valueBoxOutput("status_count")
        ),
        
        fluidRow(
          box(
            title = "Main Visualization",
            status = "primary",
            solidHeader = TRUE,
            width = 8,
            height = 450,
            plotlyOutput("main_plot")
          ),
          
          box(
            title = "Summary Stats",
            status = "primary", 
            solidHeader = TRUE,
            width = 4,
            height = 450,
            tableOutput("summary_table")
          )
        ),
        
        fluidRow(
          box(
            title = "Interactive Data Table",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DT::dataTableOutput("data_table")
          )
        )
      ),
      
      # Data Explorer tab
      tabItem(
        tabName = "explorer",
        h2("Data Explorer - Coming Soon")
      ),
      
      # Reports tab
      tabItem(
        tabName = "reports",
        h2("Reports - Coming Soon")
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Sample data
  sample_data <- reactive({
    mtcars %>%
      rownames_to_column("model") %>%
      mutate(
        efficiency = case_when(
          mpg >= 25 ~ "High",
          mpg >= 15 ~ "Medium", 
          TRUE ~ "Low"
        )
      )
  })
  
  # Value boxes
  output$total_records <- renderValueBox({
    valueBox(
      value = nrow(sample_data()),
      subtitle = "Total Records",
      icon = icon("database"),
      color = "blue"
    )
  })
  
  output$avg_value <- renderValueBox({
    valueBox(
      value = round(mean(sample_data()$mpg), 1),
      subtitle = "Average MPG",
      icon = icon("gas-pump"),
      color = "green"
    )
  })
  
  output$status_count <- renderValueBox({
    valueBox(
      value = sum(sample_data()$efficiency == "High"),
      subtitle = "High Efficiency Cars",
      icon = icon("leaf"),
      color = "yellow"
    )
  })
  
  # Main plot
  output$main_plot <- renderPlotly({
    p <- ggplot(sample_data(), aes(x = wt, y = mpg, color = efficiency)) +
      geom_point(size = 3, alpha = 0.8) +
      scale_color_cpal(palette = "main_3") +
      theme_cpal() +
      labs(
        title = "Fuel Efficiency by Weight",
        x = "Weight (1000 lbs)",
        y = "Miles per Gallon",
        color = "Efficiency"
      )
    
    ggplotly(p) %>%
      config(displayModeBar = FALSE)
  })
  
  # Summary table
  output$summary_table <- renderTable({
    sample_data() %>%
      group_by(efficiency) %>%
      summarise(
        Count = n(),
        `Avg MPG` = round(mean(mpg), 1),
        `Avg HP` = round(mean(hp), 0),
        .groups = "drop"
      )
  }, striped = TRUE)
  
  # Data table
  output$data_table <- DT::renderDataTable({
    sample_data() %>%
      select(model, mpg, cyl, hp, wt, efficiency)
  }, 
  options = list(
    pageLength = 10,
    scrollX = TRUE
  ),
  class = "display stripe hover"
  )
}

# Run the app
shinyApp(ui = ui, server = server)

