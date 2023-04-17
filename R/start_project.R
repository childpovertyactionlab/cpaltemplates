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

start_project <- function(name = NULL, directory = getwd(), readme = TRUE, gitignore = TRUE, shiny = FALSE) {

  usethis::create_project(path = paste0(directory, "/", name), open = FALSE)

  if (shiny == TRUE) {
    usethis::use_directory(path = paste0(directory, "/", name, "/Shiny"))
  }

  usethis::use_directory(path = paste0(directory, "/", name, "/Data"))
  usethis::use_directory(path = paste0(directory, "/", name, "/Scripts"))
  usethis::use_directory(path = paste0(directory, "/", name, "/Graphics"))

  if (readme == TRUE) {
    use_readme_cpal(name = name, open = FALSE)
  }

  if (gitignore == TRUE) {
    use_git_ignore_cpal(gitignore = "R", open = FALSE)
  }

}
