---

# cpaltemplates 2.6.0 (2026-01-08)
## Thematic Package Compatibility for Dark Mode Support

### New Features

* **`theme_cpal_auto()`**: New theme function designed for use with the `thematic` package. Applies CPAL styling for fonts, sizes, and spacing while allowing thematic to control background and text colors for automatic light/dark mode support in Shiny apps.

* **`thematic` parameter for `theme_cpal()`**: Added new `thematic = FALSE` parameter. When set to `TRUE`, color-related theme elements are set to `NA` to allow the thematic package to inherit and control them based on the app's CSS.

* **`set_theme_cpal("auto")`**: The `set_theme_cpal()` function now accepts `"auto"` as a style option to set the thematic-compatible theme as default.

### Usage Example

```r
library(shiny)
library(thematic)
library(cpaltemplates)

server <- function(input, output, session) {
thematic::thematic_on()

output$my_plot <- renderPlot({
  ggplot(data, aes(x, y)) +
    geom_point() +
    scale_color_cpal_d() +
    theme_cpal_auto()
})
}
```

### Technical Details

When `thematic = TRUE` or using `theme_cpal_auto()`:
- Background fills (`panel.background`, `plot.background`, `strip.background`) are set to `NA`
- Text colors (title, subtitle, caption, axis text, legend text) are set to `NA`
- Grid and axis line colors are set to `NA`
- This allows the thematic package to control these colors based on the Shiny app's light/dark mode CSS

CPAL data color scales (`scale_color_cpal_d()`, `scale_fill_cpal_d()`, etc.) continue to use CPAL brand colors regardless of dark mode setting.

---

# cpaltemplates 2.5.0 (2026-01-07)

## Major Release - New Color System & Shiny Dashboard Enhancements

### 🎨 New Color System

Complete overhaul of the CPAL color palette system:

#### Core Brand Colors (6 colors)
* **midnight** (#004855) - Dark backgrounds, headers, primary emphasis
* **deep_teal** (#006878) - Primary brand color, links, info states
* **coral** (#E86A50) - Accents, alerts, negative/error states
* **sage** (#5A8A6F) - Success states, positive indicators
* **slate** (#5C6B73) - Secondary text, borders, muted elements
* **warm_gray** (#9BA8AB) - Neutral backgrounds, disabled states

#### New Palette Types
* **Categorical**: `main` (8 colors), `main_3`, `main_4`, `main_5`, `main_6`, `binary`, `status`
* **Sequential**: `midnight_seq_4`, `midnight_seq_5`, `midnight_seq_6`, `midnight_seq_8`
* **Diverging**: `coral_midnight_3`, `coral_midnight_5`, `coral_midnight_7`, `coral_midnight_9`

#### Legacy Support
* Old palette names (`teal_seq_*`, `pink_teal_*`) aliased to new palettes for backward compatibility

### 🖥️ Shiny Dashboard Improvements

* **Brand.yml Integration**: Dashboard themes now fully powered by `_brand.yml` configuration
* **Dark/Light Mode**: Fixed dark mode styling and theme switching
* **Alert Styles**: Improved alert border styles and color consistency
* **Table Styling**: Enhanced table appearance in dashboards
* **Modular UI Structure**: Refactored demo app with modular view components
* **Bootstrap 5 Theming**: `cpal_dashboard_theme()` now recommended over deprecated `cpal_shiny()`

### 📖 Documentation

* Complete Quarto documentation site rebuild
* Updated all examples to use new color system
* Fixed multi-plot rendering in documentation
* Added comprehensive color palette reference tables
* GitHub Pages deployment fix (output directly to docs/)

### 🔧 Technical Changes

* Refactored R functions into modular files (colors.R, themes.R, tables.R, utils.R, etc.)
* Updated `validate_cpal_brand()` for new color requirements
* Package passes `devtools::check()` with 0 errors, 0 warnings, 0 notes

---

# cpaltemplates 2.0.1 (2025-10-09)

### Bug Fixes
* Adjusted tex file templates to contain correct file paths.
* Created new quarto report template file with updated yaml
* Updated theme_cpal() ggplot2 theme for appropriate quarto rendering

---

## Major Release - Complete Package Overhaul

### 🎉 New Features

#### Visualization System
* **Five complete themes**: `theme_cpal()`, `theme_cpal_classic()`, `theme_cpal_minimal()`, `theme_cpal_dark()`, `theme_cpal_map()`, `theme_cpal_print()`
* **Interactive visualizations**: Full ggiraph integration with `cpal_interactive()` and geometric layers
* **Mapping support**: New `cpal_mapgl()` and `cpal_mapgl_layer()` functions for interactive maps
* **Accessibility checking**: `check_plot_accessibility()` ensures WCAG compliance

#### Table Systems
* **GT tables**: `cpal_table_gt()` with CPAL styling and highlighting
* **Reactable tables**: `cpal_table_reactable()` for interactive data exploration
* **Unified wrapper**: `cpal_table()` for simplified table creation

#### Project Templates
* **Comprehensive scaffolding**: `start_project()` with multiple project types
* **Quarto integration**: `use_quarto_report()`, `use_quarto_slides()`, `use_quarto_web()`
* **Shiny templates**: `use_shiny_app()` and `use_shiny_dashboard()` with CPAL theming
* **Targets workflow**: `use_targets()` for reproducible pipelines

#### Color System
* **Extended palettes**: Sequential, diverging, and categorical color schemes
* **Color scales**: `scale_color_cpal()`, `scale_fill_cpal()` with continuous variants
* **Palette viewer**: `view_cpal_palettes()` and `list_cpal_palettes()`

### 🔧 Improvements

* **Font management**: Google Fonts integration with `setup_cpal_google_fonts()`
* **Asset management**: Centralized asset system with `get_cpal_asset()` and `update_cpal_assets()`
* **Logo integration**: `add_cpal_logo()` for consistent branding
* **Export utilities**: `save_cpal_plot()` with optimized settings

### 🐛 Bug Fixes

* Fixed all R CMD check errors, warnings, and notes
* Resolved function naming conflicts
* Corrected parameter documentation mismatches
* Added all required imports and dependencies

### 📚 Documentation

* Comprehensive README with examples
* Full roxygen2 documentation for all functions
* Usage examples in function documentation
* Best practices and guidelines

### 💥 Breaking Changes

* Minimum R version now 4.3.0
* Function `cpal_gt()` renamed to `cpal_table_gt()` (alias provided)
* `use_shiny_theme()` in themes.R renamed to `get_shiny_theme_colors()`
* Some internal functions no longer exported

---

# cpaltemplates 1.9.0 (2024-08-05)

### Bug Fixes
* Resolved R CMD check issues
* Corrected Rd documentation mismatches

---

# cpaltemplates 1.0.0 (2024-01-15)

### Initial Release
* Core theme functions
* Basic color palettes
* Initial project templates
* Basic utility functions
