#' start_project
#'
#' Creates and opens a new project and project directory with useful files and folders.
#'
#' @param name Name of the project and the directory.
#' @param directory A path from the home directory of the computer to the new
#'   directory you want created.
#' @param readme Add a CPAL README to the project
#' @param gitignore Add an R .gitignore to the project
#'
#' @md
#' @export

start_project <- function(name = NULL, directory = getwd(), readme = TRUE, gitignore = FALSE) {

  print("Creating project directory.")

  usethis::create_project(path = paste0(directory, "/", name))

  print("Project directory generated.")

  Sys.sleep(5)

  print("Creating project folders.")

  dir.create(path = paste0(directory, "/", name, "/scripts"))
  dir.create(path = paste0(directory, "/", name, "/graphics"))
  dir.create(path = paste0(directory, "/", name, "/data"))

  unlink(x = paste0(directory, "/", name, "/R"), recursive = TRUE)

  print("Project folders generated.")

  Sys.sleep(5)

  print("Creating project files.")

  if (readme == TRUE) {
    use_readme_cpal(name = name, open = FALSE)
  }

  if (gitignore == TRUE) {
    use_git_ignore_cpal(gitignore = "R", open = FALSE)
  }

  print("Project files generated.")

}
