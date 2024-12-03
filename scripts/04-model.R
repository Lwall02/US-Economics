#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Liam Wall
# Date: 5 March 2024
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(vars)
library(tseries)


#### Read data ####
full_data <- read_parquet("data/analysis_data/analysis_data.parquet")

set.seed(1001)

# Select Times
full_data <- full_data |>
  filter(date >= as.Date("2001-04-01") & date <= as.Date("2020-01-01"))

### Model data ####

# Make each series stationary

# Check stationarity for all variables
adf.test(full_data$gdp_growth)
gdp_diff <- diff(full_data$gdp_growth, differences = 1)
adf.test(gdp_diff)

adf.test(full_data$unemp)
unemp_diff <- diff(full_data$unemp, differences = 1)
adf.test(unemp_diff)
unemp_diff_2 <- diff(full_data$unemp, differences = 2)
adf.test(unemp_diff_2)

adf.test(full_data$core_cpi)
cpi_diff <- diff(full_data$core_cpi, differences = 1)
adf.test(cpi_diff)
cpi_diff_2 <- diff(full_data$core_cpi, differences = 2)
adf.test(cpi_diff_2)

adf.test(full_data$vix)
vix_diff <- diff(full_data$vix, differences = 1)
adf.test(vix_diff)

adf.test(full_data$eff_rate)

adf.test(full_data$inst_index_value)

gdp_diff <- as.ts(gdp_diff)
cpi_diff_2 <- as.ts(cpi_diff_2)
unemp_diff_2 <- as.ts(unemp_diff_2)
vix_diff <- as.ts(vix_diff)
eff_rate <- as.ts(full_data$eff_rate)
inst_conf_index <- as.ts(full_data$inst_index_value)

data_matrix <- cbind(gdp_diff, cpi_diff_2, unemp_diff_2, vix_diff, eff_rate, inst_conf_index)
data_matrix <- na.omit(data_matrix)



model <- VAR(data_matrix)

summary(model)

#### Save model ####
saveRDS(
  model,
  file = "models/var_model.rds"
)


