---
format:
  pdf:
    toc: true
    toc-title: "Table of Contents"
    number-sections: true
    include-before-body: assets/tex/cover.tex
    include-in-header: assets/tex/preamble.tex
    keep-tex: true
    geometry: margin=1in
    latex-engine: xelatex
    documentclass: article
    fontsize: 11pt
    fig-width: 8.5
    fig-height: 5
    fig-dpi: 300
    mainfont: "Calibri"
execute:
  freeze: auto
  fig-width: 8.5
  fig-height: 5
  out-width: "100%"
  fig-align: "center"
  warning: false
---

\newpage

```{r setup}
#| include: false
library(tidyverse)
library(rio)
library(cpaltemplates)
library(showtext)

# Setup CPAL fonts and theme
setup_cpal_google_fonts()

# Set custom theme based on theme_cpal with size adjustments
theme_set(theme_cpal())

# Enable showtext for all graphics
showtext_auto()
showtext_opts(dpi = 300)
```

# Goals and Objectives

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Background

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## Key Insights

-   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
-   Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
-   Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

\newpage

# Data Overview

This section describes the datasets, aggregation levels, and methods used to generate insights.

## Data Sources

-   **Source:** Description
-   **Source:** Description
-   **Source:** Description

## Methodology

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

\newpage

# Results

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

\newpage

# Future Steps

## Recommendations

1.  Recommendation
2.  Recommendation
3.  Recommendation
