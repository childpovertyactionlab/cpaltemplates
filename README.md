# cpaltemplates

**NOTE:** This project is under active development, based on the 'urbntemplates' package from the Urban Institute, with modifications for Child Poverty Action Lab (CPAL) standards.

The `cpaltemplates` package provides tools and templates for managing analysis workflows at CPAL, leveraging [usethis](https://github.com/r-lib/usethis) and other packages like [ggplot2] for plotting and [extrafont] for font management.

## Installation

You can install the latest version of `cpaltemplates` from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("childpovertyactionlab/cpaltemplates")
```

## Usage

The package is structured around several function families:

### 1. **Project Management Functions**

These functions help initialize new projects or add templates to existing ones.

-   **`start_project()`**: Initializes a new project with a `.Rproj`, `README`, and `.gitignore`.

### 2. **Construct Functions**

These functions add related templates and documents for specific types of projects, like Shiny apps or web reports.

-   **`construct_shiny()`**: Adds necessary files for building a Shiny application (e.g., `app.R`, CSS).
-   **`construct_web_report()`**: Adds files for creating a web report (e.g., `web_report.qmd`, styling).

### 3. **Use Functions**

These functions add individual templates or documents to an existing project.

-   **`use_content()`**: Adds images or other media files to a project.
-   **`use_css()`**: Adds a CSS or SCSS stylesheet to a specified directory.
-   **`use_git_ignore_cpal()`**: Adds CPAL-specific `.gitignore` settings.
-   **`use_instructions()`**: Adds instructions related to specific project types.
-   **`use_readme_cpal()`**: Generates a CPAL-specific `README` template.
-   **`use_shiny_app()`**: Creates a Shiny app template.
-   **`use_web_report()`**: Generates a web report template.

### 4. **Theme Functions**

These functions provide pre-configured visual themes that conform to CPAL standards for [ggplot2] and Shiny apps.

-   **`cpal_shiny()`**: Applies a Shiny-specific theme based on CPAL’s visual guidelines.
-   **`theme_cpal_map()`**: Applies a map-based theme for visualizations.
-   **`theme_cpal_print()`**: Applies a print-ready theme for clean and minimalist plots.

### 5. **Grob and Plot Functions**

These functions help create and format ggplot2 plots and grobs (graphical objects).

-   **`cpal_plot()`**: Combines multiple plot elements or grobs (e.g., titles, subtitles, charts) into one cohesive plot.
-   **`cpal_title()`**: Adds a title to a plot.
-   **`cpal_subtitle()`**: Adds a subtitle to a plot.
-   **`cpal_note()`**: Adds a note section at the bottom of the plot.
-   **`cpal_source()`**: Adds a source label to a plot.
-   **`add_axis()`**: Adds or removes axis lines in a plot.
-   **`remove_ticks()`**: Removes tick marks from specified axes.
-   **`remove_legend()`**: Removes the legend from a ggplot2 plot.

### 6. **Scale Functions**

These functions provide color scales based on CPAL's style guide.

-   **`scale_color_discrete()`**: Discrete color scale for categorical variables.
-   **`scale_fill_discrete()`**: Discrete fill scale for categorical variables.
-   **`scale_color_gradientn()`**: Continuous gradient color scale for numerical variables.
-   **`scale_fill_gradientn()`**: Continuous gradient fill scale for numerical variables.
-   **`scale_color_ordinal()`**: Ordinal color scale for factors.
-   **`scale_fill_ordinal()`**: Ordinal fill scale for factors.

### 7. **Utility Functions**

These functions help manage fonts and templates within the package.

-   **`poppins_import()`**: Imports and registers the Poppins font, which is the main font used at CPAL.
-   **`fontawesome_install()`**: Imports and registers the FontAwesome font for use in graphics.

## Example Workflow

1.  **Starting a Project**:\
    Create a new project by running:

    ``` r
    cpaltemplates::start_project("MyProject")
    ```

2.  **Adding Templates**:\
    Use `construct_*` functions to add necessary files. For example, to add Shiny files:

    ``` r
    construct_shiny()
    ```

3.  **Creating Visualizations**:\
    Use CPAL’s predefined themes and scales to ensure your visualizations adhere to CPAL standards:

    ``` r
    ggplot(mtcars, aes(x = wt, y = mpg)) +
      geom_point() +
      theme_cpal_print() +
      scale_color_discrete()
    ```

## License

This project is licensed under the MIT License.

## Code of Conduct

Please note that the "cpaltemplates" project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
