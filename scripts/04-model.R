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
less_data <- full_data |>
  filter(date >= as.Date("2001-04-01") & date <= as.Date("2020-01-01"))

### Model data ####

# Make each series stationary

# Check stationarity for all variables
adf.test(less_data$gdp_growth)
gdp_diff <- diff(less_data$gdp_growth, differences = 1)
adf.test(gdp_diff)

adf.test(less_data$unemp)
unemp_diff <- diff(less_data$unemp, differences = 1)
adf.test(unemp_diff)
unemp_diff_2 <- diff(less_data$unemp, differences = 2)
adf.test(unemp_diff_2)

adf.test(less_data$core_cpi)
cpi_diff <- diff(less_data$core_cpi, differences = 1)
adf.test(cpi_diff)
cpi_diff_2 <- diff(less_data$core_cpi, differences = 2)
adf.test(cpi_diff_2)

adf.test(less_data$vix)
vix_diff <- diff(less_data$vix, differences = 1)
adf.test(vix_diff)

adf.test(less_data$eff_rate)

adf.test(less_data$inst_index_value)

gdp_diff <- as.ts(gdp_diff)
cpi_diff_2 <- as.ts(cpi_diff_2)
unemp_diff_2 <- as.ts(unemp_diff_2)
vix_diff <- as.ts(vix_diff)
eff_rate <- as.ts(less_data$eff_rate)
inst_conf_index <- as.ts(less_data$inst_index_value)

data_matrix <- cbind(gdp_diff, cpi_diff_2, unemp_diff_2, vix_diff, eff_rate, inst_conf_index)
data_matrix <- na.omit(data_matrix)



model <- VAR(data_matrix)

summary(model)




# Forecast 8 steps ahead (e.g., 2 years of quarterly data)
forecast <- predict(model, n.ahead = 8)

# Extract consumer confidence index forecasts
confidence_forecast <- forecast$fcst$inst_conf_index[, "fcst"]

# Print forecasted values
print(confidence_forecast)





# Calculate RMSE for consumer confidence index
actual <- tail(full_data$inst_index_value, n = 8)  # Replace with test data if available
predicted <- confidence_forecast

rmse <- sqrt(mean((actual - predicted)^2))
print(paste("RMSE:", rmse))
# 7.33




# Without core CPI
data_matrix_2 <- cbind(gdp_diff, unemp_diff_2, vix_diff, eff_rate, inst_conf_index)
data_matrix_2 <- na.omit(data_matrix_2)

model_2 <- VAR(data_matrix_2, type = "trend")
summary(model_2)

# Forecast 8 steps ahead (e.g., 2 years of quarterly data)
forecast_2 <- predict(model_2, n.ahead = 8)

# Extract consumer confidence index forecasts
confidence_forecast_2 <- forecast_2$fcst$inst_conf_index[, "fcst"]

# Print forecasted values
print(confidence_forecast_2)


# Calculate RMSE for consumer confidence index
actual <- tail(full_data$inst_index_value, n = 8)  # Replace with test data if available
predicted_2 <- confidence_forecast_2

rmse_2 <- sqrt(mean((actual - predicted_2)^2))
print(paste("RMSE:", rmse))
# 7.315




# Use VARselect to select the optimal lag length
lag_selection <- VARselect(data_matrix_2, lag.max = 10, type = "const")
print(lag_selection)

# Fit the VAR model with the selected lag order (e.g., based on AIC)
model_3 <- VAR(data_matrix_2, p = lag_selection$selection["AIC(n)"], type = "const")
summary(model)

# Forecast 8 steps ahead (e.g., 2 years of quarterly data)
forecast_3 <- predict(model_3, n.ahead = 8)

# Extract consumer confidence index forecasts
confidence_forecast_3 <- forecast_3$fcst$inst_conf_index[, "fcst"]

# Print forecasted values
print(confidence_forecast_3)

# Calculate RMSE for consumer confidence index
actual <- tail(full_data$inst_index_value, n = 8)  # Replace with test data if available
predicted_3 <- confidence_forecast_3

rmse_3 <- sqrt(mean((actual - predicted_3)^2))
print(paste("RMSE:", rmse))
# 7.315




#### Save model ####
saveRDS(
  model_2,
  file = "models/best_var_model.rds"
)


