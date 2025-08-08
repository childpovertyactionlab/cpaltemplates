# _targets.R file for report generation
library(targets)
library(tarchetypes)

# Options
tar_option_set(
  packages = c("tidyverse", "here", "gt", "quarto"),
  format = "qs",
  memory = "transient",
  garbage_collection = TRUE
)

# Source functions
tar_source("R")

# Pipeline
list(
  # Data pipeline
  tar_target(
    raw_data,
    read_csv(here("data-raw", "input.csv"))
  ),
  
  tar_target(
    analysis_data,
    prepare_analysis_data(raw_data)
  ),
  
  # Analysis
  tar_target(
    descriptive_stats,
    calculate_descriptive_stats(analysis_data)
  ),
  
  tar_target(
    main_results,
    run_main_analysis(analysis_data)
  ),
  
  # Visualizations
  tar_target(
    fig_overview,
    create_overview_plot(analysis_data)
  ),
  
  tar_target(
    fig_results,
    create_results_plot(main_results)
  ),
  
  # Report generation
  tar_target(
    report,
    quarto::quarto_render(
      input = here("report.qmd"),
      execute_params = list(
        data = analysis_data,
        stats = descriptive_stats,
        results = main_results,
        fig1 = fig_overview,
        fig2 = fig_results
      )
    )
  )
)

