# cpaltemplates

**Standardized templates and visualizations for the CPAL data team**

An R package designed to streamline CPAL data team workflows through consistent templates, branded visualizations, and automated project setup.

## 📦 Package Status

**Current Version:** Development  
**Last Updated:** July 25, 2025  
**Test Status:** ✅ All tests passing (19/19)  
**Build Status:** ✅ Ready for internal use  

## 🎯 Package Overview

### Core Functionality 
- **8 Major Systems Complete**: Colors, themes, interactive plots, project scaffolding, utilities, fonts, assets, and table formatting
- **Template System**: Automated project creation with CPAL standards
- **Brand Consistency**: CPAL colors, fonts, and styling across all outputs
- **Cross-platform**: Works on Windows, Mac, and Linux

### Key Features
- **Standardized Color Palettes**: CPAL-branded categorical, sequential, and diverging palettes
- **Professional Themes**: Multiple ggplot2 themes (default, dark, minimal, classic, print, map)
- **Interactive Visualizations**: ggiraph integration with consistent CPAL styling
- **Project Templates**: Automated setup for analyses, Shiny apps, Quarto reports/slides
- **Table Formatting**: gt-based tables with CPAL branding
- **Asset Management**: Logos, fonts, and visual assets handling

## 🔧 Installation

```r
# Install from local development
devtools::install_local("path/to/cpaltemplates")

# Or if developing
devtools::load_all(".")
```

## 🚀 Quick Start

```r
library(cpaltemplates)

# Set CPAL theme as default
set_theme_cpal()

# Create a plot with CPAL styling
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_cpal("categorical") +
  labs(title = "Motor Trend Car Road Tests",
       subtitle = "Weight vs MPG by Cylinder Count")

# Start a new CPAL project
start_project("my_analysis", "analysis")

# Create a CPAL-styled table
cpal_table(head(mtcars), title = "Motor Trend Data")
```

## 📊 Available Functions

### Theme Functions
- `theme_cpal()` - Main CPAL theme with style options (default, minimal, classic, dark)
- `theme_cpal_dark()` - Dark theme variant
- `theme_cpal_minimal()` - Minimal styling
- `theme_cpal_classic()` - Traditional academic style
- `theme_cpal_print()` - Print-optimized
- `theme_cpal_map()` - Geographic visualization
- `set_theme_cpal()` - Set as session default

### Color System
- `cpal_colors()` - Access CPAL color palette
- `scale_color_cpal()` / `scale_fill_cpal()` - ggplot2 color scales
- `scale_*_cpal_c()` - Continuous color scales
- `cpal_palette()` - Generate color vectors
- `view_palette()` / `view_all_palettes()` - Preview colors

### Interactive Visualizations
- `cpal_interactive()` - Convert ggplot to interactive
- `cpal_*_interactive()` - Specific geom variants (point, line, column, polygon)
- `cpal_mapgl()` - Interactive mapping

### Project Setup
- `start_project()` - Create new CPAL project
- `setup_*()` - Individual component setup (git, renv, quarto, etc.)
- `use_*()` - Add features to existing projects

### Tables and Output
- `cpal_table()` - Styled gt tables
- `save_cpal_plot()` - Standardized plot export
- `check_plot_accessibility()` - Verify color accessibility

### Font and Asset Management
- `setup_cpal_google_fonts()` - Install Google Fonts
- `get_cpal_font_family()` - Font selection logic
- `get_cpal_asset()` - Access package assets

## 🎨 Color Palettes

### Primary Colors
- **Midnight**: #004855 (Primary brand color)
- **Coral**: #FF6B35 (Secondary accent)
- **Sky**: #0FA3B1 (Supporting blue)
- **Sage**: #9BC53D (Supporting green)

### Available Palettes
- **Categorical**: Multi-color discrete palettes
- **Sequential**: Single-hue progression (teal, coral, neutral)
- **Diverging**: Two-hue contrast palettes

All palettes are designed with accessibility in mind and include colorblind-safe options.

## 📁 Project Templates

### Available Templates
- `"analysis"` - Standard data analysis project
- `"quarto_report"` - Quarto document with CPAL styling
- `"quarto_slides"` - CPAL presentation template
- `"quarto_web"` - Multi-page Quarto website
- `"shiny_app"` - Basic Shiny application
- `"shiny_dashboard"` - Comprehensive dashboard
- `"package"` - R package development setup

### Template Features
- Automated directory structure
- CPAL-branded styling files
- Pre-configured renv environment
- Git repository initialization
- Standard README and documentation

## ✅ Task Management & Development

### Recently Completed ✅
- **Font Functions Fix** - Added missing `cpal_font_family()` and `cpal_font_family_fallback()` functions to resolve test failures
- **Deprecation Warning Fix** - Updated ggplot2 `element_line()` calls from `size` to `linewidth` parameter
- **Test Suite Passing** - All 19 tests now pass without warnings

### In Progress 🔄
- **Comprehensive Testing** - Expanding test coverage for all major functions
- **Function Documentation** - Adding detailed roxygen2 documentation

### Pending 📋
- **Logo Functions** - Implement missing logo functions referenced in documentation
- **Template File Validation** - Ensure all template files referenced in `start_project()` exist
- **Vignette Creation** - Comprehensive usage examples
- **Performance Optimization** - Theme rendering and file operations
- **Accessibility Testing** - Verify all color palettes meet standards
- **Cross-platform Testing** - Font handling across operating systems

## 🧪 Testing

```r
# Run all tests
devtools::test()

# Check package structure
devtools::check()

# Test specific functionality
devtools::test_file("tests/testthat/test-theme_cpal.R")
```

**Current Test Status**: 19 tests passing, 0 failures, 0 warnings

## 🔍 Quality Assurance Checklist

Before making changes, always verify:
- [ ] Does this maintain CPAL brand consistency?
- [ ] Will this work across all supported platforms?
- [ ] Are error messages helpful for troubleshooting?
- [ ] Does the README accurately reflect function capabilities?
- [ ] Have I tested with both required and optional dependencies?

## 🚨 Development Notes

### Critical Dependencies
- **Required**: ggplot2, cli, fs, dplyr
- **Optional**: ggiraph, reactable, mapgl, gt, cowplot, magick, sysfonts, showtext

### Known Issues
- Some template files may need validation
- Logo functions need implementation
- Performance optimization needed for complex themes

### Anti-patterns to Avoid
- Never promise functions in README without implementation
- Always test template file references with `system.file()`
- Maintain dependency isolation - optional packages should gracefully degrade
- Document parameter interdependencies

## 📚 Documentation Standards

All functions must include:
- Clear purpose and scope description
- Parameter definitions with types and defaults
- Return value specification
- Usage examples (when appropriate)
- Export status (@export for user-facing functions)

## 🔗 Related Resources

- [CPAL Brand Guidelines](internal-link)
- [R Package Development Best Practices](https://r-pkgs.org/)
- [ggplot2 Documentation](https://ggplot2.tidyverse.org/)

---

## 📝 Changelog

### 2025-07-25
- **FIXED**: Missing font functions (`cpal_font_family()`, `cpal_font_family_fallback()`)
- **FIXED**: ggplot2 deprecation warnings (size → linewidth)
- **ADDED**: Comprehensive task management system
- **STATUS**: All tests passing (19/19)

### Previous Changes
- Initial package structure with 8 major systems
- Color palette implementation
- Theme system development
- Interactive visualization features
- Project template system

---

*This README serves as the central hub for all cpaltemplates development. Always update this file when making changes to functions, adding features, or resolving issues.*
