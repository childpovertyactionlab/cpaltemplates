# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**cpaltemplates** is an R package (v2.0.1) providing templates, themes, and utilities for standardizing data visualizations at the Child Poverty Action Lab (CPAL). It ensures consistent branding and accessibility across all CPAL data products.

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

# Run the demo Shiny app (showcases all features)
shiny::runApp("base-app")

# Build documentation site (from docs/ directory)
quarto render
```

## Architecture

### Directory Structure

| Directory | Purpose |
|-----------|---------|
| `R/` | Core R functions (dashboards.R is the main file) |
| `base-app/` | Shiny dashboard demo/template with modular UI components |
| `inst/templates/` | Project scaffolding templates (.tpl files) for shiny, reports, slides, analysis projects |
| `inst/assets/` | Package assets (logos, images) |
| `docs/` | Quarto documentation site source and generated output |
| `tests/testthat/` | Test suite |
| `man/` | roxygen2-generated documentation (73 .Rd files) |

### Key Files

- **`R/dashboards.R`** - Main function implementations including `cpal_shiny()` theme
- **`base-app/_brand.yml`** - BSlib/Quarto brand configuration (colors, fonts, Bootstrap settings)
- **`base-app/app.R`** - Complete Shiny dashboard showcasing all package features
- **`base-app/template-sources/*.R`** - Modular helper functions (colors, themes, interactive, tables, plots)
- **`base-app/views/*.R`** - Modular UI components for the demo app
- **`inst/templates/styles.scss`** - Base SCSS stylesheet (22KB)
- **`NAMESPACE`** - 57 exported functions

### Core Systems

1. **Theme System** - Multiple ggplot2 theme variants: `theme_cpal()`, `theme_cpal_classic()`, `theme_cpal_dark()`, `theme_cpal_map()`, `theme_cpal_print()`, `theme_cpal_minimal()`

2. **Color Palette System** - WCAG-compliant palettes via `cpal_colors()`, `cpal_colors_primary()`, `cpal_colors_extended()` with corresponding `scale_*_cpal()` functions for ggplot2

3. **Interactive Visualization** - ggiraph abstraction via `cpal_interactive()` and layer-specific functions: `cpal_point_interactive()`, `cpal_line_interactive()`, `cpal_col_interactive()`

4. **Table Formatting** - GT tables (`cpal_table_gt()`) for static/print, Reactable (`cpal_table_reactable()`) for interactive, unified via `cpal_table()`

5. **Project Scaffolding** - `start_project()` creates projects with templates (basic, analysis, report, shiny_app, shiny_dashboard, package types)

6. **BSlib Theme Integration** - `cpal_shiny()` provides themed Shiny apps using `_brand.yml` configuration

### Function Categories

| Category | Key Functions |
|----------|---------------|
| Themes | `theme_cpal()`, `theme_cpal_*()` variants, `set_theme_cpal()` |
| Colors | `cpal_colors*()`, `scale_*_cpal()`, `scale_*_cpal_c()`, `scale_*_cpal_d()` |
| Interactive | `cpal_interactive()`, `cpal_*_interactive()` |
| Tables | `cpal_table()`, `cpal_table_gt()`, `cpal_table_reactable()` |
| Maps | `cpal_mapgl()`, `cpal_mapgl_layer()` |
| Projects | `start_project()`, `use_quarto_*()`, `use_shiny_*()` |
| Utilities | `save_cpal_plot()`, `add_cpal_logo()`, `check_plot_accessibility()` |

## Development Notes

- All functions use roxygen2 documentation - edit R files and run `devtools::document()`
- The `base-app/` Shiny app requires a Mapbox token (`MAPBOX_PUBLIC_TOKEN` env var) for map features
- Current active branch `FEATURE/theme-testing` focuses on theme/styling refinements
- Templates use `.tpl` extension and are processed by project scaffolding functions
