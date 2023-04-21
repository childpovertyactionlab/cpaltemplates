
# cpaltemplates

**NOTE:** This project is still under active development.

**NOTE** This package is based on 'library(urbntemplates)' from the Urban Institute. Changes are currently being made to generate templates that fall in line with Child Poverty Action Lab (CPAL) standards.

`library(cpaltemplates)` contains tools and templates for managing
analysis workflows at the Child Poverty Action Lab. It heavily relies on
functions and functionality from
[usethis](https://github.com/r-lib/usethis).

## Installation

You can install the latest version of `cpaltemplates` from GitHub:

    # install.packages("devtools")
    devtools::install_github("childpovertyactionlab/cpaltemplates")

## Usage

`library(cpaltemplates)` contains three families of functions:

`start_project()` generates a new project with a .Rproj, README, and
.gitignore at the specified location on a machine.

`construct_*()` functions add multiple, related templates and documents
to a project directory or sub-directory. The templates and documents are
related in important ways. For example, `construct_shiny()` adds `app.R`
and an R Shiny specific CSS. It also adds instructions for using the
selected template.

`use_*()` functions add individual templates and documents to a project
directory or sub directory.

`theme` functions contain theme styling for various R outputs.

`scale_*()` functions generate color sets to be used in visualizations.

`data` datasets stored within package to keep consistency across CPAL workflows.

A sensible workflow is:

1)  Start a new project and create a .Rproj by submitting
    `cpaltemplates::start_project()`. This will create and open a new
    .Rproj.
2)  Inside the .Rproj, add the necessary documents for a part of a
    project, like a Shiny application, with a `construct_*()` function.
3)  Add any desired remaining templates or documents with `use_*()`
    functions.

Note:

`construct_*()` functions are useful on their own. If you have an
existing project, just use `construct_*()` to add all of the necessary
templates and documents for creating a product like a branded slide show
or an R Markdown web report.

### start function

  - `start_project()` Creates a set of folders and a new Rproj file within a specified directory. Folders included are _Scripts_, _Data_, and _Graphics_ to house anything necessary for a new analysis.

### construct functions

  - `construct_shiny()` Generates an app.R file along with scss theme templates and images for a shiny dashboard with CPAL branding that can be uploaded to shinyapps.io.
  - `construct_web_report()` Generates a .qmd file along with _quarto.yml theme templates and images for a web report with CPAL branding that can be uploaded to github pages.

### use functions

  - `use_content()` Imports content from package templates folder into respective product types. Content such as CPAL branded images/logos.
  - `use_css()` Imports scss file where needed from package templates folder into respective product types such as web reports or fact sheets. 
  - `use_git_ignore_cpal()` Generates a .gitignore file for use in files that will be uploaded to github.
  - `use_instructions()` Generates an instructions markdown document for respective product types to guide users on correct practices for use of web products.
  - `use_readme_cpal()`Generates a readme markdown document which should be filled out by user to provide necessary information project being completed.
  - `use_shiny_app()` Generates a new shiny app template for use alongside `construct_shiny()` function, when new app templates are needed.
  - `use_web_report()` Generates a new web report  template for use alongside `construct_web_report()` function, when new app templates are needed.

## theme functions
  - `cpal_shiny` Theme to be used for all CPAL branded shiny dashboards. Shiny template already contains insertion of this function.
  - `theme_cpal` Used to provide a`ggplot2` for use across all CPAL branded plots. 

## scale functions
  - `scale_fill_cpal()` Fill function used for `ggplot2` visualizations, contains three themes named _factor_, _diverge_, and _triad_ that should be used with respective visualization type.
  - `scale_color_cpal()` Color function used for `ggplot2` visualizations, contains three themes named _factor_, _diverge_, and _triad_ that should be used with respective visualization type.

## datasets
  - `acs_variables` Contains commonly used acs field tables which are consistently used when pulling data from the `tidycensus` package.
  - `ntx_county` Contains a named list of the eight surrounding counties around Dallas County.
  - `cpal_leaflet` Contains attribution information for leaflet maps.
  - `cpal_mapbox` Contains mapbox link for theming leaflet maps.

## License

Code released under the GNU General Public License v3.0.

## Code of conduct

Please note that the “cpaltemplates” project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
