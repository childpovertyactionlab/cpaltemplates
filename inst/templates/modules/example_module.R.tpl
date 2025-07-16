# Example Shiny Module
# This demonstrates the module pattern for Shiny apps

# Module UI
example_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Interactive Module Example"),
    fluidRow(
      column(4,
        wellPanel(
          h4("Controls"),
          sliderInput(ns("n"), "Number of points:", 
                      min = 10, max = 200, value = 50),
          selectInput(ns("color"), "Color scheme:",
                      choices = c("Blues", "Reds", "Greens", "Viridis")),
          actionButton(ns("refresh"), "Refresh Data", 
                       class = "btn-primary")
        )
      ),
      column(8,
        plotOutput(ns("plot"), height = "400px"),
        br(),
        verbatimTextOutput(ns("summary"))
      )
    )
  )
}

# Module Server
example_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    # Reactive values
    data <- reactiveVal()
    
    # Generate data
    generate_data <- function(n) {
      tibble(
        x = rnorm(n),
        y = rnorm(n),
        group = sample(c("A", "B", "C"), n, replace = TRUE)
      )
    }
    
    # Initialize data
    observe({
      data(generate_data(input$n))
    })
    
    # Refresh data on button click
    observeEvent(input$refresh, {
      data(generate_data(input$n))
    })
    
    # Create plot
    output$plot <- renderPlot({
      req(data())
      
      ggplot(data(), aes(x = x, y = y, color = group)) +
        geom_point(size = 3, alpha = 0.7) +
        scale_color_brewer(palette = input$color) +
        theme_minimal() +
        labs(
          title = "Sample Scatter Plot",
          subtitle = paste("N =", nrow(data())),
          x = "X Variable",
          y = "Y Variable"
        )
    })
    
    # Create summary
    output$summary <- renderPrint({
      req(data())
      summary(data())
    })
  })
}

