# cpaltemplates Package Review

**Date:** 2026-01-05
**Branch:** FEATURE/theme-testing
**Reviewer:** Claude Code Analysis

---

## Executive Summary

The `cpaltemplates` package is undergoing a significant refactoring to improve Shiny dashboard theming using BSlib's `_brand.yml` integration. The new code in `base-app/template-sources/` represents the next generation of these functions, but **is NOT yet safe to move directly to `R/`** due to several critical issues that must be resolved first.

---

## 1. Current State of the Repository

### R/ Folder (Production Code)
Currently only contains **one file**:
- `R/dashboards.R` - Contains `cpal_shiny()`, `cpal_add_scss_enhancements()`, `cpal_export_scss()`

### base-app/template-sources/ (Development Code)
Contains **8 files** with updated/new functions:

| File | Purpose | Key Functions |
|------|---------|---------------|
| `colors.R` | Brand.yml color integration | `cpal_get_color()`, `cpal_get_primary_color()` |
| `dashboards.R` | New BSlib theme | `cpal_dasbhoard_theme()`, `cpal_export_scss()` |
| `themes.R` | ggplot2 themes | `theme_cpal()` + all variants |
| `tables.R` | Table styling | `cpal_table_gt()`, `cpal_table_reactable()` |
| `interactive.R` | Interactive features | `cpal_interactive()`, `cpal_mapgl()`, font setup |
| `plots.R` | Plot utilities | `save_cpal_plot()`, `add_cpal_logo()`, scales |
| `projects.R` | Project scaffolding | `start_project()` + all setup functions |
| `utils.R` | Template utilities | `use_quarto_*()`, `use_shiny_*()`, `use_targets()` |

---

## 2. Critical Issues ~~to Fix Before Migration~~ RESOLVED

### 2.1 ~~Typo in Function Name~~ FIXED
**File:** `base-app/template-sources/dashboards.R`
- ~~`cpal_dasbhoard_theme`~~ → `cpal_dashboard_theme` ✓

### 2.2 ~~Invalid Package Reference~~ FIXED
**File:** `base-app/template-sources/colors.R`

The `brand.yml` package is a real Posit package:
- Documentation: https://posit-dev.github.io/brand-yml/
- CRAN: https://www.rdocumentation.org/packages/brand.yml/versions/0.1.0

Both `read_brand_yml()` and `brand_color_pluck()` are valid functions in this package.

**Resolution:** Updated to use the official `brand.yml` package with fallbacks:
- Uses `brand.yml::read_brand_yml()` and `brand.yml::brand_color_pluck()` when available
- Cached brand loading with `.load_cpal_brand()` internal function
- Fallback to `yaml::read_yaml()` if `brand.yml` package not installed
- Graceful fallbacks with hardcoded defaults if brand file not found

### 2.3 ~~Undefined Variable in _brand.yml~~ FIXED
**File:** `base-app/_brand.yml`
- ~~`"progress-bg": light_neutral`~~ → `"progress-bg": white` ✓

### 2.4 Color Palette Change - CONFIRMED INTENTIONAL
The primary color change from `#042D33` to `#007A8C` (teal) is an intentional brand update.

### 2.5 ~~Hardcoded File Path~~ FIXED
**File:** `base-app/template-sources/dashboards.R`

**Resolution:** Updated to use `system.file()` with fallback paths:
```r
scss_path <- system.file("scss", "cpal-theme.scss", package = "cpaltemplates")
# Falls back to local paths for development context
```

---

## 3. Function Duplication Analysis

### Functions that exist in BOTH locations:

| Function | R/dashboards.R | template-sources/ | Status |
|----------|----------------|-------------------|--------|
| `cpal_export_scss()` | Yes | dashboards.R | Similar, minor differences |
| `cpal_shiny()` | Yes (deprecated) | No | **DEPRECATED** - use `cpal_dashboard_theme()` |
| `cpal_dashboard_theme()` | No | dashboards.R | **NEW** - replacement for `cpal_shiny()` |

### Deprecation Notes
- `cpal_shiny()` now shows a deprecation warning directing users to `cpal_dashboard_theme()`
- `cpal_dashboard_theme()` uses `_brand.yml` for more flexible theming via BSlib's brand support

### Functions ONLY in template-sources/ (need to be added):

| Function | File | Currently Exported? |
|----------|------|---------------------|
| `cpal_get_color()` | colors.R | No |
| `cpal_get_primary_color()` | colors.R | No |
| `cpal_dashboard_theme()` | dashboards.R | No |
| All in themes.R | themes.R | Some via NAMESPACE |
| All in tables.R | tables.R | Yes |
| All in interactive.R | interactive.R | Yes |
| All in plots.R | plots.R | Yes |
| All in projects.R | projects.R | Yes |
| All in utils.R | utils.R | Yes |

---

## 4. TODO Items Already Marked in Code

The following functions have `@section TODO:` markers indicating they need validation:

1. `cpal_export_scss()` - dashboards.R
2. `setup_cpal_google_fonts()` - interactive.R
3. `get_cpal_font_family()` - interactive.R
4. `cpal_interactive()` - interactive.R
5. `save_cpal_plot()` - plots.R
6. `scale_color_cpal_c()` - plots.R
7. `scale_fill_cpal_c()` - plots.R
8. `scale_color_cpal_d()` - plots.R
9. `scale_fill_cpal_d()` - plots.R
10. `add_cpal_logo()` - plots.R
11. `cpal_table()` - plots.R
12. `check_plot_accessibility()` - plots.R
13. `use_shiny_app()` - utils.R
14. `use_shiny_theme()` - utils.R

---

## 5. Recommended Migration Plan

### Phase 1: Fix Critical Issues (Before Any Migration)

1. **Fix typo:** `cpal_dasbhoard_theme` → `cpal_dashboard_theme`

2. **Fix brand.yml integration:** Replace invalid `brand.yml` package with proper yaml parsing:
   ```r
   # In colors.R
   .cpal_brand <- NULL

   .load_brand <- function() {
     if (is.null(.cpal_brand)) {
       brand_path <- system.file("brand", "_brand.yml", package = "cpaltemplates")
       if (file.exists(brand_path)) {
         .cpal_brand <<- yaml::read_yaml(brand_path)
       }
     }
     .cpal_brand
   }
   ```

3. **Fix _brand.yml:** Replace `light_neutral` with valid color (e.g., `white`)

4. **Decide on primary color:** Document whether moving from `#042D33` to `#007A8C` is intentional

### Phase 2: Restructure R/ Directory

Organize by function category:
```
R/
├── colors.R          # Color palette functions
├── themes.R          # ggplot2 themes
├── scales.R          # ggplot2 color/fill scales
├── tables.R          # GT and Reactable tables
├── interactive.R     # ggiraph and mapgl wrappers
├── shiny.R           # Shiny theme functions (merge dashboards.R)
├── projects.R        # Project scaffolding
├── utils.R           # General utilities
└── zzz.R             # Package onLoad hooks
```

### Phase 3: Update Package Infrastructure

1. **DESCRIPTION:** Add any new dependencies (e.g., `thematic` if keeping)

2. **NAMESPACE:** Update with new exports after reorganization

3. **inst/brand/_brand.yml:** Move brand config to package resources

4. **inst/scss/cpal-theme.scss:** Move SCSS to package resources

### Phase 4: Testing & Documentation

1. Run `devtools::check()` after each file migration
2. Update roxygen documentation
3. Test the demo app still works
4. Update CLAUDE.md with new architecture

---

## 6. Files That Can Be Removed

| File/Location | Reason |
|---------------|--------|
| `base-app/template-sources/` | After migration to R/ |
| `base-app/www/shiny.scss` | If consolidated into cpal-theme.scss |
| Duplicate template files | After verifying inst/templates has latest |

---

## 7. _brand.yml Integration Strategy

The `_brand.yml` file is designed to work with BSlib's theming system. Here's the recommended approach:

### Option A: BSlib Native (Recommended)
```r
cpal_dashboard_theme <- function() {
  brand_path <- system.file("brand", "_brand.yml", package = "cpaltemplates")

  theme <- bslib::bs_theme(
    version = 5,
    brand = brand_path  # BSlib reads _brand.yml directly
  )

  # Add custom SCSS
  scss_path <- system.file("scss", "cpal-theme.scss", package = "cpaltemplates")
  if (file.exists(scss_path)) {
    theme <- bslib::bs_add_rules(theme, sass::sass_file(scss_path))
  }

  theme
}
```

### Option B: Manual Parsing
If you need more control, parse _brand.yml manually with `yaml::read_yaml()`.

---

## 8. Immediate Action Items

### Must Fix Before Migration:
- [ ] Fix `cpal_dasbhoard_theme` typo → `cpal_dashboard_theme`
- [ ] Fix `library(brand.yml)` - use yaml package or bslib brand support
- [ ] Fix `light_neutral` in _brand.yml
- [ ] Confirm primary color change is intentional

### Should Do:
- [ ] Consolidate all R functions into organized R/ files
- [ ] Move _brand.yml to inst/brand/
- [ ] Move SCSS files to inst/scss/
- [ ] Update NAMESPACE exports
- [ ] Add highcharter to DESCRIPTION Suggests

### Nice to Have:
- [ ] Address all TODO items in code
- [ ] Add unit tests for new functions
- [ ] Create migration vignette

---

## 9. Conclusion

**Is it safe to move files from base-app/template-sources/ to R/?**

**YES - Critical issues have been resolved:**

1. ✅ The `brand.yml` package is real and functions work correctly
2. ✅ Typo in function name fixed (`cpal_dashboard_theme`)
3. ✅ Color palette change confirmed as intentional
4. ✅ File paths now use `system.file()` with fallbacks
5. ✅ `_brand.yml` undefined variable fixed
6. ✅ `cpal_shiny()` deprecated in favor of `cpal_dashboard_theme()`

**Recommended next steps:**

1. Add `brand.yml` to DESCRIPTION Suggests (or Imports if required)
2. Create `inst/brand/` directory and copy `_brand.yml` there
3. Create `inst/scss/` directory and copy `cpal-theme.scss` there
4. Migrate files one at a time, running `devtools::check()` after each
5. Update NAMESPACE with new exports
6. Test the demo app still works after migration
