# _targets.R file for analysis pipeline
library(targets)
library(tarchetypes)

# Options
tar_option_set(
  packages = c("tidyverse", "here", "broom", "gt"),
  format = "qs",
  memory = "transient",
  garbage_collection = TRUE
)

# Source all R scripts
tar_source("R")

# Pipeline
list(
  # Data loading
  tar_target(
    raw_data,
    read_csv(here("data-raw", "input.csv")) %>%
      janitor::clean_names()
  ),
  
  # Data validation
  tar_target(
    data_validation,
    validate_data(raw_data) # Define this function in R/
  ),
  
  # Data cleaning
  tar_target(
    clean_data,
    clean_and_process(raw_data) # Define this function in R/
  ),
  
  # Exploratory analysis
  tar_target(
    eda_plots,
    create_eda_plots(clean_data) # Returns list of plots
  ),
  
  # Statistical models
  tar_target(
    model_results,
    run_models(clean_data) # Define this function in R/
  ),
  
  # Tables for report
  tar_target(
    summary_tables,
    create_summary_tables(clean_data, model_results)
  ),
  
  # Save outputs
  tar_target(
    save_plots,
    save_plots_to_file(eda_plots, here("figures"))
  ),
  
  tar_target(
    save_tables,
    save_tables_to_file(summary_tables, here("tables"))
  )
)

