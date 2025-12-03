library(tidyverse)

edx <- readRDS("edx.rds")
final_holdout_test <- readRDS("final_holdout_test.rds")  # loaded but DO NOT use yet

RMSE <- function(true, pred){
  sqrt(mean((true - pred)^2))
}

set.seed(1)
test_index <- createDataPartition(edx$rating, times = 1, p = 0.2, list = FALSE)

edx_train <- edx[-test_index, ]
edx_test  <- edx[test_index, ]

# Make sure userId and movieId in test are also in train
edx_test <- edx_test %>%
  semi_join(edx_train, by = "movieId") %>%
  semi_join(edx_train, by = "userId")
rmse_results <- tibble(method = character(), RMSE = numeric())

mu_hat <- mean(edx_train$rating)

preds_baseline <- rep(mu_hat, nrow(edx_test))
rmse_baseline  <- RMSE(edx_test$rating, preds_baseline)

rmse_results <- bind_rows(
  rmse_results,
  tibble(method = "Global mean", RMSE = rmse_baseline)
)
rmse_results

# movie effect
movie_avgs <- edx_train %>%
  group_by(movieId) %>%
  summarize(b_i = mean(rating - mu_hat), .groups = "drop")

preds_movie <- edx_test %>%
  left_join(movie_avgs, by = "movieId") %>%
  mutate(pred = mu_hat + b_i) %>%
  pull(pred)

rmse_movie <- RMSE(edx_test$rating, preds_movie)

rmse_results <- bind_rows(
  rmse_results,
  tibble(method = "Movie effect", RMSE = rmse_movie)
)
rmse_results

# movie effect from train
movie_avgs <- edx_train %>%
  group_by(movieId) %>%
  summarize(b_i = mean(rating - mu_hat), .groups = "drop")

# user effect
user_avgs <- edx_train %>%
  left_join(movie_avgs, by = "movieId") %>%
  group_by(userId) %>%
  summarize(u_j = mean(rating - mu_hat - b_i), .groups = "drop")

preds_mu_movie_user <- edx_test %>%
  left_join(movie_avgs, by = "movieId") %>%
  left_join(user_avgs, by = "userId") %>%
  mutate(pred = mu_hat + b_i + u_j) %>%
  pull(pred)

rmse_mu_movie_user <- RMSE(edx_test$rating, preds_mu_movie_user)

rmse_results <- bind_rows(
  rmse_results,
  tibble(method = "Movie + user effects", RMSE = rmse_mu_movie_user)
)
rmse_results

lambdas <- seq(3, 8, 0.5)

rmses <- sapply(lambdas, function(lambda) {
  mu <- mean(edx_train$rating)
  
  b_i <- edx_train %>%
    group_by(movieId) %>%
    summarize(b_i = sum(rating - mu) / (n() + lambda), .groups = "drop")
  
  u_j <- edx_train %>%
    left_join(b_i, by = "movieId") %>%
    group_by(userId) %>%
    summarize(u_j = sum(rating - mu - b_i) / (n() + lambda), .groups = "drop")
  
  preds <- edx_test %>%
    left_join(b_i, by = "movieId") %>%
    left_join(u_j, by = "userId") %>%
    mutate(pred = mu + b_i + u_j) %>%
    pull(pred)
  
  RMSE(edx_test$rating, preds)
})

lambda_best <- lambdas[which.min(rmses)]
lambda_best
min(rmses)

rmse_results <- bind_rows(
  rmse_results,
  tibble(method = paste0("Reg. movie + user (lambda=", lambda_best, ")"),
         RMSE = min(rmses))
)
rmse_results

