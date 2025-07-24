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
