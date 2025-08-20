#' Generate a Shiny BSlib Theme with CPAL Standards
#'
#' This function generates a customized BSlib theme for Shiny applications according to
#' Child Poverty Action Lab (CPAL) visual standards. It integrates with the cpaltemplates
#' color system and provides consistent branding across web applications.
#'
#' The theme is based on Bootstrap 5 with custom CPAL colors, typography, and component
#' styling. It ensures accessibility compliance and maintains visual consistency with
#' other CPAL data visualizations created using cpaltemplates.
#'
#' @param variant Character string specifying the theme variant. Options:
#'   \itemize{
#'     \item "default" - Standard CPAL theme with light background
#'     \item "dark" - Dark variant for dashboard applications
#'     \item "presentation" - High contrast variant for presentations
#'   }
#' @param custom_colors Named list of custom color overrides. Should use valid CSS colors.
#'   Common overrides: primary, secondary, success, info, warning, danger.
#' @param font_scale Numeric value to scale all fonts. Default is 1.0. Use 0.9 for
#'   dense layouts, 1.1 for accessibility.
#' @param enable_animations Logical. Whether to enable CSS transitions and animations.
#'   Set to FALSE for reduced motion accessibility.
#'
#' @return A [bslib::bs_theme()] object for use in Shiny applications.
#'
#' @details
#' The theme automatically integrates with CPAL color standards:
#' \itemize{
#'   \item Primary/Secondary: CPAL Dark Blue (#042D33)
#'   \item Success: CPAL Teal (#008097)
#'   \item Info: CPAL Yellow (#EACA2D)
#'   \item Warning: CPAL Orange (#ED683F)
#'   \item Danger: CPAL Pink (#ED018C)
#' }
#'
#' Typography uses Google Fonts:
#' \itemize{
#'   \item Headings: Poppins (consistent with CPAL branding)
#'   \item Body: Roboto (high readability)
#'   \item Code: Fira Code (developer-friendly monospace)
#' }
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(bslib)
#' library(cpaltemplates)
#'
#' # Basic CPAL themed app
#' ui <- fluidPage(
#'   theme = cpal_shiny(),
#'   titlePanel("CPAL Data Dashboard"),
#'   sidebarLayout(
#'     sidebarPanel(
#'       selectInput("program", "Select Program:",
#'                   choices = c("Education", "Housing", "Health"))
#'     ),
#'     mainPanel(
#'       plotOutput("program_plot")
#'     )
#'   )
#' )
#'
#' # Dark theme variant
#' ui_dark <- fluidPage(
#'   theme = cpal_shiny("dark"),
#'   h1("CPAL Dashboard - Dark Mode")
#' )
#'
#' # Custom color overrides
#' ui_custom <- fluidPage(
#'   theme = cpal_shiny(
#'     custom_colors = list(primary = "#1E3A8A", success = "#059669")
#'   ),
#'   h1("Custom CPAL Theme")
#' )
#'
#' # Accessibility-focused version
#' ui_accessible <- fluidPage(
#'   theme = cpal_shiny(
#'     font_scale = 1.2,
#'     enable_animations = FALSE
#'   ),
#'   h1("Accessible CPAL Theme")
#' )
#' }
#'
#' @seealso
#' \code{\link{theme_cpal}} for ggplot2 themes,
#' \code{\link{cpal_colors}} for accessing CPAL color palettes,
#' \code{\link{cpal_table_gt}} for gt table themes
#'
#' @importFrom utils modifyList
#' @export
cpal_shiny <- function(variant = "default",
                       custom_colors = NULL,
                       font_scale = 1.0,
                       enable_animations = TRUE) {

  # Check if bslib is available
  if (!requireNamespace("bslib", quietly = TRUE)) {
    cli::cli_abort("Package {.pkg bslib} is required for Shiny themes. Please install with: install.packages('bslib')")
  }

  # Validate inputs
  variant <- match.arg(variant, choices = c("default", "dark", "presentation"))

  if (!is.numeric(font_scale) || font_scale <= 0) {
    cli::cli_abort("{.arg font_scale} must be a positive number")
  }

  if (!is.logical(enable_animations)) {
    cli::cli_abort("{.arg enable_animations} must be TRUE or FALSE")
  }

  # Get CPAL colors - integrate with existing color system
  cpal_main_colors <- cpal_colors("main")

  # Define base colors for different variants
  base_colors <- switch(variant,
                        "default" = list(
                          bg = "#FFFFFF",
                          fg = "#042D33",
                          body_color = "#2F2F2F"
                        ),
                        "dark" = list(
                          bg = "#1A1A1A",
                          fg = "#FFFFFF",
                          body_color = "#E5E5E5"
                        ),
                        "presentation" = list(
                          bg = "#FAFAFA",
                          fg = "#000000",
                          body_color = "#1A1A1A"
                        )
  )

  # Define CPAL semantic colors
  semantic_colors <- list(
    primary = cpal_main_colors[1],     # CPAL Dark Blue
    secondary = cpal_main_colors[1],   # Keep consistent
    success = cpal_main_colors[2],     # CPAL Teal
    info = cpal_main_colors[3],        # CPAL Yellow
    warning = cpal_main_colors[4],     # CPAL Orange
    danger = cpal_main_colors[5]       # CPAL Pink
  )

  # Apply custom color overrides if provided
  if (!is.null(custom_colors)) {
    if (!is.list(custom_colors) || is.null(names(custom_colors))) {
      cli::cli_abort("{.arg custom_colors} must be a named list")
    }

    # Validate custom colors are valid CSS colors (basic check)
    valid_color_names <- names(semantic_colors)
    invalid_names <- setdiff(names(custom_colors), valid_color_names)
    if (length(invalid_names) > 0) {
      cli::cli_warn("Unknown color names ignored: {.val {invalid_names}}")
    }

    # Override semantic colors
    semantic_colors <- modifyList(semantic_colors, custom_colors[names(custom_colors) %in% valid_color_names])
  }

  # Create the BSlib theme
  theme <- bslib::bs_theme(
    version = 5,
    bootswatch = "flatly",

    # Base colors
    bg = base_colors$bg,
    fg = base_colors$fg,
    "body-color" = base_colors$body_color,

    # Semantic colors
    primary = semantic_colors$primary,
    secondary = semantic_colors$secondary,
    success = semantic_colors$success,
    info = semantic_colors$info,
    warning = semantic_colors$warning,
    danger = semantic_colors$danger,

    # Typography - Inter with Roboto fallback
    font_scale = font_scale,
    heading_font = bslib::font_google("Poppins"),
    base_font = bslib::font_google("Inter", "Roboto"),
    code_font = bslib::font_google("Fira Code"),

    # Visual enhancements
    "enable-gradients" = TRUE,
    "enable-shadows" = if (variant == "presentation") FALSE else TRUE,
    "enable-rounded" = TRUE,
    "enable-transitions" = enable_animations,

    # Progress bar styling
    "progress-bar-bg" = semantic_colors$primary,
    "progress-bg" = if (variant == "dark") "#2A2A2A" else "#F8F9FA",

    # Navigation styling (for navbar components)
    "navbar-light-active-color" = if (variant == "dark") base_colors$fg else "#FFFFFF",
    "nav-link-color" = if (variant == "dark") base_colors$fg else "#FFFFFF",
    "nav-link-hover-color" = if (variant == "dark") base_colors$fg else "#FFFFFF",

    # Additional CPAL-specific customizations
    "border-radius" = "6px",
    "border-color" = if (variant == "dark") "#404040" else "#E5E5E5",
    "input-border-color" = if (variant == "dark") "#404040" else "#CED4DA",
    "input-focus-border-color" = semantic_colors$primary,
    "btn-border-radius" = "6px",
    "card-border-radius" = "8px"
  )

  # Add custom CSS for enhanced CPAL styling
  custom_css <- paste0("
    /* CPAL Custom Enhancements */
    .navbar-brand {
      font-family: 'Poppins', sans-serif;
      font-weight: 600;
    }

    .card {
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      border: 1px solid ", if (variant == "dark") "#404040" else "#E5E5E5", ";
    }

    .btn {
      font-weight: 500;
      text-transform: none;
    }

    .form-control:focus {
      box-shadow: 0 0 0 0.2rem rgba(0, 72, 85, 0.25);
    }

    /* Accessibility improvements */
    .btn:focus {
      outline: 2px solid ", semantic_colors$info, ";
      outline-offset: 2px;
    }

    /* CPAL specific components */
    .cpal-metric-card {
      background: linear-gradient(135deg, ", semantic_colors$primary, " 0%, ", semantic_colors$success, " 100%);
      color: white;
      border-radius: 8px;
      padding: 1.5rem;
    }

    .cpal-metric-value {
      font-size: 2.5rem;
      font-weight: 700;
      font-family: 'Poppins', sans-serif;
    }
  ")

  # Apply custom CSS to theme
  theme <- bslib::bs_add_rules(theme, custom_css)

  # Add informative attributes
  attr(theme, "cpal_variant") <- variant
  attr(theme, "cpal_version") <- "1.0.0"
  attr(theme, "created") <- Sys.time()

  cli::cli_inform(c(
    "i" = "Created CPAL Shiny theme with {.val {variant}} variant",
    "i" = "Font scale: {.val {font_scale}}, Animations: {.val {enable_animations}}"
  ))

  return(theme)
}

#' Apply Enhanced CPAL SCSS Styling to Shiny Theme
#'
#' This function extends a basic cpal_shiny() theme by adding comprehensive
#' SCSS-based styling for advanced CPAL components like geometric headers,
#' enhanced data tables, metric cards, and responsive layouts.
#'
#' @param base_theme A bslib theme object, typically from cpal_shiny()
#' @param include_geometric_headers Logical. Whether to include the geometric
#'   header styling (recommended for content sections, not UI headers)
#' @param include_datatable_enhancements Logical. Whether to include enhanced
#'   DataTables styling
#' @param include_metric_cards Logical. Whether to include metric card system
#'
#' @return An enhanced bslib theme object with SCSS styling added
#'
#' @examples
#' \dontrun{
#' library(shiny)
#' library(bslib)
#' library(cpaltemplates)
#'
#' # Basic enhanced theme
#' enhanced_theme <- cpal_shiny() %>%
#'   cpal_add_scss_enhancements()
#'
#' # Selective enhancements (recommended for most Shiny apps)
#' ui <- fluidPage(
#'   theme = cpal_shiny() %>%
#'     cpal_add_scss_enhancements(
#'       include_geometric_headers = FALSE,  # Keep Shiny headers simple
#'       include_datatable_enhancements = TRUE,
#'       include_metric_cards = TRUE
#'     ),
#'   titlePanel("CPAL Dashboard"),
#'   # Your Shiny UI here...
#' )
#' }
#'
#' @export
cpal_add_scss_enhancements <- function(base_theme,
                                       include_geometric_headers = FALSE,
                                       include_datatable_enhancements = TRUE,
                                       include_metric_cards = TRUE) {

  # Validate base theme
  if (!inherits(base_theme, "bs_theme")) {
    cli::cli_abort("{.arg base_theme} must be a bslib theme object (from cpal_shiny() or bs_theme())")
  }

  # Read the enhanced SCSS file from package
  scss_path <- system.file("scss", "cpal-enhanced.scss", package = "cpaltemplates")

  if (!file.exists(scss_path)) {
    cli::cli_abort("Enhanced SCSS file not found. Ensure package is properly installed.")
  }

  # Conditional SCSS additions based on options
  conditional_scss <- ""

  if (!include_geometric_headers) {
    conditional_scss <- paste0(conditional_scss, "
      .shiny-app h1, .shiny-app h2, .shiny-app h3, .shiny-app h4 {
        background: none !important;
        color: var(--bs-primary) !important;
        border-radius: 0 !important;
        padding: 0.5rem 0 !important;
      }

      .shiny-app h1::before, .shiny-app h1::after,
      .shiny-app h2::before, .shiny-app h2::after,
      .shiny-app h3::after, .shiny-app h4::after {
        display: none !important;
      }
    ")
  }

  if (!include_datatable_enhancements) {
    conditional_scss <- paste0(conditional_scss, "
      .dataTables_wrapper {
        border: 1px solid var(--bs-border-color) !important;
        border-radius: var(--bs-border-radius) !important;
      }
    ")
  }

  if (!include_metric_cards) {
    conditional_scss <- paste0(conditional_scss, "
      .cpal-metric-card, .grid-link {
        background: var(--bs-primary) !important;
      }

      .cpal-metric-card:hover, .grid-link:hover {
        transform: none !important;
        background: var(--bs-primary) !important;
      }
    ")
  }

  # Add SCSS file and conditional styling to theme
  enhanced_theme <- base_theme %>%
    bslib::bs_add_rules(sass::sass_file(scss_path)) %>%
    bslib::bs_add_rules(conditional_scss)

  # Add enhancement metadata
  attr(enhanced_theme, "cpal_scss_enhanced") <- TRUE
  attr(enhanced_theme, "geometric_headers") <- include_geometric_headers
  attr(enhanced_theme, "datatable_enhanced") <- include_datatable_enhancements
  attr(enhanced_theme, "metric_cards") <- include_metric_cards

  cli::cli_inform(c(
    "i" = "Enhanced CPAL theme with SCSS styling",
    "i" = "Geometric headers: {.val {include_geometric_headers}}",
    "i" = "DataTable enhancements: {.val {include_datatable_enhancements}}",
    "i" = "Metric cards: {.val {include_metric_cards}}"
  ))

  return(enhanced_theme)
}


#' Save Enhanced CPAL SCSS File to Project
#'
#' Exports the enhanced CPAL SCSS file to your project directory for use
#' in Quarto documents, standalone CSS compilation, or custom Shiny styling.
#'
#' @param path Character string specifying where to save the SCSS file.
#'   Default is "cpal-enhanced.scss" in current working directory.
#' @param overwrite Logical. Whether to overwrite existing file.
#'
#' @return Invisibly returns the file path where SCSS was saved
#'
#' @examples
#' \dontrun{
#' # Export to current directory
#' cpal_export_scss()
#'
#' # Export to specific location
#' cpal_export_scss("assets/styles/cpal-theme.scss")
#'
#' # For use in Quarto YAML:
#' # format:
#' #   html:
#' #     theme: cpal-enhanced.scss
#' }
#'
#' @export
cpal_export_scss <- function(path = "cpal-enhanced.scss", overwrite = FALSE) {

  # Check if file exists and handle overwrite
  if (file.exists(path) && !overwrite) {
    cli::cli_abort("File {.path {path}} already exists. Use {.code overwrite = TRUE} to replace it.")
  }

  # Get the SCSS content from package
  scss_source <- system.file("scss", "cpal-enhanced.scss", package = "cpaltemplates")

  if (!file.exists(scss_source)) {
    cli::cli_abort("Enhanced SCSS file not found in package. Ensure package is properly installed.")
  }

  # Copy file to specified location
  success <- file.copy(scss_source, path, overwrite = overwrite)

  if (!success) {
    cli::cli_abort("Failed to copy SCSS file to {.path {path}}")
  }

  cli::cli_inform(c(
    "v" = "Enhanced CPAL SCSS exported to {.path {path}}",
    "i" = "Use in Quarto YAML: theme: {basename(path)}",
    "i" = "Use in Shiny: bs_theme() %>% bs_add_rules(sass_file('{path}'))"
  ))

  invisible(path)
}
