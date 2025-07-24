# cpaltemplates

> **R package for standardizing CPAL data team workflows**

An R package that provides templates, themes, color palettes, and project scaffolding tools to standardize data visualization and analysis workflows for the Child Poverty Action Lab (CPAL) data team.

## 📋 Current Development Status

**Package State**: Substantially complete with 8 major function systems across 6 R files  
**Total Functions**: 40+ functions implemented  
**Last Review**: January 2025  

### ✅ Completed Systems

- **🎨 Color System** (`cpal_colors.R`) - Complete with 16 color palettes (sequential, diverging, categorical)
- **🖼️ Theme System** (`theme_cpal.R`) - 7 theme variants (default, minimal, dark, classic, print, map)
- **⚡ Interactive Features** (`cpal_interactive.R`) - ggiraph, mapgl, and reactable integration
- **📊 Plot Utilities** (`cpal_plots.R`) - Save functions, accessibility checking, formatted tables
- **🏗️ Project Scaffolding** (`start_project.R`) - Complete project template system (6 project types)
- **🔧 Utility Functions** (`utils.R`) - Template addition helpers for existing projects

### 🚧 Active Development Tasks

- [ ] **Logo Functions** - Implement missing `add_cpal_logo()` function referenced in documentation
- [ ] **Template Validation** - Verify all template files exist in `inst/` directory structure
- [ ] **Testing Framework** - Create comprehensive testthat suite for all functions
- [ ] **Documentation** - Complete roxygen2 documentation for all functions
- [ ] **Font Optimization** - Improve cross-platform font handling
- [ ] **Accessibility Testing** - Validate colorblind-safe palettes
- [ ] **GitHub Pages Setup** - Deploy QMD documentation as website

## 🚀 Quick Start

```r
# Install from GitHub (when available)
# remotes::install_github("cpal/cpaltemplates")

# Load and set up
library(cpaltemplates)
import_inter_font()        # Import CPAL brand fonts
set_theme_cpal()          # Set as default theme

# Create a CPAL-styled plot
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_cpal(palette = "main") +
  labs(title = "CPAL Styled Visualization")
```

## 📦 Function Inventory

### Color System (`cpal_colors.R`)
- `cpal_colors()` - Access CPAL color palettes  
- `cpal_colors_primary` - Brand color constants
- `cpal_colors_extended` - Extended color palette  
- `cpal_palettes_sequential` - Sequential palettes (7 variants)
- `cpal_palettes_diverging` - Diverging palettes (3 variants)  
- `cpal_palettes_categorical` - Categorical palettes (6 variants)
- `scale_color_cpal()`, `scale_fill_cpal()` - ggplot2 color scales
- `view_palette()`, `view_all_palettes()` - Palette visualization
- `cpal_display_palettes()` - Interactive palette display

### Theme System (`theme_cpal.R`)  
- `theme_cpal()` - Main CPAL theme with customization options
- `theme_cpal_minimal()`, `theme_cpal_dark()`, `theme_cpal_classic()` - Theme variants
- `theme_cpal_print()` - Print-optimized theme
- `theme_cpal_map()` - Map visualization theme  
- `import_inter_font()` - Google Fonts integration
- `cpal_font_family()` - Cross-platform font detection
- `set_theme_cpal()` - Set as default theme

### Interactive Features (`cpal_interactive.R`)
- `cpal_interactive()` - ggiraph wrapper with CPAL styling
- `cpal_point_interactive()`, `cpal_col_interactive()`, `cpal_line_interactive()` - Interactive geoms
- `cpal_mapgl()` - Mapbox GL integration  
- `cpal_table_interactive()` - Styled reactable tables

### Plot Utilities (`cpal_plots.R`)
- `save_cpal_plot()` - Save plots with standard CPAL dimensions
- `cpal_table()` - gt table with CPAL styling
- `check_plot_accessibility()` - Accessibility validation
- `add_cpal_logo()` - ⚠️ **Missing Implementation**

### Project Creation (`start_project.R`)
- `start_project()` - Interactive project creation wizard
- **Project Types**: analysis, quarto-report, quarto-slides, shiny-dashboard, shiny-app, package
- **Features**: renv, git, github, targets, tests

### Utility Functions (`utils.R`)  
- `use_quarto_report()`, `use_quarto_slides()` - Add reporting to existing projects
- `use_shiny_dashboard()`, `use_shiny_app()` - Add Shiny components
- `use_targets()` - Add targets pipeline
- `update_cpal_assets()` - Update CSS/images to latest versions

## 🎨 Available Color Palettes

### Sequential Palettes (7 variants)
- `teal_seq_4`, `teal_seq_5`, `teal_seq_6` - Single-hue teal gradients
- `yellow_teal_seq_4`, `yellow_teal_seq_5`, `yellow_teal_seq_6` - Multi-hue gradients

### Diverging Palettes (3 variants)  
- `pink_teal_3`, `pink_teal_5`, `pink_teal_6` - Pink to teal with neutral center

### Categorical Palettes (6 variants)
- `main` - Primary 5-color palette
- `main_gray` - Primary + gray (6 colors)
- `blues`, `compare`, `main_3`, `main_4` - Subset palettes

## 📖 Documentation

Comprehensive documentation with examples available in the QMD documentation file created during this review. The documentation covers:

- Installation and setup
- Complete function examples  
- Advanced workflows
- Interactive features
- Best practices
- Project creation guides

## 🔧 Development Workflow

All changes to this package follow our established workflow:

1. **Function Development** → Immediate README.md update
2. **Template Addition** → Documentation in README.md  
3. **Task Completion** → Check off in task list below
4. **Version Changes** → Update this status section

## 📋 Current Task List

### 🔄 In Progress  
- [x] Complete thorough review of all R functions in the package
- [x] Create comprehensive QMD documentation for all functions with examples  
- [x] Update README.md with current function inventory and task tracking

### 📅 Pending Tasks
- [ ] **High Priority**: Implement missing logo functions referenced in documentation
- [ ] **High Priority**: Verify all template files exist in inst/ directory and are accessible  
- [ ] **Medium Priority**: Add proper roxygen2 documentation to all functions
- [ ] **Medium Priority**: Create comprehensive testing suite for all functions
- [ ] **Low Priority**: Optimize font handling across different platforms
- [ ] **Low Priority**: Test color palettes for colorblind accessibility  
- [ ] **Low Priority**: Set up QMD documentation as GitHub Pages site

### 🎯 Next Development Priorities

1. **Template File Audit** - Check all `system.file()` calls in `start_project.R` 
2. **Logo Function Implementation** - Create `add_cpal_logo()` function
3. **Testing Infrastructure** - Set up testthat framework
4. **Documentation Polish** - Complete roxygen2 docs

## 💡 Usage Philosophy

This package follows the principle that **CPAL data team workflows should be**:
- **Consistent** - Same visual identity across all outputs
- **Accessible** - Colorblind-safe palettes and proper contrast
- **Professional** - Publication-ready defaults  
- **Efficient** - Minimize repetitive styling work
- **Reproducible** - Template-based project structure

## 🤝 Contributing

When contributing to this package:

1. **Always update README.md** with any function changes
2. **Use the task list** to track ongoing work  
3. **Test across platforms** (Windows/Mac/Linux)
4. **Follow CPAL brand guidelines** for any visual elements
5. **Maintain backward compatibility** for existing team workflows

---

**Last Updated**: July 24, 2025  
**Package Maintainer**: CPAL Data Team  
**Current Version**: Development
