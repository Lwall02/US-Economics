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



