# cpaltemplates Function Reference

Complete reference for all exported functions in cpaltemplates v2.7.0.

---

## Table of Contents

- [Color System](#color-system)
- [Theme System](#theme-system)
- [Table Functions](#table-functions)
- [Highcharter Functions](#highcharter-functions)
- [Mapping Functions](#mapping-functions)
- [Project Scaffolding](#project-scaffolding)
- [Brand & Asset Management](#brand--asset-management)
- [Utility Functions](#utility-functions)

---

## Color System

### Core Color Functions

#### `cpal_colors(palette, n, reverse)`
Main entry point for accessing CPAL color palettes.

| Argument | Description |
|----------|-------------|
| `palette` | Name of palette ("primary", "main", "teal_seq_5", etc.) or specific color names |
| `n` | Number of colors to return (optional) |
| `reverse` | Logical, reverse palette order |

```r
cpal_colors()                    # Primary brand colors
cpal_colors("teal")              # Single color by name
cpal_colors("main", n = 3)       # First 3 colors from main palette
cpal_colors("teal_seq_5")        # Sequential palette
```

---

#### `cpal_colors_primary()`
Returns the 6 core CPAL brand colors: midnight, deep_teal, coral, sage, slate, warm_gray.

---

#### `cpal_colors_extended()`
Returns all 17 colors including primary colors and shades.

---

#### `cpal_get_color(palette_color_name)`
Get a single color by its exact name from `_brand.yml` (e.g., "teal_light", "pink_muted").

---

#### `cpal_get_primary_color()`
Returns the primary brand color (deep_teal): `#006878`

---

#### `cpal_palette(palette, reverse)`
Internal wrapper around `cpal_colors()` for use in scale functions. Returns unnamed vector.

---

### Unified Palette Access

#### `cpal_palettes(name, type)`
Unified accessor for all CPAL color palettes.

| Argument | Description |
|----------|-------------|
| `name` | Specific palette name (returns that palette's colors) |
| `type` | Filter: "all", "sequential", "diverging", "categorical" |

```r
cpal_palettes()                     # All palettes organized by type
cpal_palettes(type = "sequential")  # Only sequential palettes
cpal_palettes("teal_seq_5")         # Get specific palette by name
```

---

#### `cpal_palettes_sequential()`
Returns list of sequential palettes for continuous data:
- `midnight_seq_5`, `midnight_seq_8` - Single-hue midnight
- `coral_seq_5`, `coral_seq_8` - Single-hue coral
- `sage_seq_5`, `sage_seq_8` - Single-hue sage

---

#### `cpal_palettes_diverging()`
Returns list of diverging palettes:
- `coral_midnight_3`, `coral_midnight_5`, `coral_midnight_7`, `coral_midnight_9`
- `sage_coral_3`, `sage_coral_5`, `sage_coral_7`, `sage_coral_9`
- Legacy aliases: `pink_teal_3`, `pink_teal_6`

---

#### `cpal_palettes_categorical()`
Returns list of categorical palettes:
- `main` (8 colors) - use `cpal_colors("main", n = 3)` to subset
- `blues`, `compare`, `binary`, `status`

---

#### `list_cpal_palettes(details)`
List all available palette names. Set `details = TRUE` for descriptions.

---

#### `view_cpal_palettes(palette, show_hex, show_names, compact)`
Visual display of color palettes. Use `palette = "all"` for overview.

---

#### `quick_palette(palette, n_colors)`
Simple, quick console preview of any palette.

---

### Color Validation

#### `validate_color_contrast(foreground, background, level, large_text)`
Check if two colors meet WCAG contrast requirements.

| Argument | Description |
|----------|-------------|
| `foreground` | Hex color for foreground (text/element) |
| `background` | Hex color for background |
| `level` | "AA" (4.5:1) or "AAA" (7:1) |
| `large_text` | If TRUE, uses relaxed thresholds |

```r
validate_color_contrast("#006878", "#FFFFFF")           # Check AA
validate_color_contrast("#004855", "#FFFFFF", "AAA")    # Check AAA
```

---

#### `validate_brand_colors(level, verbose)`
Check all CPAL palette colors for accessibility on white and dark backgrounds.

```r
validate_brand_colors()             # Check against AA standard
validate_brand_colors("AAA")        # Check against stricter AAA
```

---

### Color Interpolation

#### `cpal_color_ramp(from, to, n, include_ends)`
Generate smooth gradient between two colors.

```r
cpal_color_ramp("coral", "midnight", n = 5)
cpal_color_ramp("midnight_1", "midnight", n = 10)
cpal_color_ramp("#FFFFFF", "#004855", n = 7)
```

---

#### `cpal_color_gradient(colors, n)`
Create gradient through multiple colors.

```r
cpal_color_gradient(c("coral", "neutral", "midnight"), n = 9)
cpal_color_gradient(c("midnight_1", "deep_teal", "midnight"), n = 12)
```

---

### ggplot2 Scale Functions

#### `scale_color_cpal()` / `scale_fill_cpal()`
Add CPAL colors to ggplot2 plots.

| Argument | Description |
|----------|-------------|
| `palette` | Palette name |
| `discrete` | TRUE for categorical, FALSE for continuous |
| `reverse` | Reverse palette order |

```r
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_cpal("main")
```

---

#### `scale_color_cpal_c()` / `scale_fill_cpal_c()`
Continuous color scales (gradients).

---

#### `scale_color_cpal_d()` / `scale_fill_cpal_d()`
Discrete/manual color scales.

---

#### `scale_colour_cpal()`
British spelling alias for `scale_color_cpal()`.

---

## Theme System

### ggplot2 Themes

#### `theme_cpal(base_size, base_family, style, grid, axis_line, axis_title, legend_position)`
Main CPAL ggplot2 theme.

| Argument | Options |
|----------|---------|
| `base_size` | Base font size (default: 16) |
| `style` | "default", "minimal", "classic", "dark" |
| `grid` | "horizontal", "vertical", "both", "none" |
| `axis_line` | "x", "y", "both", "none" |
| `legend_position` | "bottom", "right", "top", "left", "none" |

```r
ggplot(data, aes(x, y)) +
  geom_point() +
  theme_cpal(style = "minimal", grid = "both")
```

---

#### `theme_cpal_minimal()`
Minimal variant with reduced visual elements.

---

#### `theme_cpal_classic()`
Traditional styling with axis lines.

---

#### `theme_cpal_dark()`
Dark variant optimized for dark backgrounds.

---

#### `theme_cpal_print()`
Optimized for printing (high contrast, white background).

---

#### `theme_cpal_map()`
Specialized theme for geographic visualizations (no axes, minimal chrome).

---

#### `set_theme_cpal(style, base_size, ...)`
Set CPAL theme as default for the R session.

```r
set_theme_cpal("dark")  # All subsequent plots use dark theme
```

---

#### `preview_cpal_themes(data, save_path, width, height)`
Visual comparison of all 6 CPAL theme variants side-by-side.

```r
preview_cpal_themes()                                    # Display preview
preview_cpal_themes(save_path = "theme_comparison.png")  # Save to file
```

---

### Shiny/Dashboard Themes

#### `cpal_dashboard_theme()` *[RECOMMENDED]*
Creates Bootstrap 5 theme using `_brand.yml` configuration.

```r
ui <- page_sidebar(
  theme = cpal_dashboard_theme(),
  title = "Dashboard",
  ...
)
```

---

#### `cpal_shiny(variant, custom_colors, font_scale, enable_animations)` *[DEPRECATED]*
Legacy Shiny theme function. Use `cpal_dashboard_theme()` instead.

---

#### `cpal_add_scss_enhancements(base_theme, ...)`
Add enhanced SCSS styling (geometric headers, datatable enhancements, metric cards) to a base theme.

---

#### `cpal_export_scss(path, overwrite)`
Export enhanced SCSS file for Quarto or custom use.

---

## Table Functions

#### `cpal_table(data, title, subtitle, font_family, ...)`
Create gt table with CPAL styling.

---

#### `cpal_table_gt(data, title, subtitle, source)`
Publication-quality static table using gt.

---

#### `cpal_table_reactable(data, title, subtitle, source, ...)`
Interactive table using reactable.

| Argument | Description |
|----------|-------------|
| `searchable` | Enable search (default: TRUE) |
| `pagination` | Enable pagination (default: TRUE) |
| `page_size` | Rows per page (default: 10) |
| `filterable` | Per-column filtering (default: FALSE) |
| `highlight_columns` | Columns for special highlighting |
| `bold_rows` | Column with 1/0 for row highlighting |
| `data_bar_columns` | Columns to show as data bars |

---

## Highcharter Functions

### Core Theme Functions

#### `hc_theme_cpal_light(base_size, grid, legend_position, show_credits)`
Light mode Highcharter theme matching `theme_cpal()`.

| Argument | Options |
|----------|---------|
| `base_size` | Base font size in pixels (default: 14) |
| `grid` | "horizontal", "vertical", "both", "none" |
| `legend_position` | "bottom", "right", "top", "left" |
| `show_credits` | Show Highcharts watermark (default: FALSE) |

```r
hchart(mtcars, "scatter", hcaes(wt, mpg)) |>
  hc_add_theme(hc_theme_cpal_light())
```

---

#### `hc_theme_cpal_dark(base_size, grid, legend_position, show_credits)`
Dark mode Highcharter theme matching `theme_cpal_dark()`.

---

#### `hc_theme_cpal_switch(mode, ...)`
Returns appropriate theme based on mode ("light" or "dark"). Useful for Shiny dark mode toggles.

```r
output$chart <- renderHighchart({
  hchart(data, "column", hcaes(x, y)) |>
    hc_add_theme(hc_theme_cpal_switch(input$dark_mode))
})
```

---

#### `hc_cpal_theme(hc, mode, ...)`
Convenience function that applies CPAL theme and sets number formatting in one call.

```r
hchart(data, "bar", hcaes(x, y)) |>
  hc_cpal_theme()        # Light mode

hchart(data, "bar", hcaes(x, y)) |>
  hc_cpal_theme("dark")  # Dark mode
```

---

### Color Functions

#### `hc_colors_cpal(hc, palette, n, reverse)`
Apply CPAL color palettes to a Highcharter chart.

| Argument | Options |
|----------|---------|
| `palette` | "main", "categorical", "sequential", "seq", "diverging", "div" |
| `n` | Number of colors to use (optional) |
| `reverse` | Reverse palette order (default: FALSE) |

```r
hchart(data, "bar", hcaes(x = category, y = value, group = series)) |>
  hc_colors_cpal("main")
```

---

#### `hc_colorAxis_cpal(hc, palette, min, max, reverse, stops)`
Configure color axis for heatmaps and choropleths.

| Argument | Description |
|----------|-------------|
| `palette` | "sequential" or "diverging" |
| `min`, `max` | Value range for color scale |
| `reverse` | Reverse color direction |
| `stops` | Number of color stops |

```r
# Sequential for heatmaps
hchart(data, "heatmap", hcaes(x, y, value = z)) |>
  hc_colorAxis_cpal("sequential", min = 0, max = 100)

# Diverging for correlations
hchart(cor_data, "heatmap", hcaes(x, y, value = correlation)) |>
  hc_colorAxis_cpal("diverging", min = -1, max = 1)
```

---

### Formatting Helpers

#### `hc_cpal_number_format(hc)`
Set US number formatting globally (commas for thousands). Call once per session or in pipe.

```r
hc_cpal_number_format()  # Set globally

# Or in pipe
hchart(data, "bar", hcaes(x, y)) |>
  hc_cpal_number_format()
```

---

#### `hc_tooltip_cpal(hc, decimals, prefix, suffix, point_format)`
Configure tooltip formatting with decimal control.

| Argument | Description |
|----------|-------------|
| `decimals` | Number of decimal places (default: 0) |
| `prefix` | Text before value, e.g., "$" |
| `suffix` | Text after value, e.g., "%" or " people" |
| `point_format` | Custom format string (overrides other options) |

```r
# Population
hchart(data, "bar", hcaes(x, y)) |>
  hc_tooltip_cpal(decimals = 0, suffix = " people")

# Currency
hchart(data, "bar", hcaes(x, y)) |>
  hc_tooltip_cpal(decimals = 2, prefix = "$")
```

---

#### `hc_yaxis_cpal(hc, title, decimals, prefix, suffix, divide_by, ...)`
Configure y-axis label formatting.

| Argument | Description |
|----------|-------------|
| `title` | Y-axis title |
| `decimals` | Decimal places in labels |
| `prefix` | Text before values, e.g., "$" |
| `suffix` | Text after values, e.g., "%" |
| `divide_by` | Divide values for display, e.g., 1000000 for millions |

```r
# Percentage axis
hchart(data, "bar", hcaes(x, y)) |>
  hc_yaxis_cpal(title = "Poverty Rate", decimals = 1, suffix = "%")

# Population in millions
hchart(data, "bar", hcaes(x, y)) |>
  hc_yaxis_cpal(title = "Population", suffix = "M", divide_by = 1000000)
```

---

#### `hc_linetype_cpal(hc, curved)`
Switch between straight lines and smooth splines for line charts.

```r
hchart(data, "line", hcaes(x, y)) |>
  hc_linetype_cpal(curved = TRUE)   # Smooth spline

hchart(data, "line", hcaes(x, y)) |>
  hc_linetype_cpal(curved = FALSE)  # Straight lines
```

---

### Logo Functions

#### `hc_add_cpal_logo(hc, logo_url, mode, position, width, height, opacity, margin)`
Add CPAL logo watermark to chart.

| Argument | Options |
|----------|---------|
| `mode` | "light" (teal logo) or "dark" (white logo) |
| `position` | "top-right", "top-left", "bottom-right", "bottom-left" |
| `width` | Logo width in pixels (default: 60) |
| `opacity` | Logo opacity 0-1 (default: 0.5) |

```r
# Light mode (teal logo)
hchart(data, "bar", hcaes(x, y)) |>
  hc_add_theme(hc_theme_cpal_light()) |>
  hc_add_cpal_logo()

# Dark mode (white logo)
hchart(data, "bar", hcaes(x, y)) |>
  hc_add_theme(hc_theme_cpal_dark()) |>
  hc_add_cpal_logo(mode = "dark")
```

---

### Chart Helper Functions

#### `hc_histogram_cpal(data, breaks, name, color, title, subtitle, x_title, y_title)`
Create a CPAL-styled histogram from raw data.

```r
hc_histogram_cpal(mtcars$mpg, breaks = 15, title = "MPG Distribution")
```

---

#### `hc_lollipop_cpal(categories, values, name, stem_color, dot_color, horizontal, title, ...)`
Create a lollipop chart (stem + dot).

```r
hc_lollipop_cpal(
  categories = c("A", "B", "C"),
  values = c(10, 20, 15),
  title = "Rankings"
)
```

---

#### `hc_dumbbell_cpal(categories, values_start, values_end, name_start, name_end, horizontal, title, ...)`
Create a dumbbell chart showing gaps between two values.

```r
hc_dumbbell_cpal(
  categories = c("Region A", "Region B", "Region C"),
  values_start = c(10, 20, 15),
  values_end = c(15, 25, 12),
  name_start = "2020",
  name_end = "2024",
  title = "Change Over Time"
)
```

---

## Mapping Functions

#### `cpal_mapgl(style, bounds, ...)`
Create mapgl map with Dallas area defaults.

```r
map <- cpal_mapgl(
  style = "mapbox://styles/mapbox/light-v11",
  bounds = list(west = -97.0, east = -96.5, south = 32.5, north = 33.0)
)
```

---

#### `cpal_mapgl_layer(map, id, source, type, paint, ...)`
Add CPAL-styled layer to mapgl map.

| Argument | Description |
|----------|-------------|
| `type` | "fill", "line", or "circle" |
| `paint` | Paint properties (uses CPAL defaults if NULL) |

```r
map |>
  cpal_mapgl_layer(
    id = "my_layer",
    source = geojson_data,
    type = "fill"
  )
```

---

## Project Scaffolding

#### `start_project(name, path, project_type, interactive, features, open, overwrite)`
Create new project with CPAL structure and templates.

| Argument | Options |
|----------|---------|
| `project_type` | "analysis", "quarto-report", "quarto-slides", "quarto-web", "shiny-dashboard", "shiny-app", "package" |
| `features` | Vector of: "renv", "git", "github", "targets", "tests" |
| `interactive` | Guide user through setup (default: TRUE) |

```r
start_project("my-analysis", project_type = "analysis", features = c("git", "renv"))
```

---

#### `use_quarto_report(path, overwrite)`
Add Quarto report templates to existing project.

---

#### `use_quarto_slides(path, filename, overwrite)`
Add Quarto slides template to existing project.

---

#### `use_quarto_web(path, overwrite)`
Add Quarto website structure to existing project.

---

#### `use_shiny_dashboard(path, overwrite)`
Add full-featured Shiny dashboard to existing project.

---

#### `use_shiny_app(path, overwrite)`
Add simple Shiny app to existing project.

---

#### `use_shiny_theme(path, theme_name, overwrite)`
Add CPAL CSS theme files for Shiny.

---

#### `use_targets(path, type, overwrite)`
Add targets pipeline to existing project. Types: "basic", "analysis", "report".

---

#### `update_cpal_assets(path, components)`
Update CSS and images to latest package versions.

---

## Brand & Asset Management

#### `use_cpal_brand(path, overwrite)`
Copy `_brand.yml` to a project for local customization.

```r
use_cpal_brand()                    # Copy to current directory
use_cpal_brand("my-app/")           # Copy to specific directory
use_cpal_brand(overwrite = TRUE)    # Force overwrite
```

---

#### `validate_cpal_brand(path, verbose)`
Validate that a `_brand.yml` file has all required fields and valid hex colors.

```r
validate_cpal_brand()                      # Validate in current directory
validate_cpal_brand("path/to/_brand.yml")  # Validate specific file
```

---

#### `get_cpal_asset(asset_name, category)`
Get path to package asset (logo, icon, favicon).

| Category | Available Assets |
|----------|-----------------|
| `logos` | CPAL_Logo_Teal.png, CPAL_Logo_White.png, cpal-logo-wide.png |
| `icons` | CPAL_Icon_Teal.png, CPAL_Icon_White.png, CPAL_Skyline_*.png |
| `favicons` | CPAL_favicon.ico, cpal-favicon.ico |

```r
logo_path <- get_cpal_asset("CPAL_Logo_Teal.png", "logos")
icon_path <- get_cpal_asset("CPAL_Icon_White.png", "icons")
```

---

## Utility Functions

### Font Management

#### `cpal_font_family(type, setup)`
Unified font family accessor. Returns best available CPAL font.

| Argument | Options |
|----------|---------|
| `type` | "plot" (default), "table", "print" |
| `setup` | If TRUE, attempts to set up fonts if not available |

```r
cpal_font_family()                  # Get font for regular plots
cpal_font_family(setup = TRUE)      # Set up fonts if missing
```

---

#### `cpal_font_family_fallback()`
Returns system font fallback ("sans").

---

#### `setup_cpal_google_fonts(force_refresh, verbose)`
Download and register Inter/Roboto fonts from Google Fonts for plots.

---

### Plot Utilities

#### `save_cpal_plot(plot, filename, size, dpi, bg, ...)`
Save plots with standard CPAL dimensions.

| Size Preset | Dimensions (inches) |
|-------------|-------------------|
| `default` | 8 x 5 |
| `slide` | 10 x 5.625 (16:9) |
| `half` | 4 x 3 |
| `third` | 2.5 x 2 |
| `square` | 5 x 5 |
| `wide` | 12 x 4 |
| `tall` | 5 x 8 |

```r
save_cpal_plot(p, "output.png", size = "slide")
save_cpal_plot(p, "custom.png", size = c(10, 6))  # Custom dimensions
```

---

#### `add_cpal_logo(plot, position, size, logo_path)`
Add CPAL logo to ggplot. Auto-detects dark theme and uses appropriate logo color.

| Argument | Options |
|----------|---------|
| `position` | "top-right", "top-left", "bottom-right", "bottom-left" |
| `size` | Proportion of plot (default: 0.09) |

---

#### `check_plot_accessibility(plot, verbose)`
Check plot for accessibility issues (text size, colorblind safety of colors used).

---

## Quick Reference by Use Case

### Creating a new project
```r
start_project("my-analysis", project_type = "analysis")
```

### Making a branded plot
```r
ggplot(data, aes(x, y, color = group)) +
  geom_point() +
  scale_color_cpal("main") +
  theme_cpal()
```

### Creating a Shiny dashboard
```r
ui <- page_sidebar(
  theme = cpal_dashboard_theme(),
  ...
)
```

### Getting brand colors
```r
cpal_colors("coral")          # Single color
cpal_colors_primary()         # All 6 primary colors
cpal_palettes("main")         # Categorical palette
```

### Checking accessibility
```r
validate_brand_colors()                              # All colors
validate_color_contrast("#006878", "#FFFFFF")        # Specific pair
```

### Creating custom color gradients
```r
cpal_color_ramp("coral", "midnight", n = 7)
cpal_color_gradient(c("midnight_1", "deep_teal", "midnight"), n = 10)
```

### Creating interactive Highcharter charts
```r
library(highcharter)

# Basic themed chart
hchart(data, "column", hcaes(x = category, y = value)) |>
  hc_cpal_theme() |>
  hc_tooltip_cpal(decimals = 0) |>
  hc_add_cpal_logo()

# With dark mode in Shiny
hchart(data, "line", hcaes(x, y)) |>
  hc_cpal_theme(input$dark_mode)
```
