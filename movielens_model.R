############################################################
# MovieLens Project - Final Model Script
# Author: Paul Henderson
#
# This script:
#  1. Loads the prepared edx and final_holdout_test datasets
#  2. Fits a regularized movie + user effects model on all of edx
#  3. Predicts ratings for final_holdout_test
#  4. Computes and prints the final RMSE
############################################################

# Load required packages
library(tidyverse)

# Load data ---------------------------------------------------------------

edx <- readRDS("edx.rds")
final_holdout_test <- readRDS("final_holdout_test.rds")

# Sanity check: make sure all userId and movieId in final_holdout_test
# exist in edx (this was enforced when creating the sets, but we keep it explicit)
final_holdout_test <- final_holdout_test %>%
  semi_join(edx, by = "movieId") %>%
  semi_join(edx, by = "userId")

# Define RMSE -------------------------------------------------------------

RMSE <- function(true, pred){
  sqrt(mean((true - pred)^2))
}

# Final model: Regularized movie + user effects --------------------------
# Lambda was selected using an internal edx train/test split in the analysis:
lambda <- 5

# Global mean rating
mu <- mean(edx$rating)

# Regularized movie effects (b_i)
movie_effects <- edx %>%
  group_by(movieId) %>%
  summarize(
    b_i = sum(rating - mu) / (n() + lambda),
    .groups = "drop"
  )

# Regularized user effects (u_j)
user_effects <- edx %>%
  left_join(movie_effects, by = "movieId") %>%
  group_by(userId) %>%
  summarize(
    u_j = sum(rating - mu - b_i) / (n() + lambda),
    .groups = "drop"
  )

# Generate predictions on final_holdout_test -----------------------------

predictions <- final_holdout_test %>%
  left_join(movie_effects, by = "movieId") %>%
  left_join(user_effects, by = "userId") %>%
  mutate(pred = mu + b_i + u_j) %>%
  pull(pred)

# Compute final RMSE ------------------------------------------------------

final_rmse <- RMSE(final_holdout_test$rating, predictions)

# Print the RMSE
cat("Final RMSE on final_holdout_test:", final_rmse, "\n")
