---
title: "Presentation Title"
subtitle: "Subtitle"
author: "Your Name"
institute: "Child Poverty Action Lab"
date: "`r Sys.Date()`"
format:
  revealjs:
    theme: white
    css: assets/css/cpal-style.css
    logo: assets/images/cpal-logo-wide.png
    footer: "Child Poverty Action Lab"
    slide-number: true
    chalkboard: true
    preview-links: auto
execute:
  echo: false
  warning: false
  message: false
---

```{r setup}
#| include: false
library(tidyverse)
library(here)

# Set theme for plots
theme_set(theme_minimal())

# Load any data
# data <- read_csv(here("data", "your-data.csv"))
```

# Introduction

## Overview

::: {.incremental}
- First point
- Second point
- Third point
:::

## Research Questions

1. Question 1
2. Question 2
3. Question 3

# Methods

## Data Sources

- Source 1: Description
- Source 2: Description
- Source 3: Description

## Analysis Approach

Describe your methodology here

# Results

## Key Finding 1

```{r}
#| fig-cap: "Figure 1: Description"
# Your visualization code here
# ggplot(data, aes(x, y)) + geom_point()
```

## Key Finding 2

::: {.columns}
::: {.column width="50%"}
- Point 1
- Point 2
:::

::: {.column width="50%"}
```{r}
# Visualization or table
```
:::
:::

# Conclusions

## Summary

- Main takeaway 1
- Main takeaway 2
- Main takeaway 3

## Next Steps

- Future research direction 1
- Future research direction 2

# Thank You {.center}

Questions?

**Contact:** [your.email@childpovertyactionlab.org](mailto:your.email@childpovertyactionlab.org)

**Learn more:** [childpovertyactionlab.org](https://childpovertyactionlab.org)

