#' cpal scale color
#'
#' @export
#' @name scale_color_cpal
#' @author Michael Lopez
#' @title CPAL scale color for ggplot2
#' @param theme Collections of colors for use in visualizations. Can be either `factor`, `triad`, or `diverge`.
#' @param visual List containing different color values based on theme selected.
#' @examples
#' scale_color_cpal(theme="factor")

scale_color_cpal <- function(theme="factor", visual = list(
  diverge = c("#008097", "#E7ECEE", "#E98816"),
  triad = c("#008097", "#E98816", "#3f3f3f"),
  factor = c("#008097", "#E98816", "#3f3f3f", "#EA8B98", "#ffbe0b", "#971700", "#009763", "#6610f2")
)) {

  ggplot2::scale_color_manual(values=visual[[theme]])

}
