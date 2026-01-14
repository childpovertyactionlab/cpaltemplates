# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**cpaltemplates** is an R package (v2.7.0) providing templates, themes, and utilities for standardizing data visualizations at the Child Poverty Action Lab (CPAL). It ensures consistent branding and accessibility across all CPAL data products.

- **Language:** R (≥4.3.0)
- **License:** GPL-3
- **Package Type:** Standard R package with Shiny dashboard components

## Common Commands

```r
# Install dependencies
devtools::install_deps(dependencies = TRUE)

# Build documentation (roxygen2)
devtools::document()

# Run package checks
devtools::check()

# Run tests
devtools::test()

# Install package locally
devtools::install()

# Build documentation site (from docs/ directory)
quarto render
```

## Architecture

### Directory Structure

| Directory | Purpose |
|-----------|---------|
| `R/` | Core R functions organized by functionality |
| `inst/templates/` | Project scaffolding templates (.tpl files) for shiny, reports, slides, analysis projects |
| `inst/assets/` | Package assets (logos, images) |
| `docs/` | Quarto documentation site source and generated output |
| `tests/testthat/` | Test suite |
| `man/` | roxygen2-generated documentation |

### Key Files

| File | Purpose |
|------|---------|
| `R/themes.R` | ggplot2 themes (`theme_cpal()`, `theme_cpal_dark()`, etc.) |
| `R/colors.R` | Color palettes and scales (`cpal_colors()`, `scale_*_cpal()`) |
| `R/highcharter.R` | Highcharter theme and helper functions |
| `R/tables.R` | Table formatting (GT and Reactable) |
| `R/interactive.R` | Font setup and mapgl functions |
| `R/projects.R` | Project scaffolding (`start_project()`) |
| `R/dashboards.R` | Shiny dashboard themes |
| `R/utils.R` | Utility functions |

### Core Systems

1. **Theme System** - Multiple ggplot2 theme variants: `theme_cpal()`, `theme_cpal_classic()`, `theme_cpal_dark()`, `theme_cpal_map()`, `theme_cpal_print()`, `theme_cpal_minimal()`

2. **Color Palette System** - WCAG-compliant palettes via `cpal_colors()`, `cpal_colors_primary()`, `cpal_colors_extended()` with corresponding `scale_*_cpal()` functions for ggplot2

3. **Highcharter Integration** - Full Highcharter theming via `hc_theme_cpal_light()`, `hc_theme_cpal_dark()`, `hc_cpal_theme()` with helper functions for colors, tooltips, axes, and logo integration

4. **Table Formatting** - GT tables (`cpal_table_gt()`) for static/print, Reactable (`cpal_table_reactable()`) for interactive, unified via `cpal_table()`

5. **Project Scaffolding** - `start_project()` creates projects with templates (basic, analysis, report, shiny_app, shiny_dashboard, package types)

6. **BSlib Theme Integration** - `cpal_dashboard_theme()` provides themed Shiny apps using `_brand.yml` configuration

### Function Categories

| Category | Key Functions |
|----------|---------------|
| Themes | `theme_cpal()`, `theme_cpal_*()` variants, `set_theme_cpal()`, `theme_cpal_switch()` |
| Colors | `cpal_colors*()`, `scale_*_cpal()`, `scale_*_cpal_c()`, `scale_*_cpal_d()` |
| Highcharter | `hc_theme_cpal_*()`, `hc_cpal_theme()`, `hc_colors_cpal()`, `hc_tooltip_cpal()`, `hc_add_cpal_logo()` |
| Tables | `cpal_table()`, `cpal_table_gt()`, `cpal_table_reactable()` |
| Maps | `cpal_mapgl()`, `cpal_mapgl_layer()` |
| Projects | `start_project()`, `use_quarto_*()`, `use_shiny_*()` |
| Utilities | `save_cpal_plot()`, `add_cpal_logo()`, `check_plot_accessibility()` |

## Development Notes

- All functions use roxygen2 documentation - edit R files and run `devtools::document()`
- Highcharter is a core dependency (in Imports)
- Templates use `.tpl` extension and are processed by project scaffolding functions
- Tests are in `tests/testthat/` - run with `devtools::test()`
