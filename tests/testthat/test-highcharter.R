# Tests for Highcharter theme and helper functions

test_that("hc_theme_cpal_light creates valid theme", {
  skip_if_not_installed("highcharter")

  theme <- hc_theme_cpal_light()
  expect_type(theme, "list")
  expect_true("colors" %in% names(theme))
  expect_true("chart" %in% names(theme))
  expect_true("title" %in% names(theme))
  expect_equal(theme$chart$backgroundColor, "#FFFFFF")
})

test_that("hc_theme_cpal_dark creates valid theme", {
  skip_if_not_installed("highcharter")

  theme <- hc_theme_cpal_dark()
  expect_type(theme, "list")
  expect_true("colors" %in% names(theme))
  expect_true("chart" %in% names(theme))
  expect_equal(theme$chart$backgroundColor, "#1a1a1a")
})

test_that("hc_theme_cpal_switch returns correct theme for mode", {
  skip_if_not_installed("highcharter")

  # Test light mode (default)
  theme_light <- hc_theme_cpal_switch()
  expect_type(theme_light, "list")
  expect_equal(theme_light$chart$backgroundColor, "#FFFFFF")

  # Test light mode explicit
  theme_light2 <- hc_theme_cpal_switch("light")
  expect_equal(theme_light2$chart$backgroundColor, "#FFFFFF")

  # Test dark mode
  theme_dark <- hc_theme_cpal_switch("dark")
  expect_equal(theme_dark$chart$backgroundColor, "#1a1a1a")

  # Test NULL mode defaults to light
  theme_null <- hc_theme_cpal_switch(NULL)
  expect_equal(theme_null$chart$backgroundColor, "#FFFFFF")

  # Test FALSE mode defaults to light
  theme_false <- hc_theme_cpal_switch(FALSE)
  expect_equal(theme_false$chart$backgroundColor, "#FFFFFF")
})

test_that("hc_theme_cpal_light accepts parameters", {
  skip_if_not_installed("highcharter")

  # Test base_size
  theme <- hc_theme_cpal_light(base_size = 16)
  expect_type(theme, "list")

  # Test grid options
  theme_h <- hc_theme_cpal_light(grid = "horizontal")
  expect_equal(theme_h$yAxis$gridLineWidth, 1)
  expect_equal(theme_h$xAxis$gridLineWidth, 0)

  theme_v <- hc_theme_cpal_light(grid = "vertical")
  expect_equal(theme_v$yAxis$gridLineWidth, 0)
  expect_equal(theme_v$xAxis$gridLineWidth, 1)

  theme_both <- hc_theme_cpal_light(grid = "both")
  expect_equal(theme_both$yAxis$gridLineWidth, 1)
  expect_equal(theme_both$xAxis$gridLineWidth, 1)

  theme_none <- hc_theme_cpal_light(grid = "none")
  expect_equal(theme_none$yAxis$gridLineWidth, 0)
  expect_equal(theme_none$xAxis$gridLineWidth, 0)

  # Test legend position
  theme_right <- hc_theme_cpal_light(legend_position = "right")
  expect_equal(theme_right$legend$align, "right")
  expect_equal(theme_right$legend$layout, "vertical")

  # Test credits
  theme_credits <- hc_theme_cpal_light(show_credits = TRUE)
  expect_true(theme_credits$credits$enabled)
})

test_that("hc_colors_cpal applies colors to chart", {
  skip_if_not_installed("highcharter")

  hc <- highcharter::highchart()
  hc_colored <- hc_colors_cpal(hc, "main")
  expect_true(length(hc_colored$x$hc_opts$colors) > 0)

  # Test different palettes
  hc_seq <- hc_colors_cpal(hc, "sequential")
  expect_true(length(hc_seq$x$hc_opts$colors) > 0)

  hc_div <- hc_colors_cpal(hc, "diverging")
  expect_true(length(hc_div$x$hc_opts$colors) > 0)

  # Test reverse
  hc_rev <- hc_colors_cpal(hc, "main", reverse = TRUE)
  main_colors <- cpal_colors("main")
  expect_equal(hc_rev$x$hc_opts$colors[1], unname(rev(main_colors)[1]))

  # Test n parameter
  hc_n <- hc_colors_cpal(hc, "main", n = 3)
  expect_equal(length(hc_n$x$hc_opts$colors), 3)
})

test_that("hc_colorAxis_cpal configures color axis", {
  skip_if_not_installed("highcharter")

  hc <- highcharter::highchart()

  # Test sequential
  hc_seq <- hc_colorAxis_cpal(hc, "sequential")
  expect_true("colorAxis" %in% names(hc_seq$x$hc_opts))

  # Test diverging
  hc_div <- hc_colorAxis_cpal(hc, "diverging")
  expect_true("colorAxis" %in% names(hc_div$x$hc_opts))

  # Test min/max
  hc_mm <- hc_colorAxis_cpal(hc, "sequential", min = 0, max = 100)
  expect_equal(hc_mm$x$hc_opts$colorAxis$min, 0)
  expect_equal(hc_mm$x$hc_opts$colorAxis$max, 100)
})

test_that("hc_cpal_number_format sets global options", {
  skip_if_not_installed("highcharter")

  # Call the function
  hc_cpal_number_format()

  # Check options were set
  lang_opts <- getOption("highcharter.lang")
  expect_equal(lang_opts$thousandsSep, ",")
  expect_equal(lang_opts$decimalPoint, ".")
})

test_that("hc_tooltip_cpal configures tooltip", {
  skip_if_not_installed("highcharter")

  hc <- highcharter::highchart()

  # Test basic tooltip
  hc_tip <- hc_tooltip_cpal(hc, decimals = 2)
  expect_true("tooltip" %in% names(hc_tip$x$hc_opts))

  # Test with prefix and suffix
  hc_tip2 <- hc_tooltip_cpal(hc, prefix = "$", suffix = "K")
  expect_true("tooltip" %in% names(hc_tip2$x$hc_opts))

  # Test with custom point_format
  hc_tip3 <- hc_tooltip_cpal(hc, point_format = "Custom: {point.y}")
  expect_equal(hc_tip3$x$hc_opts$tooltip$pointFormat, "Custom: {point.y}")
})

test_that("hc_yaxis_cpal configures y-axis", {
  skip_if_not_installed("highcharter")

  hc <- highcharter::highchart()

  # Test with title
  hc_y <- hc_yaxis_cpal(hc, title = "My Axis")
  expect_true("yAxis" %in% names(hc_y$x$hc_opts))
  expect_equal(hc_y$x$hc_opts$yAxis$title$text, "My Axis")

  # Test with formatter
  hc_y2 <- hc_yaxis_cpal(hc, decimals = 2, prefix = "$")
  expect_true("labels" %in% names(hc_y2$x$hc_opts$yAxis))
})

test_that("hc_linetype_cpal modifies line type", {
  skip_if_not_installed("highcharter")

  # Create a simple line chart
  hc <- highcharter::highchart() |>
    highcharter::hc_add_series(data = 1:5, type = "line")

  # Test curved (spline)
  hc_curved <- hc_linetype_cpal(hc, curved = TRUE)
  expect_equal(hc_curved$x$hc_opts$series[[1]]$type, "spline")

  # Test straight (line)
  hc_straight <- hc_linetype_cpal(hc, curved = FALSE)
  expect_equal(hc_straight$x$hc_opts$series[[1]]$type, "line")
})

test_that("hc_cpal_theme applies theme and sets number format", {
  skip_if_not_installed("highcharter")

  hc <- highcharter::highchart()

  # Test light mode - theme should be applied
  hc_themed <- hc_cpal_theme(hc)
  expect_s3_class(hc_themed, "highchart")

  # Test dark mode
  hc_dark <- hc_cpal_theme(hc, "dark")
  expect_s3_class(hc_dark, "highchart")

  # Check that number format options were set
  lang_opts <- getOption("highcharter.lang")
  expect_equal(lang_opts$thousandsSep, ",")
})

test_that("hc_histogram_cpal creates histogram", {
  skip_if_not_installed("highcharter")

  data <- rnorm(100)
  hc <- hc_histogram_cpal(data)

  expect_s3_class(hc, "highchart")
  expect_true(length(hc$x$hc_opts$series) > 0)
})

test_that("hc_lollipop_cpal creates lollipop chart", {
  skip_if_not_installed("highcharter")

  categories <- c("A", "B", "C")
  values <- c(10, 20, 15)

  hc <- hc_lollipop_cpal(categories, values)

  expect_s3_class(hc, "highchart")
  # Should have 2 series (stems + dots)
  expect_equal(length(hc$x$hc_opts$series), 2)
})

test_that("hc_dumbbell_cpal creates dumbbell chart", {
  skip_if_not_installed("highcharter")

  categories <- c("A", "B", "C")
  values_start <- c(10, 20, 15)
  values_end <- c(15, 25, 12)

  hc <- hc_dumbbell_cpal(categories, values_start, values_end)

  expect_s3_class(hc, "highchart")
  # Should have 3 series (connector + start dots + end dots)
  expect_equal(length(hc$x$hc_opts$series), 3)
})

test_that("get_cpal_logo_base64 returns logo or NULL", {
  # This function might return NULL if base64enc is not installed
  # or if logo files don't exist, so just test it doesn't error

  result_light <- get_cpal_logo_base64("light")
  expect_true(is.null(result_light) || is.character(result_light))

  result_dark <- get_cpal_logo_base64("dark")
  expect_true(is.null(result_dark) || is.character(result_dark))
})

test_that("hc_add_cpal_logo adds logo to chart", {
  skip_if_not_installed("highcharter")
  skip_if_not_installed("base64enc")

  hc <- highcharter::highchart()
  hc_with_logo <- hc_add_cpal_logo(hc)

  # Chart should have events defined if logo was added
  # If logo couldn't be loaded, should still return chart unchanged
  expect_s3_class(hc_with_logo, "highchart")
})
