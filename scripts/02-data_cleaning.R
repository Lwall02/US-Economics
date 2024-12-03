#### Preamble ####
# Purpose: Cleans the raw FRED API and Yale ICF data
# Author: Liam Wall
# Date: 3 Decemeber 2024
# Contact: liam.wall@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(dplyr)
library(arrow)


#### Clean data ####

# Clean FRED API Data
gdp_growth <- read_csv("data/raw_data/gdp_growth_raw.csv") |>
  rename(gdp_growth = value) |>
  select(date, gdp_growth)

unemp <- read_csv("data/raw_data/unemp_raw.csv") |>
  rename(unemp = value) |>
  select(date, unemp)

core_cpi <- read_csv("data/raw_data/core_cpi_raw.csv") |>
  rename(core_cpi = value) |>
  select(date, core_cpi)

vix <- read_csv("data/raw_data/vix_raw.csv") |>
  rename(vix = value) |>
  select(date, vix)

eff_rate <- read_csv("data/raw_data/eff_rate_raw.csv") |>
  rename(eff_rate = value) |>
  select(date, eff_rate)

# Clean Yale ICF data
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

# Join core cpi, gdp, unemp, and vix
economic_data <- core_cpi |>
  left_join(gdp_growth, by = "date") |>
  left_join(unemp, by = "date") |>
  left_join(vix, by = "date") |>
  left_join(eff_rate, "date")

full_data <- economic_data |>
  left_join(one_year_confid, by = "date") |>
  select(-inst_std_error, -ind_std_error)



#### Save data ####
write_csv(full_data, "data/analysis_data/analysis_data.csv")
write_parquet(full_data, "data/analysis_data/analysis_data.parquet")
