![Made with R](https://img.shields.io/badge/Made%20with-R-blue)

## Quick Start

This project builds a simple but effective movie recommendation system using the MovieLens 10M dataset.  
The final regularized movie + user effects model achieves an RMSE of **0.8648** on the untouched `final_holdout_test` set.

# HarvardX Data Science Capstone – MovieLens 10M

This repository contains my HarvardX Data Science Capstone project, using the MovieLens 10M dataset to build and evaluate a movie recommendation system.

## Project structure

- `movielens_report.Rmd`  
  Main R Markdown report. Knit this file to reproduce the analysis and results.

- `movielens_report.pdf`  
  Rendered version of the report.

- `movielens_model.R`  
  Script required by the course. Fits the final regularized movie + user effects model on the full `edx` set and evaluates it on `final_holdout_test`.

- `01_load_data.R`  
  Loads and prepares the MovieLens data.

- `02_eda_and_modeling.R`  
  Exploratory analysis and stepwise model building (global mean → movie effects → user effects → regularization).

- `final_holdout_test_sets.R`  
  Code used to create the `edx` and `final_holdout_test` partitions.

- `final_holdout_test.rds`  
  Saved holdout set used for final evaluation.

- `harvard_capstone_movielens.Rproj`  
  RStudio project file.

## Reproducing the analysis

1. Open the project in RStudio by double-clicking `harvard_capstone_movielens.Rproj`.

2. Install required packages if they are not already installed:

   ```r
   install.packages(c("tidyverse", "dslabs", "caret", "knitr", "rmarkdown"))
   ```

3. Knit the main report:

   ```r
   rmarkdown::render("movielens_report.Rmd")
   ```

4. Run the final evaluation (the script used for submission):

   ```r
   source("movielens_model.R")
   ```

The final model (regularized movie + user effects) achieves an RMSE of approximately **0.8648** on the `final_holdout_test` set.

