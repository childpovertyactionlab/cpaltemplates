#' use_instructions
#'
#' Adds instructions for constructed templates.
#'
#' @param instructions A character string for the name of the created template.
#'   Current options are `"fact_sheet_pdf"`, `"fact_sheet_html"`,
#'   `"shiny"`, and `"web_report"`.
#'
#' @md
#' @export
use_instructions <- function(instructions) {

  if (instructions %in% c("fact_sheet_pdf",
                          "fact_sheet_html",
                          "shiny",
                          "web_report")) {

    template_name <- paste0(instructions, "_instructions.md")

  } else {

    stop("Invalid 'instructions' argument. Valid instructions are: ",
         "'fact_sheet_pdf', 'fact_sheet_html', 'shiny', and 'web_report'",
         call. = FALSE)

  }

  usethis::use_template(
    template = template_name,
    save_as = template_name,
    data = list(Package = "", Version = ""),
    ignore = FALSE,
    open = TRUE,
    package = "cpaltemplates"
  )
}
