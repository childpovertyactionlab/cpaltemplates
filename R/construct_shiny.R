#' construct_shiny
#'
#' Adds the necessary templates for making a Shiny application. Adds a .gitignore,
#'   app.R, Child Poverty Action Lab R Shiny, and instructions.
#'
#' @md
#' @export
construct_shiny <- function() {

  use_git_ignore_cpal(gitignore = "shiny", open = FALSE)
  use_shiny_app()

  use_instructions(instructions = "shiny")

}
