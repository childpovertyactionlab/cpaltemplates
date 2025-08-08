
# CPAL Color Palette Examples

library(ggplot2)
library(cpaltemplates)

# Example 1: Basic categorical plot with main palette
ggplot(mpg, aes(class, hwy, fill = class)) +
  geom_boxplot() +
  scale_fill_cpal("main") +
  theme_minimal() +
  labs(title = "Fuel Efficiency by Vehicle Class",
       subtitle = "Using CPAL main categorical palette")

# Example 2: Sequential palette for continuous data
ggplot(mtcars, aes(wt, mpg, color = hp)) +
  geom_point(size = 3) +
  scale_color_cpal("teal_seq", discrete = FALSE) +
  theme_minimal() +
  labs(title = "Weight vs MPG colored by Horsepower",
       subtitle = "Using CPAL teal sequential palette")

# Example 3: Diverging palette for correlation matrix
# Create correlation matrix
cor_data <- mtcars %>%
  select(mpg, hp, wt, qsec) %>%
  cor() %>%
  as.data.frame() %>%
  rownames_to_column("var1") %>%
  pivot_longer(-var1, names_to = "var2", values_to = "correlation")

ggplot(cor_data, aes(var1, var2, fill = correlation)) +
  geom_tile() +
  scale_fill_cpal("blue_red", discrete = FALSE) +
  theme_minimal() +
  labs(title = "Correlation Matrix",
       subtitle = "Using CPAL blue-red diverging palette")

# Example 4: Paired comparison
comparison_data <- data.frame(
  group = rep(c("Before", "After"), each = 50),
  value = c(rnorm(50, 10, 2), rnorm(50, 12, 2))
)

ggplot(comparison_data, aes(group, value, fill = group)) +
  geom_violin() +
  scale_fill_manual(values = cpal_colors(c("teal", "orange"))) +
  theme_minimal() +
  labs(title = "Before/After Comparison",
       subtitle = "Using CPAL teal-orange pair")

# Example 5: Display all palettes
cpal_display_palettes("all")

# Example 6: Get specific colors for manual use
my_colors <- cpal_colors(c("teal", "orange", "navy"))
print(my_colors)

# Example 7: Using with base R plots
barplot(c(10, 20, 15, 25, 30),
        col = cpal_colors("main", n = 5),
        main = "Example with Base R")

