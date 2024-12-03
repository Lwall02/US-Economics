#### Preamble ####
# Purpose: Downloads and saves the data recorded from the FRED API and Yale ICF survey
# Author: Liam Wall
# Date: 3 December 2024
# Contact: liam.wall@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
library(tidyverse)
# Need to have FRED API Key loaded in
library(fredr)

#### Download and Save data ####

# Quarterly Real GDP Growth
gdp_growth <- fredr(
  series_id = "GDPC1",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q",
  units = "pc1"
)
# Save GDP data
write_csv(gdp_growth, "data/raw_data/gdp_growth_raw.csv")

# Quarterly Unemployment Rate
unemp <- fredr(
  series_id = "UNRATE",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
)
# Save Unemployment data
write_csv(unemp, "data/raw_data/unemp_raw.csv")

# Quarterly Core CPI
core_cpi <- fredr(
  series_id = "CPILFESL",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
)
# Save CPI data
write_csv(core_cpi, "data/raw_data/core_cpi_raw.csv")

# Quarterly Market Volatility Index
vix <- fredr(
  series_id = "VIXCLS",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
)
# Save VIX data
write_csv(vix, "data/raw_data/vix_raw.csv")

# Federal Funds Effective Rate
eff_rate <- fredr(
  series_id = "DFF",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
)
# Save Federal Funds Rate data
write_csv(eff_rate, "data/raw_data/eff_rate_raw.csv")

# Download Survey Data
one_year_confid <- read_csv("data/raw_data/icf_stock_market_confidence_index_table.csv")




# Quarterly Real GDP Growth
gdp_growth <- fredr(
  series_id = "GDPC1",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q",
  units = "pc1"
) |>
  rename(gdp_growth = value) |>
  select(date, gdp_growth)

# Quarterly Unemployment Rate
unemp <- fredr(
  series_id = "UNRATE",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
) |>
  rename(unemp_rate = value) |>
  select(date, unemp_rate)

# Quarterly Core CPI
core_cpi <- fredr(
  series_id = "CPILFESL",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
) |>
  rename(core_cpi = value) |>
  select(date, core_cpi)

# Quarterly Market Volatility Index
vix <- fredr(
  series_id = "VIXCLS",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
) |>
  rename(vix = value) |>
  select(date, vix)

# Federal Funds Effective Rate
eff_rate <- fredr(
  series_id = "DFF",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
) |>
  rename(eff_rate = value) |>
  select(date, eff_rate)


# Join core cpi, gdp, unemp, and vix
economic_data <- core_cpi |>
  left_join(gdp_growth, by = "date") |>
  left_join(unemp, by = "date") |>
  left_join(vix, by = "date") |>
  left_join(eff_rate, "date")

# Get the individual and institutional confidence indexes
one_year_confid <- read_csv("data/raw_data/icf_stock_market_confidence_index_table.csv") |>
  rename(date = Date) |>
  rename(inst_index_value = `US Institutional`) |>
  rename(inst_std_error = ...3) |>
  rename(ind_index_value = `US Individual`) |>
  filter(!is.na(date)) |>
  separate(ind_index_value, into = c("ind_index_value", "ind_std_error"), sep = ",")

# Make the correct rows
one_year_confid <- one_year_confid %>%
  mutate(
    month_1 = as.numeric(sub("/.*", "", date)),  # Extract month from 'date'
    year_1 = sub(".*/", "", date),  # Extract year from 'date'
    filtered_date = ifelse(month_1 %in% c(1, 4, 7, 10), 
                           paste(year_1, sprintf("%02d", month_1), "01", sep = "-"), 
                           NA)  # Keep only selected months (1, 4, 7, 10)
  ) |>
  filter(!is.na(filtered_date)) |>
  mutate(filtered_date = as.Date(filtered_date)) |> # Convert to Date type 
  select(filtered_date, inst_index_value, inst_std_error, ind_index_value, ind_std_error) |>
  rename(date = filtered_date)

one_year_confid <- one_year_confid |>
  mutate(
    ind_index_value = if_else(!is.na(ind_index_value), as.numeric(ind_index_value), NA),
    inst_index_value = if_else(!is.na(inst_index_value) ,as.numeric(inst_index_value), NA)
  )

full_data <- economic_data |>
  left_join(one_year_confid, by = "date") |>
  select(-inst_std_error, -ind_std_error)

gdp_ts <- as.ts(gdp_growth$gdp_growth)
plot.ts(as.ts(gdp_ts))

unemp_ts<- as.ts(unemp$unemp_rate)
plot.ts(unemp_ts)

cpi_ts <- as.ts(core_cpi$core_cpi)
plot.ts(cpi_ts)

vix_ts <- as.ts(vix$vix)
plot.ts(vix_ts)

class(Canada)

confidence_individual <- full_data |>
  select(date, ind_index_value)

confidence_institutional <- full_data |>
  select(date, inst_index_value)

dow_data <- fredr(
  series_id = "DJIA",
  observation_start = as.Date("1990-01-01"),
  observation_end = as.Date("2024-01-01"),
  frequency = "q"
) |>
  rename(dow_ia = value) |>
  select(date, dow_ia)







# Assuming you have three data frames: confidence_individual, confidence_institutional, and dow_data

# Merge data by date (assuming each data frame has a 'date' column)
merged_individual <- merge(confidence_individual, dow_data, by = "date") |>
  filter(!is.na(dow_ia))
merged_institutional <- merge(confidence_institutional, dow_data, by = "date") |>
  filter(!is.na(dow_ia))

merged_individual$ind_index_value <- as.numeric(merged_individual$ind_index_value)
merged_individual$dow_ia <- as.numeric(merged_individual$dow_ia)

merged_institutional$inst_index_value <- as.numeric(merged_institutional$inst_index_value)
merged_institutional$dow_ia <- as.numeric(merged_institutional$dow_ia)


# Calculate correlation for US Individual confidence with Dow
cor_individual <- cor(merged_individual$ind_index_value, merged_individual$dow_ia)

# Calculate correlation for US Institutional confidence with Dow
cor_institutional <- cor(merged_institutional$inst_index_value, merged_institutional$dow_ia)

# Print the correlations
cat("Correlation between US Individual confidence and Dow:", cor_individual, "\n")
cat("Correlation between US Institutional confidence and Dow:", cor_institutional, "\n")





# Make the model


model_1 <- stan_glm(inst_index_value ~ core_cpi + gdp_growth + unemp_rate + vix, data = full_data)
summary(model_1)


# Plot residuals
par(mfrow=c(2,2))
plot(model_1)

# Check for multicollinearity (optional)
library(car)
vif(model_1)  # Variance Inflation Factor to check for multicollinearity

# Predicting the US Institutional Confidence
full_data$predicted_confidence <- predict(model_1, newdata = full_data)

# View the first few predictions
head(full_data[, c("inst_index_value", "predicted_confidence")])


# Calculate RMSE (Root Mean Squared Error)
rmse <- sqrt(mean((full_data$inst_index_value - full_data$predicted_confidence)^2))
print(paste("RMSE:", rmse))

# Calculate R-squared
rsq <- summary(model)$r.squared
print(paste("R-squared:", rsq))
