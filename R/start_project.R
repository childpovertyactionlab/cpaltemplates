#' start_project
#'
#' Creates and opens a new project and project directory with useful files and folders.
#'
#' @param name Name of the project and the directory.
#' @param directory A path to the new directory to be created.
#' @param readme Add a CPAL README to the project.
#' @param gitignore Add an R .gitignore to the project.
#' @param type The type of project to set up ('General', 'Shiny', 'Quarto').
#' @param docker Logical. If TRUE, adds Dockerfile and run_app.R for running in Docker.
#' @param overwrite Logical. If TRUE, overwrite existing project if it exists.
#'
#' @md
#' @export

start_project <- function(name = NULL, directory = getwd(), readme = TRUE,
                          gitignore = FALSE, type = "General", docker = FALSE,
                          overwrite = FALSE) {

  # Define the project path
  project_path <- file.path(directory, name)

  # Check if project already exists
  if (dir.exists(project_path) && !overwrite) {
    stop("Project directory already exists. Set overwrite = TRUE to replace it.")
  }

  # Create the project
  usethis::create_project(path = project_path, open = TRUE)
  message("Project directory generated at: ", project_path)

  # Define folder structure based on project type
  folders <- switch(type,
                    "Shiny" = c("scripts", "data", "docs", "www"),
                    "Quarto" = c("scripts", "data", "docs", "quarto"),
                    "General" = c("scripts", "data", "docs"),
                    stop("Unsupported project type."))

  # Create folders
  message("Creating project folders...")
  lapply(folders, function(folder) dir.create(file.path(project_path, folder)))

  # Remove default R folder if not needed
  unlink(file.path(project_path, "R"), recursive = TRUE)
  message("Project folders created: ", paste(folders, collapse = ", "))

  # Construct project-specific files based on type
  if (type == "Shiny") {
    construct_shiny()
  } else if (type == "Quarto") {
    construct_web_report(name = paste0(name, ".qmd"), directory = project_path)
  }

  # Create project files (README, .gitignore, etc.)
  if (readme) {
    use_readme_cpal(name = name, open = FALSE)
  }

  if (gitignore) {
    use_git_ignore_cpal(gitignore = "R", open = FALSE)
  }

  # Add Dockerfile and run_app.R if requested
  if (docker) {
    usethis::use_template("Dockerfile", project_path, package = "cpaltemplates")
    usethis::use_template("run_app.R", project_path, package = "cpaltemplates")
    message("Docker support files added: Dockerfile and run_app.R.")
  }

  message("Project setup complete.")
}
