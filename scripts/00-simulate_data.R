#### Preamble ####
# Purpose: Simulates the analysis data of quarterly data on economic variables.
# Author: Liam Wall
# Date: 3 December 2024
# Contact: liam.wall@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(123)

# Define time period from 2000 to 2010 (quarterly data)
time_period <- seq(from = as.Date("2000-01-01"), to = as.Date("2010-10-01"), by = "quarter")
n_quarters <- length(time_period)


# Simulate data for each variable
# 1. Core CPI (inflation rate)
core_cpi <- rnorm(n_quarters, mean = 2, sd = .5) + 0.1 * (1:n_quarters) # Inflation with some upward trend

# 2. GDP Growth Rate
gdp_growth <- rnorm(n_quarters, mean = 2, sd = 1) + ifelse(1:n_quarters < 10, -1, 0) # GDP with a dip in the first years

# 3. Unemployment Rate
unemployment_rate <- rnorm(n_quarters, mean = 6, sd = 2) + sin(1:n_quarters / 2) * 2 # Cyclical unemployment

# 4. Federal Funds Effective Rate
fed_funds_rate <- rnorm(n_quarters, mean = 3, sd = 1) - 0.05 * (1:n_quarters) # Declining Fed Rate

# 5. VIX (Volatility index)
vix <- rnorm(n_quarters, mean = 20, sd = 5) + abs(sin(1:n_quarters / 3)) * 15 # Spikes during crises

# 6. One-Year Confidence Index
confidence_index <- rnorm(n_quarters, mean = 70, sd = 5) + 0.2 * core_cpi + 0.3 * gdp_growth - 0.1 * unemployment_rate # A mix of predictors

# Create a data frame with all variables
economic_data <- data.frame(
  Date = time_period,
  Core_CPI = core_cpi,
  GDP_Growth = gdp_growth,
  Unemployment_Rate = unemployment_rate,
  Fed_Funds_Rate = fed_funds_rate,
  VIX = vix,
  Confidence_Index = confidence_index
)

# View the simulated data
head(economic_data)
