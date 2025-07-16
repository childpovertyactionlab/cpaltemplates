# Helper functions for Quarto reports

# Create a styled table using gt
cpal_table <- function(data, title = NULL, subtitle = NULL) {
  data %>%
    gt::gt() %>%
    gt::tab_header(
      title = title,
      subtitle = subtitle
    ) %>%
    gt::tab_options(
      table.font.size = gt::px(12),
      heading.title.font.size = gt::px(16),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = gt::px(14)
    )
}

# Format numbers consistently
fmt_number <- function(x, decimals = 0) {
  format(round(x, decimals), big.mark = ",", nsmall = decimals)
}

# Create a CPAL-branded plot theme
theme_cpal <- function() {
  theme_minimal() +
  theme(
    text = element_text(family = "sans"),
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 14),
    plot.caption = element_text(size = 10, color = "gray50"),
    panel.grid.minor = element_blank()
  )
}

