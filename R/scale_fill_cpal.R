#' cpal scale fill
#'
#' @export
#' @name scale_fill_cpal
#' @author Michael Lopez
#' @title CPAL scale fill for ggplot2
#' @param theme Collections of colors for use in visualizations. Can be either 'factor', 'triad', or 'diverge'.
#' @param visual List containing different color values based on theme selected.
#' @examples
#' scale_fill_cpal(theme="factor")

scale_fill_cpal <- function(theme="factor", visual = list(
  diverge = c("#008097", "#E7ECEE", "#E98816"),
  triad = c("#008097", "#E98816", "#3f3f3f"),
  factor = c("#008097", "#E98816", "#3f3f3f", "#EA8B98", "#B5A512", "#851E2C", "#E33917")
)) {

  ggplot2::scale_fill_manual(values=visual[[theme]])

}
