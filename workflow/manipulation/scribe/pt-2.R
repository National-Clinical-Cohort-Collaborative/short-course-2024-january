# knitr::stitch_rmd(script="manipulation/mlm-scribe.R", output="stitched-output/manipulation/mlm-scribe.md")
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# source("manipulation/osdh/ellis/common-ellis.R")
# base::source(file="Dal/Osdh/Arch/benchmark-client-program-arch.R") #Load retrieve_benchmark_client_program
base::source("manipulation/common.R")

# ---- load-packages -----------------------------------------------------------
# import::from("magrittr", "%>%")
requireNamespace("tibble")
requireNamespace("readr"                      )  # remotes::install_github("tidyverse/readr")
requireNamespace("dplyr"                      )
requireNamespace("checkmate"                  )
requireNamespace("testit"                     )
requireNamespace("config"                     )
# requireNamespace("OuhscMunge"                 )   # remotes::install_github("OuhscBbmc/OuhscMunge")
# requireNamespace("RcppRoll")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()

sql <- readr::read_file("manipulation/scribe/pt-2.sql")

# ---- load-data ---------------------------------------------------------------
ds <- retrieve_duckdb(sql)
# ds <- retrieve_sqlite(sql)

checkmate::assert_data_frame(ds           , min.rows = 100)
rm(sql)

# ---- tweak-data --------------------------------------------------------------
dim(ds)
ds <-
  ds |>
  tibble::as_tibble() |>
  dplyr::mutate(
    # When reading from SQLite, there are some data types that need to be cast explicitly.  SQL Server and the 'odbc' package handles dates and bits/logicals naturally.
    person_id           = factor(person_id),
    data_partner_id     = factor(data_partner_id),
    # birth_date          = as.Date(birth_datetime),
    # covid_date          = as.Date(covid_date),
    # age_80_plus       = as.logical(age_80_plus),
  )
dim(ds)

# # ---- collapse-to-county ------------------------------------------------------
# ds_county <-
#   ds |>
#   dplyr::group_by(county_id, county) |>
#   dplyr::summarize(
#     cog_1_mean      = mean(cog_1    , na.rm=T),
#     cog_2_mean      = mean(cog_2    , na.rm=T),
#     cog_3_mean      = mean(cog_3    , na.rm=T),
#     phys_1_mean     = mean(phys_1   , na.rm=T),
#     phys_2_mean     = mean(phys_2   , na.rm=T),
#     phys_3_mean     = mean(phys_3   , na.rm=T)
#   ) |>
#   dplyr::ungroup()
#
# # ---- collapse-to-county-year ------------------------------------------------------
# ds_county_year <-
#   ds |>
#   dplyr::group_by(county_id, county, year) |>
#   dplyr::summarize(
#     cog_1_mean      = mean(cog_1    , na.rm = TRUE),
#     cog_2_mean      = mean(cog_2    , na.rm = TRUE),
#     cog_3_mean      = mean(cog_3    , na.rm = TRUE),
#     phys_1_mean     = mean(phys_1   , na.rm = TRUE),
#     phys_2_mean     = mean(phys_2   , na.rm = TRUE),
#     phys_3_mean     = mean(phys_3   , na.rm = TRUE)
#   ) |>
#   dplyr::ungroup()
#
#
# # ---- inspect -----------------------------------------------------------------
# message(
#   "Row Count          : ", scales::comma(nrow(ds)), "\n",
#   "Unique patients    : ", scales::comma(dplyr::n_distinct(ds$patient_id)), "\n",
#   "Unique waves       : ", scales::comma(dplyr::n_distinct(ds$wave_id       )), "\n",
#   "Unique counties    : ", scales::comma(dplyr::n_distinct(ds$county_id       )), "\n",
#   "Unique years       : ", scales::comma(dplyr::n_distinct(ds$year    )), "\n",
#   "Year range         : ", sprintf("%i ", range(ds$year)), "\n",
#   # "Year range         : ", strftime(range(ds_program_month$month), "%Y-%m-%d  "), "\n",
#   sep=""
# )
# ds |>
#   dplyr::count(county_id) |>
#   dplyr::mutate(n = scales::comma(n)) |>
#   tidyr::spread(county_id, n)
#
# ds |>
#   dplyr::summarize(
#     dplyr::across(
#       .cols = tidyselect::everything(),
#       .fns  = ~round(mean(is.na(.) | as.character(.) == "Unknown"), 3)
#     )
#   ) |>
#   tidyr::pivot_longer(tidyselect::everything()) |>
#   print(n = 200)

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

ds_slim <-
  ds |>
  dplyr::select(
    person_id,
    data_partner_id,
    gender_concept_id,
    year_of_birth,
    # month_of_birth,
    # day_of_birth,
    birth_date,
    race_concept_id,
    ethnicity_concept_id,
    location_id,
    provider_id,
    care_site_id,
    # person_source_value,
    gender_source_value,
    gender_source_concept_id,
    race_source_value,
    race_source_concept_id,
    ethnicity_source_value,
    ethnicity_source_concept_id,
    covid_date,
    covid_severity,
    dx_bird,
    calc_outbreak_lag_years,
    calc_age_covid,
    length_of_stay,
    latent_risk_1,
    latent_risk_2_int,
    latent_risk_2_slope,
    latent_risk_3,
    school_close,
    school_closed_duration,
    school_reopen,
  )
ds_slim

# ---- save-to-disk ------------------------------------------------------------
fs::dir_create(fs::path_dir(config$path_analysis_pt_2_csv     ))  # Ensure containing directory exists
fs::dir_create(fs::path_dir(config$path_analysis_pt_2_parquet ))  # Ensure containing directory exists

readr::write_csv(     ds_slim   , config$path_analysis_pt_2_csv)
arrow::write_parquet( ds_slim   , config$path_analysis_pt_2_parquet)
# readr::write_rds(     ds_slim   , config$path_analysis_pt_2_rds          , compress = "gz")
