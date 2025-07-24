---
title: "{{project_name}}"
format:
  html:
    theme: cosmo
    css: assets/css/cpal-style.css
    toc: true
    toc-depth: 3
    number-sections: true
    code-fold: true
    code-tools: true
    fig-width: 8
    fig-height: 5
execute:
  echo: false
  warning: false
  message: false
---

```{r setup}
#| include: false
library(cpaltemplates)
library(ggplot2)
library(dplyr)

# Set up CPAL defaults
import_inter_font()
set_theme_cpal()
```

# Introduction

This is a CPAL web document template with interactive features and professional styling.

## Data Visualization

```{r example-plot}
#| fig-cap: "Example CPAL-styled visualization"

# Example plot with CPAL styling
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_cpal(palette = "main_3") +
  labs(
    title = "Sample CPAL Visualization",
    subtitle = "Professional styling with brand colors",
    x = "Weight (1000 lbs)",
    y = "Miles per Gallon",
    color = "Cylinders"
  )
```

## Interactive Content

```{r interactive-table}
#| fig-cap: "Interactive data table"

# Interactive table example
sample_data <- mtcars %>%
  rownames_to_column("model") %>%
  select(model, mpg, cyl, hp, wt) %>%
  head(10)

cpal_table_interactive(sample_data)
```

## Conclusion

Add your analysis conclusions here.

---

*Generated with cpaltemplates • {{date}}*

