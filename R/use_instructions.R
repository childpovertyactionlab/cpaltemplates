#' Add Instructional Template
#'
#' \code{use_instructions} adds instructional templates to the project directory for specified content types.
#'
#' @param instructions A character string specifying the type of template instructions to add.
#'   Valid options are `"fact_sheet_pdf"`, `"fact_sheet_html"`, `"shiny"`, and `"web_report"`.
#'
#' @md
#' @export
use_instructions <- function(instructions) {

  valid_instructions <- c("fact_sheet_pdf", "fact_sheet_html", "shiny", "web_report")

  # Validate the instructions argument
  if (!(instructions %in% valid_instructions)) {
    stop("Invalid 'instructions' argument. Valid instructions are: 'fact_sheet_pdf', 'fact_sheet_html', 'shiny', 'web_report'", call. = FALSE)
  }

  # Construct template name
  template_name <- paste0(instructions, "_instructions.md")

  # Use the template to create the instructional file
  usethis::use_template(
    template = template_name,
    save_as = template_name,
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )

  # Inform the user
  message("Instructional template '", template_name, "' has been added.")
}
