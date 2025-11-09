# Typography UI
typography_ui <- div(
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
)