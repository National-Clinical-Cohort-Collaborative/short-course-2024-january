# This file mimics the Enclave Workbook's
#   "Global Code" panel on the right hand side


prepare_dataset <- function(d) {
  d |>
    tibble::as_tibble() |>
    dplyr::mutate(
      data_partner_id        = factor(data_partner_id),
      period_first_covid_dx  = factor_period(period_first_covid_dx),
      covid_severity         = factor_severity(covid_severity),
      age_cut5               = factor_age(age_cut5),
    ) |>
    dplyr::mutate(
      # gender_male            = as.integer(gender_male),
      # smoking_ever           = as.integer(smoking_ever),
      covid_mild_plus        = as.integer(covid_mild_plus),
      covid_moderate_plus    = as.integer(covid_moderate_plus),
      covid_severe_plus      = as.integer(covid_severe_plus),
      covid_dead             = as.integer(covid_dead),
    )
}
factor_period <- function (x) {
  factor(
    x,
    levels = c(
      # "2020H1",
      "2020H2",
      "2021H1", "2021H2",
      "2022H1", "2022H2"
    )
  )
}
factor_severity <- function(x) {
  factor(
    x,
    levels = c(
      "none",
      "mild",
      "moderate",
      "severe",
      "death"
    )
  )
}
factor_age <- function(x) {
  factor(
    x,
    levels = c(
      "2-18",
      "19-50",
      "51-75",
      "76+"
    )
  )
}
