# Utility functions for adding templates to existing projects

#' Add Quarto report scaffolding to an existing project
#'
#' Adds Quarto report templates, assets, and helper functions to your current project.
#' This is useful for adding reporting capability to existing analysis projects.
#'
#' @param path Character. Path to your project root (defaults to current directory).
#' @param overwrite Logical. If TRUE, existing files will be overwritten.
#' @return Invisibly returns the project path.
#' @export
use_quarto_report <- function(path = ".", overwrite = FALSE) {
  cli::cli_h3("Adding Quarto report templates")
  root <- fs::path_abs(path)

  # Create directory structure
  dirs_to_create <- c("R", "assets/css", "assets/images", "assets/tex",
                      "figures", "tables", "outputs")
  for (dir in dirs_to_create) {
    fs::dir_create(fs::path(root, dir))
  }
  cli::cli_alert_success("Created directory structure")

  # Copy images
  img_src <- system.file("templates/assets/images", package = "cpaltemplates")
  if (fs::dir_exists(img_src)) {
    imgs <- fs::dir_ls(img_src)
    if (length(imgs) > 0) {
      fs::file_copy(imgs, fs::path(root, "assets/images"), overwrite = overwrite)
      cli::cli_alert_success("Copied CPAL images")
    }
  }

  # Copy CSS
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(root, "assets/css/cpal-style.css"),
                  overwrite = overwrite)
    cli::cli_alert_success("Copied CSS styles")
  }

  # Copy Quarto templates
  rpt_path <- system.file("templates/report", package = "cpaltemplates")

  # _quarto.yml
  yml_src <- fs::path(rpt_path, "_quarto.yml.tpl")
  if (fs::file_exists(yml_src)) {
    fs::file_copy(yml_src, fs::path(root, "_quarto.yml"), overwrite = overwrite)
    cli::cli_alert_success("Created _quarto.yml")
  }

  # report.qmd
  qmd_src <- fs::path(rpt_path, "report.qmd.tpl")
  if (fs::file_exists(qmd_src)) {
    fs::file_copy(qmd_src, fs::path(root, "report.qmd"), overwrite = overwrite)
    cli::cli_alert_success("Created report.qmd template")
  }

  # TeX templates
  tex_src <- fs::path(rpt_path, "tex")
  if (fs::dir_exists(tex_src)) {
    tex_files <- fs::dir_ls(tex_src)
    if (length(tex_files) > 0) {
      fs::file_copy(tex_files, fs::path(root, "assets/tex"), overwrite = overwrite)
      cli::cli_alert_success("Copied TeX templates")
    }
  }

  # Copy functions.R template
  functions_src <- system.file("templates/functions/functions.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(functions_src) && (!fs::file_exists(fs::path(root, "R/functions.R")) || overwrite)) {
    fs::file_copy(functions_src, fs::path(root, "R/functions.R"), overwrite = overwrite)
    cli::cli_alert_success("Created R/functions.R with helper functions")
  }

  cli::cli_alert_success("Quarto report scaffolding added to {.path {root}}")
  cli::cli_alert_info("Next steps:")
  cli::cli_li("Edit {.file report.qmd} with your content")
  cli::cli_li("Preview with {.code quarto::quarto_preview()}")
  cli::cli_li("Render with {.code quarto::quarto_render()}")

  invisible(root)
}

#' Add Quarto slides to an existing project
#'
#' Adds a Quarto presentation template with CPAL branding to your project.
#'
#' @param path Character. Path to your project root.
#' @param filename Character. Name for the slides file (default: "slides.qmd").
#' @param overwrite Logical. If TRUE, overwrites existing files.
#' @return Invisibly returns the project path.
#' @export
use_quarto_slides <- function(path = ".", filename = "slides.qmd", overwrite = FALSE) {
  cli::cli_h3("Adding Quarto slides template")
  root <- fs::path_abs(path)

  # Create directories
  fs::dir_create(fs::path(root, "assets/css"))
  fs::dir_create(fs::path(root, "assets/images"))
  fs::dir_create(fs::path(root, "figures"))

  # Copy assets if not already present
  if (!fs::file_exists(fs::path(root, "assets/css/cpal-style.css"))) {
    css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
    if (fs::file_exists(css_src)) {
      fs::file_copy(css_src, fs::path(root, "assets/css/cpal-style.css"))
    }
  }

  # Copy logo if not present
  img_src <- system.file("templates/assets/images", package = "cpaltemplates")
  logo_file <- fs::path(img_src, "cpal-logo-wide.png")
  if (fs::file_exists(logo_file) && !fs::file_exists(fs::path(root, "assets/images/cpal-logo-wide.png"))) {
    fs::file_copy(logo_file, fs::path(root, "assets/images/"))
  }

  # Copy slides template
  slides_src <- system.file("templates/slides/slides.qmd.tpl", package = "cpaltemplates")
  slides_path <- fs::path(root, filename)

  if (fs::file_exists(slides_src) && (!fs::file_exists(slides_path) || overwrite)) {
    fs::file_copy(slides_src, slides_path, overwrite = overwrite)
    cli::cli_alert_success("Created {.file {filename}}")
  } else if (!fs::file_exists(slides_src)) {
    cli::cli_alert_warning("Slides template not found in package")
  } else {
    cli::cli_alert_warning("{.file {filename}} already exists. Use overwrite = TRUE to replace.")
  }

  cli::cli_alert_info("Next steps:")
  cli::cli_li("Edit {.file {filename}} with your content")
  cli::cli_li("Preview with {.code quarto::quarto_preview(\"{filename}\")}")
  cli::cli_li("Present with {.code quarto::quarto_serve(\"{filename}\")}")

  invisible(root)
}

#' Add Quarto website to an existing project
#'
#' Adds a Quarto website with multiple pages and CPAL branding to your project.
#'
#' @param path Character. Path to your project root.
#' @param overwrite Logical. If TRUE, overwrites existing files.
#' @return Invisibly returns the project path.
#' @export
use_quarto_web <- function(path = ".", overwrite = FALSE) {
  cli::cli_h3("Adding Quarto website")
  root <- fs::path_abs(path)

  # Create directories
  fs::dir_create(fs::path(root, "assets/css"))
  fs::dir_create(fs::path(root, "assets/images"))
  fs::dir_create(fs::path(root, "figures"))
  fs::dir_create(fs::path(root, "docs"))  # Output directory

  # Copy website config
  config_src <- system.file("templates/quarto-web/_quarto.yml.tpl", package = "cpaltemplates")
  if (fs::file_exists(config_src) && (!fs::file_exists(fs::path(root, "_quarto.yml")) || overwrite)) {
    fs::file_copy(config_src, fs::path(root, "_quarto.yml"), overwrite = overwrite)
    cli::cli_alert_success("Created _quarto.yml")
  }

  # Copy index page
  index_src <- system.file("templates/quarto-web/web-document.qmd.tpl", package = "cpaltemplates")
  if (fs::file_exists(index_src) && (!fs::file_exists(fs::path(root, "index.qmd")) || overwrite)) {
    fs::file_copy(index_src, fs::path(root, "index.qmd"), overwrite = overwrite)
    cli::cli_alert_success("Created index.qmd")
  }

  # Copy all CPAL assets
  copy_cpal_assets(root)

  cli::cli_alert_success("Quarto website scaffolding added to {.path {root}}")
  cli::cli_alert_info("Next steps:")
  cli::cli_li("Edit {.file index.qmd} with your content")
  cli::cli_li("Preview with {.code quarto::quarto_preview()}")
  cli::cli_li("Render site with {.code quarto::quarto_render()}")
  cli::cli_li("Publish to GitHub Pages with {.code quarto::quarto_publish()}")

  invisible(root)
}

#' Add Shiny dashboard scaffolding to an existing project
#'
#' Adds a full-featured Shiny dashboard with modules to your project.
#'
#' @param path Character. Path to your project root.
#' @param overwrite Logical. If TRUE, overwrites existing files.
#' @return Invisibly returns the project path.
#' @export
use_shiny_dashboard <- function(path = ".", overwrite = FALSE) {
  cli::cli_h3("Adding Shiny dashboard")
  root <- fs::path_abs(path)

  # Create directory structure
  dirs <- c("www", "modules", "R", "data", "data-prep")
  for (dir in dirs) {
    fs::dir_create(fs::path(root, dir))
  }
  cli::cli_alert_success("Created directory structure")

  # Copy CSS to www/
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(root, "www/cpal-style.css"), overwrite = overwrite)
    cli::cli_alert_success("Copied CSS to www/")
  }

  # Copy images to www/
  img_src <- system.file("templates/assets/images", package = "cpaltemplates")
  if (fs::dir_exists(img_src)) {
    imgs <- fs::dir_ls(img_src)
    for (img in imgs) {
      fs::file_copy(img, fs::path(root, "www"), overwrite = overwrite)
    }
    cli::cli_alert_success("Copied images to www/")
  }

  # Copy dashboard app template
  app_src <- system.file("templates/shiny/app_dashboard.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(app_src) && (!fs::file_exists(fs::path(root, "app.R")) || overwrite)) {
    fs::file_copy(app_src, fs::path(root, "app.R"), overwrite = overwrite)
    cli::cli_alert_success("Created app.R")
  }

  # Copy example module template
  module_src <- system.file("templates/modules/example_module.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(module_src) && (!fs::file_exists(fs::path(root, "modules/example_module.R")) || overwrite)) {
    fs::file_copy(module_src, fs::path(root, "modules/example_module.R"), overwrite = overwrite)
    cli::cli_alert_success("Created modules/example_module.R")
  }

  cli::cli_alert_success("Shiny dashboard scaffolding added to {.path {root}}")
  cli::cli_alert_info("Next steps:")
  cli::cli_li("Run the app with {.code shiny::runApp()}")
  cli::cli_li("Add your data to {.file data/}")
  cli::cli_li("Create additional modules in {.file modules/}")

  invisible(root)
}

#' Add simple Shiny app to an existing project
#'
#' Adds a basic Shiny application template (simpler than dashboard).
#'
#' @param path Character. Path to your project root.
#' @param overwrite Logical. If TRUE, overwrites existing files.
#' @return Invisibly returns the project path.
#' @export
use_shiny_app <- function(path = ".", overwrite = FALSE) {
  cli::cli_h3("Adding Shiny app")
  root <- fs::path_abs(path)

  # Create directories
  fs::dir_create(fs::path(root, "www"))
  fs::dir_create(fs::path(root, "R"))
  fs::dir_create(fs::path(root, "data"))

  # Copy CSS to www/
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(root, "www/cpal-style.css"), overwrite = overwrite)
    cli::cli_alert_success("Copied CSS to www/")
  }

  # Copy simple app template
  app_src <- system.file("templates/shiny/app_simple.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(app_src) && (!fs::file_exists(fs::path(root, "app.R")) || overwrite)) {
    fs::file_copy(app_src, fs::path(root, "app.R"), overwrite = overwrite)
    cli::cli_alert_success("Created app.R")
  }

  cli::cli_alert_success("Shiny app scaffolding added to {.path {root}}")
  cli::cli_alert_info("Next steps:")
  cli::cli_li("Run the app with {.code shiny::runApp()}")
  cli::cli_li("Replace example data with your own")
  cli::cli_li("Customize the UI and visualizations")

  invisible(root)
}

#' Add custom CPAL Shiny theme to an existing project
#'
#' Adds custom CSS theme files for enhanced Shiny dashboard styling.
#'
#' @param path Character. Path to your project root.
#' @param theme_name Character. Name for the theme CSS file (default: "cpal-theme.css").
#' @param overwrite Logical. If TRUE, overwrites existing files.
#' @return Invisibly returns the project path.
#' @export
use_shiny_theme <- function(path = ".", theme_name = "cpal-theme.css", overwrite = FALSE) {
  cli::cli_h3("Adding CPAL Shiny theme")
  root <- fs::path_abs(path)

  # Create www directory if it doesn't exist
  fs::dir_create(fs::path(root, "www"))

  # Copy custom theme CSS
  theme_src <- system.file("templates/shiny/themes/cpal-theme.css.tpl", package = "cpaltemplates")
  theme_dest <- fs::path(root, "www", theme_name)

  if (fs::file_exists(theme_src) && (!fs::file_exists(theme_dest) || overwrite)) {
    fs::file_copy(theme_src, theme_dest, overwrite = overwrite)
    cli::cli_alert_success("Created {.file www/{theme_name}}")
  } else if (!fs::file_exists(theme_src)) {
    cli::cli_alert_warning("Theme template not found in package")
    return(invisible(root))
  } else {
    cli::cli_alert_warning("{.file www/{theme_name}} already exists. Use overwrite = TRUE to replace.")
  }

  # Copy enhanced dashboard template if available
  enhanced_src <- system.file("templates/shiny/app_dashboard_enhanced.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(enhanced_src) && !fs::file_exists(fs::path(root, "app_enhanced.R"))) {
    fs::file_copy(enhanced_src, fs::path(root, "app_enhanced.R"))
    cli::cli_alert_success("Created {.file app_enhanced.R} with theme integration")
  }

  # Copy all CPAL assets to www
  copy_cpal_assets(root, destination = "www")

  cli::cli_alert_success("CPAL Shiny theme added to {.path {root}}")
  cli::cli_alert_info("Next steps:")
  cli::cli_li("Include theme in your UI with {.code includeCSS(\"www/{theme_name}\")}")
  cli::cli_li("Or add to dashboardHeader: {.code tags$head(tags$link(rel=\"stylesheet\", href=\"{theme_name}\"))}")
  cli::cli_li("Check {.file app_enhanced.R} for theme integration example")
  cli::cli_li("Run your app with {.code shiny::runApp()}")

  invisible(root)
}

#' Add targets pipeline to an existing project
#'
#' Adds a targets workflow for reproducible analysis pipelines.
#'
#' @param path Character. Path to your project root.
#' @param type Character. Type of pipeline: "basic", "analysis", or "report".
#' @param overwrite Logical. If TRUE, overwrites existing _targets.R.
#' @return Invisibly returns the project path.
#' @export
use_targets <- function(path = ".", type = c("basic", "analysis", "report"),
                        overwrite = FALSE) {
  type <- match.arg(type)
  cli::cli_h3("Adding targets pipeline")
  root <- fs::path_abs(path)

  # Check if _targets.R already exists
  targets_file <- fs::path(root, "_targets.R")
  if (fs::file_exists(targets_file) && !overwrite) {
    cli::cli_alert_warning("_targets.R already exists. Use overwrite = TRUE to replace.")
    return(invisible(root))
  }

  # Create directories
  fs::dir_create(fs::path(root, "R"))
  fs::dir_create(fs::path(root, "data-raw"))
  fs::dir_create(fs::path(root, "data"))
  fs::dir_create(fs::path(root, "outputs"))

  # Copy appropriate targets template
  targets_src <- system.file(
    paste0("templates/targets/targets_", type, ".R.tpl"),
    package = "cpaltemplates"
  )

  if (fs::file_exists(targets_src)) {
    fs::file_copy(targets_src, targets_file, overwrite = overwrite)
    cli::cli_alert_success("Created _targets.R ({type} template)")
  } else {
    cli::cli_alert_warning("Targets template not found: {type}")
    return(invisible(root))
  }

  # For analysis type, also copy the analysis functions template
  if (type == "analysis") {
    functions_src <- system.file("templates/functions/analysis_functions.R.tpl",
                                 package = "cpaltemplates")
    if (fs::file_exists(functions_src) && !fs::file_exists(fs::path(root, "R/analysis_functions.R"))) {
      fs::file_copy(functions_src, fs::path(root, "R/analysis_functions.R"))
      cli::cli_alert_success("Created R/analysis_functions.R with examples")
    }
  }

  # Add .gitignore entries for targets
  gitignore_path <- fs::path(root, ".gitignore")
  if (fs::file_exists(gitignore_path)) {
    gitignore_content <- readLines(gitignore_path)
    targets_entries <- c("_targets/", "_targets.yaml")
    new_entries <- targets_entries[!targets_entries %in% gitignore_content]
    if (length(new_entries) > 0) {
      writeLines(c(gitignore_content, "", "# targets", new_entries), gitignore_path)
      cli::cli_alert_success("Updated .gitignore")
    }
  }

  cli::cli_alert_info("Next steps:")
  cli::cli_li("Edit _targets.R to define your pipeline")
  cli::cli_li("Run {.code targets::tar_make()} to execute")
  cli::cli_li("Use {.code targets::tar_visnetwork()} to visualize")
  cli::cli_li("See {.url https://books.ropensci.org/targets/} for documentation")

  invisible(root)
}

#' Update CPAL assets in an existing project
#'
#' Updates CSS, images, and other branded assets to the latest versions.
#'
#' @param path Character. Path to your project root.
#' @param components Character vector. Which components to update:
#'   "css", "images", "all".
#' @return Invisibly returns the project path.
#' @export
update_cpal_assets <- function(path = ".", components = "all") {
  cli::cli_h3("Updating CPAL assets")
  root <- fs::path_abs(path)

  if ("all" %in% components) {
    components <- c("css", "images")
  }

  # Update CSS
  if ("css" %in% components) {
    css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
    if (fs::file_exists(css_src)) {
      # Check common locations
      css_locations <- c(
        "assets/css/cpal-style.css",
        "assets/style.css",
        "www/cpal-style.css",
        "style.css"
      )

      updated <- FALSE
      for (loc in css_locations) {
        css_path <- fs::path(root, loc)
        if (fs::file_exists(css_path)) {
          fs::file_copy(css_src, css_path, overwrite = TRUE)
          cli::cli_alert_success("Updated {.file {loc}}")
          updated <- TRUE
        }
      }

      if (!updated) {
        cli::cli_alert_info("No existing CSS files found to update")
      }
    }
  }

  # Update images
  if ("images" %in% components) {
    img_src <- system.file("templates/assets/images", package = "cpaltemplates")
    if (fs::dir_exists(img_src)) {
      # Check common locations
      img_locations <- c(
        "assets/images",
        "www",
        "img",
        "images"
      )

      updated <- FALSE
      for (loc in img_locations) {
        img_path <- fs::path(root, loc)
        if (fs::dir_exists(img_path)) {
          imgs <- fs::dir_ls(img_src)
          for (img in imgs) {
            img_name <- fs::path_file(img)
            dest <- fs::path(img_path, img_name)
            if (fs::file_exists(dest)) {
              fs::file_copy(img, dest, overwrite = TRUE)
              updated <- TRUE
            }
          }
          if (updated) {
            cli::cli_alert_success("Updated images in {.file {loc}}")
          }
        }
      }

      if (!updated) {
        cli::cli_alert_info("No existing image files found to update")
      }
    }
  }

  cli::cli_alert_success("Asset update complete")
  invisible(root)
}

#' Copy all CPAL brand assets to a project
#'
#' Internal helper function to copy all CPAL logos, icons, and favicons
#'
#' @param root Project root path
#' @param destination Destination folder (default: "assets/images")
#' @keywords internal
copy_cpal_assets <- function(root, destination = "assets/images") {
  # Create destination directory
  dest_path <- fs::path(root, destination)
  fs::dir_create(dest_path)

  # Define all CPAL assets to copy
  asset_categories <- c("logos", "icons", "favicons")
  copied_count <- 0

  for (category in asset_categories) {
    asset_dir <- system.file(paste0("assets/", category), package = "cpaltemplates")
    if (fs::dir_exists(asset_dir)) {
      assets <- fs::dir_ls(asset_dir)
      for (asset in assets) {
        asset_name <- fs::path_file(asset)
        dest_file <- fs::path(dest_path, asset_name)
        if (!fs::file_exists(dest_file)) {
          fs::file_copy(asset, dest_file)
          copied_count <- copied_count + 1
        }
      }
    }
  }

  if (copied_count > 0) {
    cli::cli_alert_success("Copied {copied_count} CPAL brand assets")
  }

  invisible(copied_count)
}

#' Get CPAL asset path
#'
#' Helper function to get the path to any CPAL brand asset
#'
#' @param asset_name Name of the asset file
#' @param category Category: "logos", "icons", or "favicons" (optional, will search all if not specified)
#' @return Path to the asset file, or NULL if not found
#' @export
#' @examples
#' \dontrun{
#' # Get the main teal logo
#' logo_path <- get_cpal_asset("CPAL_Logo_Teal.png")
#'
#' # Get a specific icon
#' icon_path <- get_cpal_asset("CPAL_Icon_White.png", "icons")
#' }
get_cpal_asset <- function(asset_name, category = NULL) {
  if (!is.null(category)) {
    # Search in specific category
    asset_path <- system.file(paste0("assets/", category, "/", asset_name), package = "cpaltemplates")
    if (fs::file_exists(asset_path)) {
      return(asset_path)
    }
  } else {
    # Search all categories
    categories <- c("logos", "icons", "favicons")
    for (cat in categories) {
      asset_path <- system.file(paste0("assets/", cat, "/", asset_name), package = "cpaltemplates")
      if (fs::file_exists(asset_path)) {
        return(asset_path)
      }
    }
  }

  # If not found, return NULL
  return(NULL)
}


#' Get CPAL Font Family (Simple Version)
#'
#' Simple wrapper that returns the preferred CPAL font family.
#' This is a simplified version that works with gt tables.
#'
#' @return Character string of font family name
#' @export
cpal_font_family <- function() {
  return(get_cpal_font_family(for_interactive = FALSE, setup_if_missing = FALSE))
}

#' CPAL Font Family Fallback
#'
#' Returns system font fallback when CPAL fonts are not available.
#' Used internally by theme functions.
#'
#' @return Character string of fallback font family
#' @export
cpal_font_family_fallback <- function() {
  return("sans")  # System default
}

