# Contributing to cpaltemplates

Thank you for considering contributing to cpaltemplates!

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

- **Be respectful** of differing viewpoints and experiences
- **Be constructive** in your feedback and criticism
- **Be collaborative** and help others learn and grow
- **Be inclusive** and welcoming to all participants
- **Be professional** in all interactions

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- R ≥ 4.3.0
- RStudio (recommended)
- Git
- A GitHub account

### Setting Up Your Development Environment

1. **Fork the repository** on GitHub

2. **Clone your fork locally**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/cpaltemplates.git
   cd cpaltemplates
   ```

3. **Add the upstream remote**:
   ```bash
   git remote add upstream https://github.com/childpovertyactionlab/cpaltemplates.git
   ```

4. **Install development dependencies**:
   ```r
   # Install devtools if you haven't already
   install.packages("devtools")
   
   # Install package dependencies
   devtools::install_deps(dependencies = TRUE)
   
   # Install development tools
   install.packages(c("testthat", "roxygen2", "lintr", "covr"))
   ```

5. **Create a new branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include:

- **Clear, descriptive title**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **System information** (R version, OS, package versions)
- **Minimal reproducible example** (reprex)

Example:
```r
# Good bug report includes a reprex
library(cpaltemplates)
# Your code that produces the error
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Use case**: Why is this enhancement needed?
- **Expected behavior**: How should it work?
- **Examples**: Code examples of the proposed API
- **Alternatives**: Have you considered any alternatives?

### Contributing Code

#### Areas Where We Need Help

- 📊 **New visualization themes**: Additional theme variants
- 🎨 **Color palettes**: Specialized palettes for specific use cases
- 📋 **Table enhancements**: Additional formatting options
- 🚀 **Project templates**: New project types and workflows
- 📝 **Documentation**: Examples, vignettes, tutorials
- 🧪 **Testing**: Increase test coverage
- 🔧 **Performance**: Optimization for large datasets

#### Before You Start

- Check the [Issues](https://github.com/childpovertyactionlab/cpaltemplates/issues) page
- Look for issues labeled `good first issue` or `help wanted`
- Comment on the issue to let others know you're working on it

## Development Workflow

### 1. Write Your Code

Follow these principles:

- **One feature per pull request**
- **Write clear, self-documenting code**
- **Follow the existing code style**
- **Add comments for complex logic**
- **Update documentation as needed**

### 2. Add/Update Tests

All new features should include tests:

```r
# Example test structure
test_that("my_function works correctly", {
  result <- my_function(input)
  expect_equal(result, expected_output)
  expect_error(my_function(bad_input))
})
```

Run tests locally:
```r
devtools::test()
```

### 3. Update Documentation

- Update roxygen2 comments for any modified functions
- Run `devtools::document()` to regenerate documentation
- Update README.md if adding new features
- Add entries to NEWS.md for significant changes

### 4. Check Your Work

Before submitting, run these checks:

```r
# Check the package
devtools::check()

# Check code style
lintr::lint_package()

# Check test coverage
covr::package_coverage()

# Build and check documentation
devtools::document()
pkgdown::build_site()  # if applicable
```

## Style Guidelines

### R Code Style

We follow the [tidyverse style guide](https://style.tidyverse.org/) with these specifics:

#### Naming Conventions
- **Functions**: `snake_case` (e.g., `theme_cpal()`)
- **Variables**: `snake_case` (e.g., `plot_title`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `DEFAULT_COLORS`)

#### Code Organization
```r
# Good function structure
#' Title
#'
#' Description
#'
#' @param x Parameter description
#' @return Return value description
#' @export
#' @examples
#' my_function(1)
my_function <- function(x) {
  # Validate inputs
  stopifnot(is.numeric(x))
  
  # Main logic
  result <- x * 2
  
  # Return
  return(result)
}
```

#### Best Practices
- Use explicit returns: `return(value)`
- Validate inputs early in functions
- Use meaningful variable names
- Keep functions focused and single-purpose
- Avoid dependencies when possible

### Documentation Style

- Use complete sentences in documentation
- Include examples for all exported functions
- Link related functions with `@seealso`
- Use `@family` tags to group related functions

### Commit Messages

Follow conventional commits format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```bash
feat(themes): add theme_cpal_presentation for slides
fix(colors): correct color contrast in dark theme
docs(readme): add installation troubleshooting section
```

## Testing

### Writing Tests

Place tests in `tests/testthat/` with filename `test-<topic>.R`:

```r
# tests/testthat/test-themes.R
test_that("theme_cpal returns correct class", {
  theme <- theme_cpal()
  expect_s3_class(theme, "theme")
  expect_s3_class(theme, "gg")
})

test_that("theme_cpal handles invalid inputs", {
  expect_error(theme_cpal(base_size = "large"))
  expect_error(theme_cpal(style = "invalid"))
})
```

### Test Coverage

Aim for at least 80% test coverage for new code:

```r
# Check coverage for your changes
covr::package_coverage()
covr::report()
```

## Documentation

### Function Documentation

Every exported function needs:

```r
#' Create a CPAL-styled plot
#'
#' This function creates a visualization following CPAL brand guidelines.
#' It automatically applies appropriate themes and color palettes.
#'
#' @param data A data frame containing the data to plot
#' @param x Name of the x-axis variable (unquoted)
#' @param y Name of the y-axis variable (unquoted)
#' @param color Optional grouping variable for colors (unquoted)
#' @param title Plot title
#' @param subtitle Plot subtitle
#' @param ... Additional arguments passed to ggplot2
#'
#' @return A ggplot2 object with CPAL styling
#' 
#' @export
#' 
#' @examples
#' # Basic usage
#' cpal_plot(mtcars, x = mpg, y = wt)
#' 
#' # With grouping
#' cpal_plot(mtcars, x = mpg, y = wt, color = factor(cyl))
#' 
#' @seealso 
#' \code{\link{theme_cpal}} for the underlying theme
#' \code{\link{scale_color_cpal}} for color palettes
#' 
#' @family plotting functions
```

### Vignettes

For major features, consider adding a vignette:

```r
usethis::use_vignette("my-feature")
```

## Submitting Changes

### Pull Request Process

1. **Update your branch** with the latest upstream changes:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request** on GitHub with:
   - Clear title describing the change
   - Description of what changed and why
   - Link to any relevant issues
   - Screenshots for visual changes
   - Checklist of completed items

4. **PR Checklist**:
   - [ ] Code follows style guidelines
   - [ ] Tests pass locally
   - [ ] Documentation updated
   - [ ] NEWS.md entry added (for significant changes)
   - [ ] R CMD check passes with no errors/warnings
   - [ ] Examples run successfully

### Review Process

- PRs require at least one review before merging
- Address all feedback constructively
- Make requested changes in new commits (don't force-push during review)
- Once approved, we'll merge your PR!

## Recognition

Contributors will be recognized in:
- The package DESCRIPTION file
- The project README
- Release notes

## Questions?

Feel free to:
- Open an issue for questions
- Contact the maintainers at datalab@childpovertyactionlab.org
- Join our discussions on GitHub

## Thank You!

Your contributions help make data analysis more accessible and impactful for addressing child poverty. We appreciate your time and effort in improving this package!

---

*This contributing guide is adapted from best practices in the R and open-source communities.*
