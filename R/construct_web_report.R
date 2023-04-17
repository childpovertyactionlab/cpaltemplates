#' construct_web_report
#'
#' Adds the necessary templates for making web reports at the Child Poverty Action Lab.
#' Adds a web report template and instructions.
#'
#' @param name A character string for the name of the created template. Be sure
#'   to end the name with ".Rmd".
#' @param directory A character string for the directory where the template
#'   should be saved.
#'@param instructions Includes a .md file with instructions on how to fill content.
#'
#' @md
#' @export
construct_web_report <- function(name = "web_report.qmd",
                                 directory = NULL,
                                 instructions = TRUE) {

  use_git_ignore_cpal(gitignore = "web_report", open = FALSE)
  use_web_report(name = name, directory = directory)
  use_css(stylesheet = "web_report", open = FALSE)
  if (instructions) {
    use_instructions(instructions = "web_report")
  }
}
