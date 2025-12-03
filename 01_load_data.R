# After downloading, unzipping, joining, creating `edx` and `final_holdout_test`...

saveRDS(edx, "edx.rds")
saveRDS(final_holdout_test, "final_holdout_test.rds")