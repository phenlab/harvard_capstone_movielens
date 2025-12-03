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
  Downloads/loads the MovieLens data and prepares initial objects.

- `02_eda_and_modeling.R`  
  Exploratory data analysis and stepwise model building (global mean, movie effects, user effects, regularization).

- `final_holdout_test_sets.R`  
  Code used to create the `edx` and `final_holdout_test` partitions, following course specifications.

- `final_holdout_test.rds`  
  Saved holdout set used for final evaluation.

- `harvard_capstone_movielens.Rproj`  
  RStudio project file.

## Reproducing the analysis

1. Open `harvard_capstone_movielens.Rproj` in RStudio.  
2. Install required packages (if needed):

   ```r
   install.packages(c("tidyverse", "dslabs", "caret", "knitr", "rmarkdown"))
