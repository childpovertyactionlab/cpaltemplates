# CPAL Shiny App

library(shiny)
library(tidyverse)
library(here)

# Load data ----
# data <- read_csv(here("data", "your_data.csv"))

# UI ----
ui <- fluidPage(
  # Include custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "cpal-style.css")
  ),
  
  # App title
  titlePanel("CPAL Data Explorer"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      h3("Controls"),
      
      # Add inputs here
      selectInput(
        "variable",
        "Select Variable:",
        choices = c("Option 1", "Option 2", "Option 3")
      ),
      
      sliderInput(
        "range",
        "Value Range:",
        min = 0,
        max = 100,
        value = c(25, 75)
      ),
      
      br(),
      
      actionButton("update", "Update Analysis", 
                   class = "btn-primary", width = "100%")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Visualization", 
                 br(),
                 plotOutput("main_plot", height = "500px")
        ),
        tabPanel("Data Table", 
                 br(),
                 DT::dataTableOutput("table")
        ),
        tabPanel("Summary", 
                 br(),
                 verbatimTextOutput("summary")
        )
      )
    )
  )
)

# Server ----
server <- function(input, output, session) {
  
  # Reactive data (triggered by update button)
  filtered_data <- reactive({
    # Use mtcars as example data
    mtcars %>%
      filter(
        mpg >= input$range[1],
        mpg <= input$range[2]
      )
  }) %>%
    bindEvent(input$update, ignoreNULL = FALSE)
  
  # Main plot
  output$main_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = wt, y = mpg)) +
      geom_point(size = 3, alpha = 0.7, color = "#008097") +
      geom_smooth(method = "lm", se = TRUE, color = "#00A9B7") +
      theme_minimal(base_size = 14) +
      labs(
        title = "Vehicle Fuel Efficiency Analysis",
        subtitle = paste("Filtered to", nrow(filtered_data()), "vehicles"),
        x = "Weight (1000 lbs)",
        y = "Miles per Gallon",
        caption = "Source: mtcars dataset"
      )
  })
  
  # Data table
  output$table <- DT::renderDataTable({
    filtered_data() %>%
      select(mpg, cyl, disp, hp, wt) %>%
      DT::datatable(
        options = list(
          pageLength = 10,
          dom = "Bfrtip",
          buttons = c("copy", "csv", "excel")
        ),
        rownames = TRUE
      )
  })
  
  # Summary statistics
  output$summary <- renderPrint({
    cat("Summary Statistics\n\n")
    summary(filtered_data()[, c("mpg", "wt", "hp")])
  })
}

# Run app ----
shinyApp(ui, server)

