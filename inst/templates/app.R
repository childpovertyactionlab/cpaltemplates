#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

##### Libraries #####
library(shiny)
library(bslib)

##### Set Shiny Options #####
options(shiny.sanitize.errors = TRUE)
options(scipen = 999)

##### App Title #####
cpaltitle <- tags$a(tags$img(src = "CPAL_Logo_White.png", height = "50"),
                    strong("APP HEADER TITLE HERE"))

#### UI #####
ui <- fluidPage(

  # shiny dashboard theme
  theme = cpal_shiny,

  # top navigation bar
  navbarPage(
    title = cpaltitle,
  ),

  # shiny dashboard layout
  sidebarLayout(position = "left",

                # side panel contents
                sidebarPanel(
                ),

                #main panel contents
                mainPanel(
                  ),
                )
)

##### Server #####
server <- function(input, output) {

  ggplot2::theme_set(cpal_theme())
  thematic::thematic_shiny(font = "auto")

}

# Run the application
shinyApp(ui = ui,
         server = server)
