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

#### Read data ####
ces2020 <- read_parquet("data/analysis_data/analysis_data.parquet")

set.seed(853)

ces2020_reduced <- 
  ces2020 |> 
  slice_sample(n = 1000)

### Model data ####
first_model <-
  stan_glm(
    voted_for ~ gender + education,
    data = ces2020_reduced,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 853
  )


#### Save model ####
saveRDS(
  first_model,
  file = "models/first_model.rds"
)


