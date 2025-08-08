# analysis_template.R — starter analysis script

# Load core libraries
library(tidyverse)
library(sf)
library(cpaltools)    # CPAL utility functions

# Set up project paths via here()
# data/raw for input, data/processed for output

# Example: read raw data
df_raw <- read_csv(here::here("data", "raw", "your_data.csv"))

# Data cleaning pipeline
df_clean <- df_raw %>%
  filter(!is.na(some_column)) %>%
  mutate(new_var = some_transformation)

# Save processed data
write_rds(df_clean, here::here("data", "processed", "df_clean.rds"))

# End of analysis template
