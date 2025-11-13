# Advanced Features UI
advanced_features_ui <- div(
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
      h5("Update Progress"),
      actionButton("update_progress_advanced", "Update All Progress", class = "btn-info"),
      h5("Loading Indicators"),
      actionButton("show_loading", "Show Loading Spinner", class = "btn-primary"),
    ),
    card(
      card_header("Alerts & Notifications"),
      h5("Bootstrap Alerts"),
      div(
        class = "alert alert-info alert-dismissible d-flex align-items-start",
        tags$button(
          type = "button",
          class = "btn-close",
          `data-bs-dismiss` = "alert"
        ),
        bs_icon("info-circle", class = "flex-shrink-0 alert-status-icon"),
        div(
          tags$strong("Info:"),
          " This is an informational alert."
        )
      ),
      div(
        class = "alert alert-success alert-dismissible d-flex align-items-start",
        tags$button(
          type = "button",
          class = "btn-close",
          `data-bs-dismiss` = "alert"
        ),
        bs_icon("check-circle", class = "flex-shrink-0 alert-status-icon"),
        div(
          tags$strong("Success:"),
          " Operation completed successfully."
        )
      ),
      div(
        class = "alert alert-warning alert-dismissible d-flex align-items-start",
        tags$button(
          type = "button",
          class = "btn-close",
          `data-bs-dismiss` = "alert"
        ),
        bs_icon("exclamation-diamond", class = "flex-shrink-0 alert-status-icon"),
        div(
          tags$strong("Warning:"),
          " Please review before proceeding."
        )
      ),
      div(
        class = "alert alert-danger alert-dismissible d-flex align-items-start",
        tags$button(
          type = "button",
          class = "btn-close",
          `data-bs-dismiss` = "alert"
        ),
        bs_icon("exclamation-circle", class = "flex-shrink-0 alert-status-icon"),
        div( 
          tags$strong("Error:"),
          " An error has occurred. This text should wrap correctly below the strong tag but stay to the right of the icon."
        )
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
        actionButton("tooltip2", "Right Tooltip", class = "btn-outline-primary") %>%
          bslib::tooltip("This tooltip appears on the right", placement = "right"),
        actionButton("tooltip3", "Bottom Tooltip", class = "btn-outline-primary") %>%
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
      actionButton("show_modal", "Show Modal Dialog", class = "btn-primary me-2"),
      actionButton("show_modal_form", "Show Form Modal", class = "btn-secondary me-2"),
      br(),
      h5("Cards with Actions"),
      div(
        class = "card",
        div(
          class = "card-header d-flex justify-content-between align-items-center",
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
)
