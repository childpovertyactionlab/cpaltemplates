# cpaltemplates 2.0.0

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
