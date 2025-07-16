
# cpaltemplates

**A modern toolkit for data analysis workflows at the Child Poverty
Action Lab**

## Vision

cpaltemplates is evolving from a simple template package into a
comprehensive workflow toolkit that helps CPAL’s data team work faster,
more consistently, and with higher quality outputs. We’re building
intelligent tools that understand context and automate repetitive tasks
while maintaining flexibility for custom analyses.

## What’s New in This Approach

Instead of just copying static templates, cpaltemplates now provides: -
🧠 **Smart workflows** that adapt to your project needs - 🔄
**Integrated pipelines** using modern R tools like targets and Quarto -
📊 **Context-aware visualizations** that adjust to different audiences -
✅ **Built-in quality checks** for data, code, and outputs - 👥
**Collaboration features** for team projects

## Current Features (v1.6.0)

### ✅ Core Functionality

- **`start_project()`**: Intelligent project initialization
  - Project types: general, shiny, report
  - Modern integrations: renv, git, Quarto
  - Standardized folder structures
  - Team-ready configurations
  - ✅ All content now created from templates

### 📁 Project Templates

- Analysis workflow templates
- Quarto report templates with TeX support
- Shiny app templates (simple and dashboard)
- Documentation templates
- Environment configurations
- ✅ Modular template system in `inst/templates/`

### 🎨 Assets & Branding
- ✅ **Color Palettes**: Complete CPAL brand color system
  - Primary brand colors (Midnight, Teal, Pink, Orange, Gold)
  - Sequential palettes (single-hue and multi-hue)
  - Diverging palettes (pink-to-teal)
  - Categorical palettes (2-6 colors)
### 🛠️ Utility Functions (`use_*`)

- **`use_quarto_report()`** - Add report capability to existing projects
- **`use_quarto_slides()`** - Add presentation templates
- **`use_shiny_app()`** - Add simple Shiny app
- **`use_shiny_dashboard()`** - Add full dashboard with modules
- **`use_targets()`** - Add reproducible pipelines (3 types)
- **`update_cpal_assets()`** - Update branding in existing projects \##
  Installation

``` r
# Install from GitHub
# install.packages("devtools")
devtools::install_github("childpovertyactionlab/cpaltemplates")
```

## Quick Start

```r
# Install from GitHub
devtools::install_github("childpovertyactionlab/cpaltemplates")

# Load the package
library(cpaltemplates)

# Create a new CPAL project
start_project("my_analysis")

# View available color palettes
view_all_palettes()

## Color Palettes

The package includes the complete CPAL brand color system with multiple palette types for different visualization needs.

### Brand Colors

```r
# Get primary brand colors
cpal_colors("primary")
#>  midnight      teal      pink    orange      gold 
#> "#004855" "#008097" "#C3257B" "#ED683F" "#AB8C01"

# Get specific colors
cpal_colors(c("teal", "orange"))
#>      teal    orange 
#> "#008097" "#ED683F"
```

### Available Palettes

#### Sequential Palettes
For continuous data:
- `teal_seq_4`, `teal_seq_5`, `teal_seq_6` - Single-hue teal gradients
- `yellow_teal_seq_4`, `yellow_teal_seq_5`, `yellow_teal_seq_6` - Multi-hue yellow to teal

#### Diverging Palettes
For data with meaningful midpoints:
- `pink_teal_3`, `pink_teal_5`, `pink_teal_6` - Pink to teal through neutral gray

#### Categorical Palettes
For discrete categories:
- `main` - 5 main brand colors
- `main_gray` - 6 colors including gray
- `blues` - 2 shades of blue
- `compare` - Gray and teal for comparisons
- `main_3`, `main_4` - Subsets of main colors

### View All Palettes

```r
# View all palettes in a grid with hex codes
view_all_palettes()

# View palettes in horizontal bars
view_palette()
```

### Using with ggplot2

```r
library(ggplot2)

# Categorical data
ggplot(mpg, aes(class, fill = drv)) +
  geom_bar() +
  scale_fill_cpal()

# Continuous data with sequential palette
ggplot(mpg, aes(displ, hwy, color = cty)) +
  geom_point(size = 3) +
  scale_color_cpal("teal_seq_6", discrete = FALSE)

# Diverging data
ggplot(mtcars, aes(factor(cyl), mpg, fill = mpg)) +
  geom_boxplot() +
  scale_fill_cpal("pink_teal_5", discrete = FALSE)
```

### Palette Selection Guide

- **Sequential Single-Hue**: Use when showing intensity or concentration of a single variable
- **Sequential Multi-Hue**: Better for heat maps or when you need more visual distinction
- **Diverging**: Use when your data has a meaningful midpoint (e.g., positive/negative, above/below average)
- **Categorical**: Use for distinct groups with no inherent order
## Development Roadmap

### 🎯 Phase 1: Enhanced Templates & Workflows (Current Priority)

#### Analysis Workflows

- [ ] **Modern analysis templates**
  - [ ] Targets-based pipeline templates
  - [ ] Reproducible analysis workflows
  - [ ] Data validation templates
  - [ ] Model comparison frameworks
- [ ] **Project health checks**
  - [ ] `check_project()` - Verify setup and dependencies
  - [ ] `validate_data()` - Data quality checks
  - [ ] `test_pipeline()` - Pipeline validation

#### Quarto Integration

- [ ] **Enhanced Quarto templates**
  - [ ] Multi-format reports (HTML, PDF, Word)
  - [ ] Parameterized reports
  - [ ] Cross-references and citations
  - [ ] Custom CPAL themes
- [ ] **Quarto workflows**
  - [ ] `use_quarto_report()` - Advanced report setup
  - [ ] `use_quarto_presentation()` - Slide templates
  - [ ] `render_all_formats()` - Multi-output rendering

#### Shiny Applications

- [ ] **Smart Shiny templates**
  - [ ] Dashboard layouts
  - [ ] Data explorer templates
  - [ ] Report generators
  - [ ] Mobile-responsive designs
- [ ] **Shiny utilities**
  - [ ] `use_shiny_dashboard()` - Full dashboard setup
  - [ ] `add_shiny_module()` - Modular components
  - [ ] `deploy_shiny()` - Deployment helpers

### 📊 Phase 2: Modern Data Visualization

#### ggplot2 Enhancement

- [ ] **Smart plotting system**
  - [ ] `cpal_plot()` - Intelligent plot creation
  - [ ] Context-aware theming
  - [ ] Automatic accessibility checks
  - [ ] Multi-format export
- [ ] **Plot types**
  - [ ] Time series with annotations
  - [ ] Comparative visualizations
  - [ ] Geographic maps
  - [ ] Statistical summaries

#### Beyond ggplot2

- [ ] **Interactive visualizations**
  - [ ] Plotly integration
  - [ ] Observable Plot templates
  - [ ] D3.js components
  - [ ] Leaflet map templates
- [ ] **Tables and reports**
  - [ ] `cpal_table()` - Smart table formatting
  - [ ] GT table themes
  - [ ] Interactive tables with reactable
  - [ ] Excel report generation

### 🔧 Phase 3: Workflow Automation

#### Pipeline Management

- [ ] **Targets integration**
  - [ ] Pipeline templates
  - [ ] Caching strategies
  - [ ] Parallel processing
  - [ ] Dependency visualization
- [ ] **Automation tools**
  - [ ] Scheduled reports
  - [ ] Data refresh workflows
  - [ ] Quality monitoring

#### Documentation & Quality

- [ ] **Auto-documentation**
  - [ ] Code documentation
  - [ ] Data dictionaries
  - [ ] Method descriptions
  - [ ] Change logs
- [ ] **Quality assurance**
  - [ ] Unit test templates
  - [ ] Data validation rules
  - [ ] Output verification
  - [ ] Performance monitoring

### 🔌 Phase 4: Data Connections (Future)

#### Connection Management

- [ ] **Database connections**
  - [ ] Secure credential storage
  - [ ] Connection pooling
  - [ ] Query builders
  - [ ] Cache management
- [ ] **API integrations**
  - [ ] Census data access
  - [ ] City data portals
  - [ ] Education databases
  - [ ] Social service APIs

## Example: Modern Workflow

```r
# Start a new CPAL project
library(cpaltemplates)
start_project("dallas_housing_analysis")

# In your analysis script:
library(tidyverse)
library(cpaltemplates)

# Load and process data
housing_data <- read_csv("data/dallas_housing.csv") %>%
  mutate(price_category = cut(median_price, breaks = 5))

# Create visualizations with CPAL colors
ggplot(housing_data, aes(x = year, y = median_price, color = district)) +
  geom_line(size = 1.2) +
  scale_color_cpal("main") +  # Automatic CPAL colors
  scale_y_continuous(labels = scales::dollar) +
  labs(
    title = "Dallas Housing Prices by District",
    subtitle = "Median home prices 2019-2024",
    caption = "Source: Dallas County Appraisal District"
  ) +
  theme_minimal(base_size = 12)

# Create a heatmap with sequential colors
ggplot(correlation_matrix, aes(x = var1, y = var2, fill = correlation)) +
  geom_tile() +
  scale_fill_cpal("yellow_teal_seq_6", discrete = FALSE) +
  theme_minimal()

# Compare groups with diverging colors
ggplot(school_performance, aes(x = school, y = score_diff, fill = score_diff)) +
  geom_col() +
## Why This Approach?

### 🚀 Immediate Benefits

- **Faster project setup**: Minutes instead of hours
- **Consistent outputs**: Same quality across all projects
- **Better collaboration**: Shared standards and workflows
- **Reduced errors**: Built-in validation and checks

### 🔮 Future-Ready

- **Modern R ecosystem**: Embraces tidyverse, Quarto, targets
- **Scalable workflows**: From simple analyses to complex pipelines
- **Team-oriented**: Built for collaboration from the ground up
- **Continuously improving**: Regular updates based on team needs

## Contributing

We welcome contributions! Priority areas: 1. Template improvements 2.
Workflow examples 3. Documentation 4. Bug reports and feature requests

See our [Contributing Guide](CONTRIBUTING.md) for details.

## Getting Help

- 📖 **Documentation**: See package vignettes (coming soon)
- 💬 **Questions**: Contact the CPAL data team
- 🐛 **Issues**: [GitHub
  Issues](https://github.com/childpovertyactionlab/cpaltemplates/issues)
- 📧 **Email**: <datalab@childpovertyactionlab.org>

## Changelog

### Version 1.6.1 (Latest)
- ✅ **Template System Overhaul**:
  - All project content now generated from template files
  - Added templates for .Rproj and DESCRIPTION files
  - Removed hardcoded content from `start_project.R`
  - Improved maintainability and customization
- ✅ **New Templates Added**:
  - `inst/templates/rproj.tpl` - RStudio project settings
  - `inst/templates/package/DESCRIPTION.tpl` - Package description template


### Version 1.6.0 (Current)
- ✅ Complete CPAL color palette system
  - Brand colors with corrected values (Teal: #008097, Gold: #AB8C01)
  - Sequential palettes (4-6 colors, single and multi-hue)
  - Diverging palettes (pink-to-teal, 3-6 colors)
  - Categorical palettes (2-6 colors)
- ✅ Color palette viewing functions:
  - `view_palette()` - Display all palettes in bar format
  - `view_all_palettes()` - Grid view with hex codes
- ✅ ggplot2 integration:
  - `scale_color_cpal()` and `scale_fill_cpal()`
### Version 1.5.1

- Initial streamlined version
- Basic `start_project()` function
- Core templates for reports and Shiny apps

## License

GPL-3

## Acknowledgments

- Inspired by
  [urbntemplates](https://github.com/UrbanInstitute/urbntemplates) from
  the Urban Institute
- Built by and for the Child Poverty Action Lab data team
- Special thanks to all contributors and users who provide feedback

------------------------------------------------------------------------

*Building better data workflows for social impact* 🌟
