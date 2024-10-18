#' use_git_ignore_cpal
#'
#' Adds a .gitignore file tailored for R projects.
#'
#' @param gitignore Content to be added to the .gitignore file. Default is set to 'R'.
#' @param open Logical. If TRUE, opens the .gitignore file after creation.
#'
#' @export
use_git_ignore_cpal <- function(gitignore = "R", open = TRUE) {
  gitignore_path <- file.path(getwd(), ".gitignore")

  # Define default gitignore content for R projects
  gitignore_content <- c(
    ".Rhistory",
    ".RData",
    ".Rproj.user",
    "data/*.csv",
    "data/*.rds",
    "rsconnect/"
  )

  # Append additional content if provided
  if (!is.null(gitignore)) {
    gitignore_content <- c(gitignore_content, gitignore)
  }

  writeLines(gitignore_content, con = gitignore_path)

  if (open) {
    usethis::edit_file(gitignore_path)
  }

  message(".gitignore created and configured.")
}
