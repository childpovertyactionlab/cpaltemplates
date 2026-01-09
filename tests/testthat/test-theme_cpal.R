# Tests for theme_cpal and related functions

test_that("theme_cpal creates valid theme", {
  library(ggplot2)

  # Test basic theme creation
  theme <- theme_cpal()
  expect_s3_class(theme, "theme")
  expect_s3_class(theme, "gg")

  # Test theme variants
  expect_s3_class(theme_cpal_minimal(), "theme")
  expect_s3_class(theme_cpal_dark(), "theme")
  expect_s3_class(theme_cpal_map(), "theme")
  expect_s3_class(theme_cpal_print(), "theme")
})

test_that("theme_cpal_switch returns correct theme for mode", {
  library(ggplot2)

  # Test light mode (default)
  theme_light <- theme_cpal_switch()
  expect_s3_class(theme_light, "theme")
  expect_s3_class(theme_light, "gg")

  # Test light mode explicit
  theme_light2 <- theme_cpal_switch("light")
  expect_s3_class(theme_light2, "theme")

  # Test dark mode
  theme_dark <- theme_cpal_switch("dark")
  expect_s3_class(theme_dark, "theme")

  # Test NULL mode defaults to light
  theme_null <- theme_cpal_switch(NULL)
  expect_s3_class(theme_null, "theme")
})

test_that("theme_cpal thematic parameter works", {
  library(ggplot2)

  # Test thematic parameter creates valid theme
  theme_auto <- theme_cpal(thematic = TRUE)
  expect_s3_class(theme_auto, "theme")
  expect_s3_class(theme_auto, "gg")
})

test_that("theme_cpal_auto is deprecated but still works", {
  library(ggplot2)

  # Test theme_cpal_auto still works (with deprecation warning)
  expect_warning(
    theme_auto <- theme_cpal_auto(),
    "deprecated"
  )
  expect_s3_class(theme_auto, "theme")
  expect_s3_class(theme_auto, "gg")
})

test_that("theme_cpal parameters work correctly", {
  # Test different styles
  expect_s3_class(theme_cpal(style = "minimal"), "theme")
  expect_s3_class(theme_cpal(style = "classic"), "theme")
  expect_s3_class(theme_cpal(style = "dark"), "theme")

  # Test grid options
  expect_s3_class(theme_cpal(grid = FALSE), "theme")
  expect_s3_class(theme_cpal(grid = "horizontal"), "theme")
  expect_s3_class(theme_cpal(grid = "vertical"), "theme")
})

test_that("save_cpal_plot handles size presets", {
  skip_if_not_installed("ggplot2")

  # Create temp plot
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()

  # Test size validation
  expect_error(save_cpal_plot(p, "test.png", size = "invalid"))

  # Test numeric size
  tmp <- tempfile(fileext = ".png")
  save_cpal_plot(p, tmp, size = c(6, 4))
  expect_true(file.exists(tmp))
  unlink(tmp)
})

test_that("color scale extensions work", {
  skip_if_not_installed("ggplot2")

  # Test scale creation
  expect_s3_class(scale_color_cpal_c(), "Scale")
  expect_s3_class(scale_fill_cpal_c(), "Scale")
  expect_s3_class(scale_color_cpal_d(), "Scale")
  expect_s3_class(scale_fill_cpal_d(), "Scale")
})

test_that("cpal_table creates gt object", {
  skip_if_not_installed("gt")

  tbl <- cpal_table(mtcars[1:5, 1:3])
  expect_s3_class(tbl, "gt_tbl")
})
