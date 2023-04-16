#' start_project
#'
#' Creates and opens a new project and project directory with useful files and folders.
#'
#' @param name Name of the project and the directory.
#' @param directory A path from the home directory of the computer to the new
#'   directory you want created.
#' @param readme Add a CPAL README to the project
#' @param gitignore Add an R .gitignore to the project
#' @param shiny Adds a folder for shiny apps to the project
#'
#' @md
#' @export
start_project <- function(path,
                          rstudio = rstudioapi::isAvailable(),
                          open = rlang::is_interactive(),
                          readme = TRUE,
                          gitignore = FALSE,
                          shiny = FALSE) {

  path <- user_path_prep(path)
  name <- path_file(path_abs(path))
  challenge_nested_project(path_dir(path), name)
  challenge_home_directory(path)

  create_directory(path)
  local_project(path, force = TRUE)

  use_directory("Scripts")
  use_directory("Data")
  use_directory("Graphics")

  if (readme == TRUE) {
    use_readme_cpal(name = name, open = FALSE)
  }

  if (gitignore == TRUE) {
    use_git_ignore_cpal(gitignore = "R", open = FALSE)
  }

  if (shiny == TRUE) {
    use_directory("Shiny")
  }

  if (rstudio) {
    use_rstudio()
  } else {
    ui_done("Writing a sentinel file {ui_path('.here')}")
    ui_todo("Build robust paths within your project via {ui_code('here::here()')}")
    ui_todo("Learn more at <https://here.r-lib.org>")
    file_create(proj_path(".here"))
  }

  if (open) {
    if (proj_activate(proj_get())) {
      # working directory/active project already set; clear the scheduled
      # restoration of the original project
      withr::deferred_clear()
    }
  }

  invisible(proj_get())
}
