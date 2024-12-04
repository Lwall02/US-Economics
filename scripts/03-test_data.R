#### Preamble ####
# Purpose: Tests the analysis data after cleaning
# Author: Liam Wall
# Date: 3 December 2024
# Contact: liam.wall@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download the analysis data from data/analysis_data


#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(lubridate)
library(testthat)

#### Test data ####
data <- read_csv("data/analysis_data/analysis_data.csv")

# Define the tests
test_results <- list()

# 1. Test if all required columns are numeric
test_results$numeric_columns <- test_that("All numeric columns are numeric", {
  numeric_columns <- c("core_cpi", "gdp_growth", "unemp", "eff_rate", "vix", "inst_index_value")
  expect_true(all(sapply(data[numeric_columns], is.numeric)))
})

# 2. Test if date column is in the correct format and range
test_results$date <- test_that("Date column is correct and within range", {
  expect_true("date" %in% names(data))
  expect_true(all(!is.na(as.Date(data$date)))) # Check valid dates
  date_range <- range(as.Date(data$date))
  expect_true(date_range[1] >= as.Date("1989-01-01"))
  expect_true(date_range[2] <= Sys.Date()) # Dates should not exceed today
})

# 3. Test for missing values
test_results$critical_columns <- test_that("No missing values in critical columns", {
  critical_columns <- c("core_cpi", "gdp_growth", "unemp", "eff_rate", "vix", "date")
  expect_true(all(complete.cases(data[critical_columns])))
})

# 4. Test for unexpected zeros in key columns
test_results$unexpected_zeros <- test_that("No unexpected zeros in key columns", {
  key_columns <- c("Core_CPI", "GDP_Growth", "Unemployment_Rate", "Fed_Funds_Rate", "VIX")
  for (col in key_columns) {
    expect_true(all(data[[col]] != 0))
  }
})

# 5. Test if column values are within reasonable ranges
test_results$value_ranges <- test_that("Column values are within reasonable ranges", {
  expect_true(all(data$core_cpi >= 0 & data$core_cpi <= 320))
  expect_true(all(data$gdp_growth >= -10 & data$gdp_growth <= 13))
  expect_true(all(data$unemp >= 0 & data$unemp <= 25))
  expect_true(all(data$eff_rate >= 0 & data$eff_rate <= 20))
  expect_true(all(data$vix >= 0 & data$vix <= 100))
})

# 6. Test for duplicated rows
test_results$duplicates <- test_that("No duplicated rows exist", {
  expect_true(nrow(data) == nrow(distinct(data)))
})
