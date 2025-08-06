#' Start a new CPAL project with modern workflows
#'
#' Creates a new project with intelligent defaults and modern R best practices.
#' By default, runs in interactive mode to guide users through setup.
#'
#' @param name Character. Project name (used for folder and .Rproj file).
#' @param path Character. Parent directory where project folder is created.
#' @param project_type Character. Type of project: "analysis", "quarto-report",
#'   "quarto-slides", "shiny-dashboard", "shiny-app", or "package".
#' @param interactive Logical. If TRUE (default), guides user through setup.
#' @param features Character vector. Features to enable: "renv", "git", "github",
#'   "targets", "tests".
#' @param open Logical. If TRUE, opens the project in RStudio after creation.
#' @param overwrite Logical. If TRUE, overwrites existing directory.
#'
#' @return Invisibly returns the full path to the created project.
#' @export
start_project <- function(
    name = NULL,
    path = ".",
    project_type = NULL,
    interactive = TRUE,
    features = NULL,
    open = TRUE,
    overwrite = FALSE
) {
  # Load required namespaces
  require_packages <- function(pkgs) {
    missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
    if (length(missing) > 0) {
      stop("Please install: ", paste(missing, collapse = ", "))
    }
  }
  require_packages(c("cli", "fs"))
  # Define available options
  project_types <- c(
    "analysis" = "General analysis with targets pipeline",
    "quarto-report" = "Quarto report (HTML, PDF, Word)",
    "quarto-slides" = "Quarto presentation slides",
    "quarto-web" = "Quarto website with multiple pages",
    "shiny-dashboard" = "Full-featured Shiny dashboard",
    "shiny-app" = "Simple Shiny application",
    "package" = "R package development"
  )
  feature_options <- c(
    "renv" = "Dependency management",
    "git" = "Version control",
    "github" = "GitHub integration",
    "targets" = "Pipeline management",
    "tests" = "Testing framework"
  )
  # Interactive mode
  if (interactive) {
    if (is.null(name)) {
      name <- readline("Project name: ")
      if (name == "") stop("Project name required")
    }
    if (is.null(project_type)) {
      cli::cli_h3("Select project type:")
      for (i in seq_along(project_types)) {
        cat(i, ". ", names(project_types)[i], " - ", project_types[i], "\n", sep = "")
      }
      choice <- as.integer(readline("Choice (1-6): "))
      project_type <- names(project_types)[choice]
    }
    if (is.null(features)) {
      # Suggest defaults based on project type
      defaults <- switch(
        project_type,
        "analysis" = c("targets", "renv", "git"),
        "quarto-report" = c("renv", "git"),
        "quarto-slides" = c("renv", "git"),
        "shiny-dashboard" = c("renv", "git", "tests"),
        "shiny-app" = c("renv", "git"),
        "package" = c("renv", "git", "tests")
      )
      cli::cli_h3("Select features (space-separated numbers):")
      for (i in seq_along(feature_options)) {
        default_mark <- if (names(feature_options)[i] %in% defaults) " [default]" else ""
        cat(i, ". ", names(feature_options)[i], " - ", feature_options[i], default_mark, "\n", sep = "")
      }
      input <- readline("Choice (Enter for defaults): ")
      if (input == "") {
        features <- defaults
      } else {
        nums <- as.integer(strsplit(input, "\\s+")[[1]])
        features <- names(feature_options)[nums]
      }
    }
  }
  # Validate inputs
  if (is.null(name) || name == "") stop("Name required")
  if (!project_type %in% names(project_types)) {
    stop("Invalid type. Choose: ", paste(names(project_types), collapse = ", "))
  }
  # Create project
  full_path <- fs::path_abs(fs::path(path, name))
  # Check existing
  if (fs::dir_exists(full_path)) {
    if (overwrite) {
      cli::cli_alert_warning("Overwriting {.path {full_path}}")
      fs::dir_delete(full_path)
    } else {
      stop("Directory exists. Use overwrite = TRUE")
    }
  }
  cli::cli_h2("Creating project: {.strong {name}}")
  # Create structure
  create_base_structure(full_path, project_type)
  create_rproj(full_path, name)
  copy_assets(full_path)
  # Set up project type
  setup_functions <- list(
    "analysis" = setup_analysis,
    "quarto-report" = setup_quarto_report,
    "quarto-slides" = setup_quarto_slides,
    "quarto-web" = setup_quarto_web,
    "shiny-dashboard" = setup_shiny_dashboard,
    "shiny-app" = setup_shiny_app,
    "package" = setup_package
  )
  setup_functions[[project_type]](full_path, features)
  # Enable features
  if ("renv" %in% features) setup_renv(full_path)
  if ("git" %in% features) setup_git(full_path)
  if ("github" %in% features && !"git" %in% features) create_gitignore(full_path)
  # Create README
  create_project_readme(full_path, name, project_type, features)
  # Show next steps
  show_project_next_steps(name, project_type, features)
  # Open project
  if (open && requireNamespace("rstudioapi", quietly = TRUE)) {
    if (rstudioapi::isAvailable()) {
      rstudioapi::openProject(full_path, newSession = TRUE)
    }
  }
  invisible(full_path)
}
# Helper functions ----
#' Create base project directory structure
#' 
#' Internal function to create standard CPAL project folders and files.
#' 
#' @param path Character. Full path to project directory
#' @param type Character. Type of project (determines additional folders)
#' @return Invisibly returns TRUE on success
#' @keywords internal
create_base_structure <- function(path, type) {
  # Base folders for all projects
  base <- c("R", "data-raw", "data", "outputs", "docs", "assets/images", "assets/css")
  # Type-specific folders
  type_specific <- switch(
    type,
    "analysis" = c("notebooks", "figures", "tables"),
    "quarto-report" = c("figures", "tables", "assets/tex"),
    "quarto-slides" = c("figures"),
    "shiny-dashboard" = c("modules", "www", "data-prep"),
    "shiny-app" = c("www"),
    "package" = c("man", "inst", "vignettes"),
    character(0)
  )
  all_dirs <- unique(c(base, type_specific))
  for (d in all_dirs) {
    fs::dir_create(fs::path(path, d))
  }
  cli::cli_alert_success("Created directory structure")
}
#' Create RStudio Project File
#'
#' Creates an RStudio project file (.Rproj) from the CPAL template.
#' This file contains RStudio-specific settings for consistent project behavior.
#'
#' @param path Character. Directory path where the .Rproj file will be created.
#' @param name Character. Project name (used for the .Rproj filename).
#'
#' @return Invisible NULL. Creates .Rproj file as a side effect.
#' @keywords internal
create_rproj <- function(path, name) {
  # Copy from template
  rproj_src <- system.file("templates/rproj.tpl", package = "cpaltemplates")
  if (fs::file_exists(rproj_src)) {
    fs::file_copy(rproj_src, fs::path(path, paste0(name, ".Rproj")))
    cli::cli_alert_success("Created {.file {name}.Rproj}")
  } else {
    cli::cli_alert_warning("RProj template not found")
  }
}

#' Copy CPAL Assets to Project
#'
#' Copies CPAL branding assets (logos, icons, CSS) to the project directory.
#' Creates an assets folder with organized CPAL brand elements.
#'
#' @param path Character. Project directory path where assets will be copied.
#'
#' @return Invisible NULL. Copies asset files as a side effect.
#' @keywords internal
copy_assets <- function(path) {
  # Copy images
  img_src <- system.file("templates/assets/images", package = "cpaltemplates")
  if (fs::dir_exists(img_src)) {
    imgs <- fs::dir_ls(img_src)
    if (length(imgs) > 0) {
      fs::file_copy(imgs, fs::path(path, "assets/images"))
      cli::cli_alert_success("Copied {length(imgs)} images")
    }
  }
  # Copy CSS
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(path, "assets/css/cpal-style.css"))
    cli::cli_alert_success("Copied CSS styles")
  }
}
# Project-specific setup functions ----
#' Setup Analysis Project Template
#'
#' Sets up a general analysis project with R scripts and targets pipeline.
#' Creates analysis-specific templates and folder structure.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates analysis template files as a side effect.
#' @keywords internal
setup_analysis <- function(path, features) {
  # Copy analysis template
  analysis_src <- system.file("templates/analysis/analysis_template.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(analysis_src)) {
    fs::file_copy(analysis_src, fs::path(path, "R/01-analysis.R"))
    cli::cli_alert_success("Created R/01-analysis.R")
  } else {
    cli::cli_alert_warning("Analysis template not found")
  }
  if ("targets" %in% features) {
    fs::dir_create(fs::path(path, "data-prep"))
    cli::cli_alert_info("Created data-prep/ for targets workflow")
  }
}
#' Setup Quarto Report Project Template
#'
#' Creates a Quarto report project with CPAL branding and styling.
#' Includes report template, LaTeX settings, and CPAL theme integration.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates Quarto report template files as a side effect.
#' @keywords internal
setup_quarto_report <- function(path, features) {
  # Create _quarto.yml
  if (requireNamespace("yaml", quietly = TRUE)) {
    config <- list(
      project = list(
        type = "default",
        output_dir = "outputs"
      ),
      format = list(
        html = list(
          theme = "cosmo",
          css = "assets/css/cpal-style.css",
          toc = TRUE,
          toc_depth = 3
        ),
        pdf = list(
          documentclass = "article",
          include_in_header = "assets/tex/header.tex"
        ),
        docx = list(
          toc = TRUE,
          reference_doc = "assets/templates/word-template.docx"
        )
      )
    )
    yaml::write_yaml(config, fs::path(path, "_quarto.yml"))
  }
  # Copy tex templates if available
  tex_src <- system.file("templates/report/tex", package = "cpaltemplates")
  if (fs::dir_exists(tex_src)) {
    tex_files <- fs::dir_ls(tex_src)
    if (length(tex_files) > 0) {
      fs::file_copy(tex_files, fs::path(path, "assets/tex"))
      cli::cli_alert_success("Copied TeX templates")
    }
  }
  # Create report template
  # Copy report template
  report_src <- system.file("templates/report/report.qmd.tpl", package = "cpaltemplates")
  if (fs::file_exists(report_src)) {
    fs::file_copy(report_src, fs::path(path, "report.qmd"))
    cli::cli_alert_success("Created report.qmd")
  } else {
    cli::cli_alert_warning("Report template not found")
  }
  # Copy functions template
  functions_src <- system.file("templates/functions/functions.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(functions_src)) {
    fs::file_copy(functions_src, fs::path(path, "R/functions.R"))
    cli::cli_alert_success("Created R/functions.R with helper functions")
  }
  cli::cli_alert_success("Set up Quarto report")
}
#' Setup Quarto Slides Project Template
#'
#' Creates a Quarto presentation project with CPAL branding.
#' Includes slide template with CPAL theme and styling.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates Quarto slides template files as a side effect.
#' @keywords internal
setup_quarto_slides <- function(path, features) {
  # Copy slides template
  slides_src <- system.file("templates/slides/slides.qmd.tpl", package = "cpaltemplates")
  if (fs::file_exists(slides_src)) {
    fs::file_copy(slides_src, fs::path(path, "slides.qmd"))
    cli::cli_alert_success("Created slides.qmd")
  } else {
    cli::cli_alert_warning("Slides template not found")
  }
  cli::cli_alert_success("Set up Quarto slides")
}

#' Setup Quarto Web Project Template
#'
#' Creates a Quarto website project with multiple pages and CPAL branding.
#' Includes navigation, multiple content pages, and CPAL styling.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates Quarto web template files as a side effect.
#' @keywords internal
setup_quarto_web <- function(path, features) {
  # Create _quarto.yml for website
  config_src <- system.file("templates/quarto-web/_quarto.yml.tpl", package = "cpaltemplates")
  if (fs::file_exists(config_src)) {
    fs::file_copy(config_src, fs::path(path, "_quarto.yml"))
    cli::cli_alert_success("Created _quarto.yml for website")
  }

  # Copy web document template
  web_src <- system.file("templates/quarto-web/web-document.qmd.tpl", package = "cpaltemplates")
  if (fs::file_exists(web_src)) {
    fs::file_copy(web_src, fs::path(path, "index.qmd"))
    cli::cli_alert_success("Created index.qmd")
  } else {
    cli::cli_alert_warning("Web document template not found")
  }

  # Copy CSS styles
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::dir_create(fs::path(path, "assets/css"))
    fs::file_copy(css_src, fs::path(path, "assets/css/cpal-style.css"))
    cli::cli_alert_success("Copied CSS styles")
  }

  cli::cli_alert_success("Set up Quarto website")
}

#' Setup Shiny Dashboard Project Template
#'
#' Creates a full-featured Shiny dashboard with CPAL branding and modular structure.
#' Includes dashboard template, modules, and CPAL theme integration.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates Shiny dashboard template files as a side effect.
#' @keywords internal
setup_shiny_dashboard <- function(path, features) {
  # Copy dashboard app template
  app_src <- system.file("templates/shiny/app_dashboard.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(app_src)) {
    fs::file_copy(app_src, fs::path(path, "app.R"))
    cli::cli_alert_success("Created app.R")
  }

  # Copy CSS to www/
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(path, "www/cpal-style.css"))
  }

  # Copy example module template
  module_src <- system.file("templates/modules/example_module.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(module_src)) {
    fs::file_copy(module_src, fs::path(path, "modules/example_module.R"))
    cli::cli_alert_success("Created modules/example_module.R")
  }

  cli::cli_alert_success("Set up Shiny dashboard")
}
#' Setup Shiny App Project Template
#'
#' Creates a simple Shiny application with CPAL branding.
#' Includes basic app template with CPAL styling.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates Shiny app template files as a side effect.
#' @keywords internal
setup_shiny_app <- function(path, features) {
  # Copy simple app template
  app_src <- system.file("templates/shiny/app_simple.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(app_src)) {
    fs::file_copy(app_src, fs::path(path, "app.R"))
    cli::cli_alert_success("Created app.R")
  }

  # Copy CSS to www/
  css_src <- system.file("templates/style.css.tpl", package = "cpaltemplates")
  if (fs::file_exists(css_src)) {
    fs::file_copy(css_src, fs::path(path, "www/cpal-style.css"))
  }

  cli::cli_alert_success("Set up Shiny app")
}
#' Setup R Package Project Template
#'
#' Creates an R package development project with CPAL standards.
#' Includes package structure, DESCRIPTION, and development templates.
#'
#' @param path Character. Project directory path.
#' @param features Character vector. Enabled features for the project.
#'
#' @return Invisible NULL. Creates R package template files as a side effect.
#' @keywords internal
setup_package <- function(path, features) {
  # Create DESCRIPTION
  # Copy DESCRIPTION template
  desc_src <- system.file("templates/package/DESCRIPTION.tpl", package = "cpaltemplates")
  if (fs::file_exists(desc_src)) {
    # Read template and replace package name
    desc_content <- readLines(desc_src)
    desc_content <- gsub("{{package_name}}", fs::path_file(path), desc_content)
    writeLines(desc_content, fs::path(path, "DESCRIPTION"))
    cli::cli_alert_success("Created DESCRIPTION")
  } else {
    cli::cli_alert_warning("DESCRIPTION template not found")
  }
  # Create NAMESPACE
  writeLines("# Generated by roxygen2: do not edit by hand", fs::path(path, "NAMESPACE"))
  # Create example function
  example_fn <- c(
    "#' Hello World",
    "#'",
    "#' @param name Your name",
    "#' @return A greeting",
    "#' @export",
    "hello <- function(name = \"World\") {",
    "  paste(\"Hello,\", name)",
    "}"
  )
  writeLines(example_fn, fs::path(path, "R/hello.R"))
  cli::cli_alert_success("Set up R package")
}
# Feature setup functions ----
#' Create Targets Pipeline File
#'
#' Creates a targets workflow file customized for the project type.
#' Includes appropriate pipeline structure for analysis or report generation.
#'
#' @param path Character. Project directory path.
#'
#' @return Invisible NULL. Creates _targets.R file as a side effect.
#' @keywords internal
create_targets_file <- function(path) {
  # Copy targets template for analysis
  targets_src <- system.file("templates/targets/targets_analysis.R.tpl", package = "cpaltemplates")
  if (fs::file_exists(targets_src)) {
    fs::file_copy(targets_src, fs::path(path, "_targets.R"))
    cli::cli_alert_success("Created targets pipeline")
  } else {
    cli::cli_alert_warning("Targets template not found")
  }
}
#' Setup renv for dependency management
#' 
#' Internal function to initialize renv in a project.
#' 
#' @param path Character. Full path to project directory
#' @return Invisibly returns TRUE on success
#' @keywords internal
setup_renv <- function(path) {
  if (requireNamespace("renv", quietly = TRUE)) {
    old_wd <- getwd()
    setwd(path)
    tryCatch({
      renv::init(bare = TRUE)
      cli::cli_alert_success("Initialized renv")
    }, finally = {
      setwd(old_wd)
    })
  } else {
    cli::cli_alert_warning("Package renv not installed")
  }
}
#' Setup git repository
#' 
#' Internal function to initialize git repository and create .gitignore.
#' 
#' @param path Character. Full path to project directory
#' @return Invisibly returns TRUE on success
#' @keywords internal
setup_git <- function(path) {
  if (requireNamespace("gert", quietly = TRUE)) {
    create_gitignore(path)
    gert::git_init(path)
    # Initial commit
    old_wd <- getwd()
    setwd(path)
    tryCatch({
      gert::git_add(".")
      gert::git_commit("Initial commit from cpaltemplates")
      cli::cli_alert_success("Initialized git repository")
    }, finally = {
      setwd(old_wd)
    })
  } else {
    cli::cli_alert_warning("Package gert not installed")
    create_gitignore(path)
  }
}
#' Create .gitignore File
#'
#' Creates a comprehensive .gitignore file appropriate for R projects.
#' Includes common R, RStudio, and data file patterns.
#'
#' @param path Character. Project directory path.
#'
#' @return Invisible NULL. Creates .gitignore file as a side effect.
#' @keywords internal
create_gitignore <- function(path) {
  # Copy gitignore template
  gitignore_src <- system.file("templates/gitignore.tpl", package = "cpaltemplates")
  if (fs::file_exists(gitignore_src)) {
    fs::file_copy(gitignore_src, fs::path(path, ".gitignore"))
    cli::cli_alert_success("Created .gitignore")
  } else {
    cli::cli_alert_warning("Gitignore template not found")
  }
}
#' Create Project README
#'
#' Creates a comprehensive README.md file for the project with CPAL branding.
#' Includes project description, setup instructions, and usage guidelines.
#'
#' @param path Character. Project directory path.
#' @param name Character. Project name.
#' @param type Character. Project type.
#' @param features Character vector. Enabled project features.
#'
#' @return Invisible NULL. Creates README.md file as a side effect.
#' @keywords internal
create_project_readme <- function(path, name, type, features) {
  content <- c(
    paste0("# ", name),
    "",
    "Created with cpaltemplates",
    "",
    paste0("Project type: ", type),
    "",
    if (length(features) > 0) {
      c("Features enabled:", paste0("- ", features))
    },
    "",
    "## Getting Started",
    "",
    switch(
      type,
      "analysis" = c(
        "1. Add data to `data-raw/`",
        "2. Edit analysis scripts in `R/`",
        if ("targets" %in% features) "3. Run `targets::tar_make()`" else "3. Run analysis scripts"
      ),
      "quarto-report" = c(
        "1. Edit `report.qmd`",
        "2. Preview with `quarto::quarto_preview()`",
        "3. Render with `quarto::quarto_render()`"
      ),
      "quarto-slides" = c(
        "1. Edit `slides.qmd`",
        "2. Preview with `quarto::quarto_preview()`"
      ),
      "shiny-dashboard" = c(
        "1. Edit `app.R`",
        "2. Run with `shiny::runApp()`"
      ),
      "shiny-app" = c(
        "1. Edit `app.R`",
        "2. Run with `shiny::runApp()`"
      ),
      "package" = c(
        "1. Edit DESCRIPTION",
        "2. Add functions to `R/`",
        "3. Document with `devtools::document()`"
      )
    )
  )
  writeLines(content, fs::path(path, "README.md"))
}
#' Show Project Next Steps
#'
#' Displays helpful next steps and instructions for the newly created project.
#' Provides guidance on getting started with the project type and features.
#'
#' @param name Character. Project name.
#' @param type Character. Project type.
#' @param features Character vector. Enabled project features.
#'
#' @return Invisible NULL. Displays messages as a side effect.
#' @keywords internal
show_project_next_steps <- function(name, type, features) {
  cli::cli_h3(" Project {.strong {name}} created!")
  cli::cli_alert_info("Next steps:")
  steps <- switch(
    type,
    "analysis" = list(
      "Add data to {.file data-raw/}",
      "Edit {.file R/01-analysis.R}",
      if ("targets" %in% features) "Run {.code targets::tar_make()}"
    ),
    "quarto-report" = list(
      "Edit {.file report.qmd}",
      "Preview with {.code quarto::quarto_preview()}"
    ),
    "quarto-slides" = list(
      "Edit {.file slides.qmd}",
      "Preview with {.code quarto::quarto_preview()}"
    ),
    "quarto-web" = list(
      "Edit {.file index.qmd}",
      "Preview with {.code quarto::quarto_preview()}",
      "Render site with {.code quarto::quarto_render()}"
    ),
    "shiny-dashboard" = list(
      "Edit {.file app.R}",
      "Run with {.code shiny::runApp()}"
    ),
    "shiny-app" = list(
      "Edit {.file app.R}",
      "Run with {.code shiny::runApp()}"
    ),
    "package" = list(
      "Edit {.file DESCRIPTION}",
      "Add functions to {.file R/}",
      "Document with {.code devtools::document()}"
    )
  )
  for (step in steps) {
    if (!is.null(step)) cli::cli_li(step)
  }
  if ("renv" %in% features) {
    cli::cli_alert_info("Remember to {.code renv::snapshot()} after installing packages")
  }
}
