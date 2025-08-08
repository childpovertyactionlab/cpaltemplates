# _targets.R file
library(targets)
library(tarchetypes)

# Set target options
tar_option_set(
  packages = c("tidyverse", "here"),
  format = "qs", # Faster than RDS
  memory = "transient",
  garbage_collection = TRUE
)

# Source R functions
tar_source("R")

# Define targets
list(
  # Load raw data
  tar_target(
    raw_data,
    read_csv(here("data-raw", "input.csv"))
  ),
  
  # Process data
  tar_target(
    processed_data,
    raw_data %>%
      # Add your processing steps here
      mutate(across(where(is.character), as.factor))
  ),
  
  # Create summary
  tar_target(
    data_summary,
    processed_data %>%
      summarise(
        n = n(),
        across(where(is.numeric), list(mean = mean, sd = sd), na.rm = TRUE)
      )
  ),
  
  # Save outputs
  tar_target(
    save_summary,
    write_csv(data_summary, here("outputs", "summary_stats.csv"))
  )
)

