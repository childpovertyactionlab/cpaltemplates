library(shiny)

ui <- fluidPage(
  # Application title
  titlePanel("{name}"),

  # Sidebar layout for inputs and outputs
  sidebarLayout(
    sidebarPanel(
      # Add input controls here
      textInput("txt", "Enter text:"),
      actionButton("go", "Go")
    ),
    mainPanel(
      # Add output placeholders here
      verbatimTextOutput("out")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    output$out <- renderPrint({
      paste0("You entered: ", input$txt)
    })
  })
}

# Run the application
shinyApp(ui, server)
