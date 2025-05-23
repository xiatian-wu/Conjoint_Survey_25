# Estimate multinomial logit (MNL) model_linears

# Load libraries

library(logitr)
library(tidyverse)
library(fastDummies)
library(janitor)
library(here)
options(dplyr.width = Inf) # So you can see all of the columns

# -----------------------------------------------------------------------------
# Load the data set:

pathToData <- here('data', "generated_data.csv")
data <- read_csv(pathToData)
head(data)

#Baseline Price:
data = data %>%
  group_by(respID) %>% 
  mutate(price_diff = price - min(price))


# Estimate MNL model

# Create dummy coded variables
data_dummy <- dummy_cols(
  data, c('powertrain'))
head(data_dummy)

# Clean up names of created variables
data_dummy1 <- clean_names(data_dummy) 


# -----------------------------------------------------------------------------

# Estimate the model
model_linear <- logitr(
  data    = data_dummy1,
  outcome = "choice",
  obsID   = "obs_id",
  pars    = c(
    "price_diff","range", "mileage", "my", "operating_cost",
    "powertrain_electric","powertrain_hybrid" ,"powertrain_plug_in_hybrid")
)


# View summary of results
summary(model_linear)

# Check the 1st order condition: Is the gradient at the solution zero?
model_linear$gradient

# 2nd order condition: Is the hessian negative definite?
# (If all the eigenvalues are negative, the hessian is negative definite)
eigen(model_linear$hessian)$values



# -----------------------------------------------------------------------------
# Save model_linear objects

save(
  model_linear,
  file = here("models", "model_linear.RData")
)

