# knitr::stitch_rmd(script="manipulation/simulation/simulate-mlm-1.R", output="stitched-output/manipulation/simulation/simulate-mlm-1.md") # dir.create("stitched-output/manipulation/simulation", recursive=T)
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("manipulation/common.R")

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# library("ggplot2")

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr"        )
requireNamespace("tidyr"        )
requireNamespace("arrow"        ) # Writing/saving parquet files
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("rlang"        ) # Language constructs, like quosures
requireNamespace("testit"       ) # For asserting conditions meet expected patterns/conditions.
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
# requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()
set.seed(453)

pt_count       <- 100
# wave_count          <- 10
#
# possible_age_start  <- 55:75
# possible_county_id  <- c(51L, 55L, 72L)
# possible_county_index  <- seq_along(possible_county_id)
# possible_gender_id     <- c(1L, 2L, 255L)
# possible_race          <- c(
#   "American Indian/Alaska Native",
#   "Asian",
#   "Native Hawaiian or Other Pacific Islander",
#   "Black or African American",
#   "White",
#   "More than One Race",
#   "Unknown or Not Reported"
# )
# possible_ethnicity <- c(
#   "Not Hispanic or Latino",
#   "Hispanic or Latino",
#   "Unknown/Not Reported Ethnicity"
# )
# possible_date_offset    <- 30:120   # Add between 30 & 120 days to Jan 1, to get the exact visit date.

# "p" stands for probability
# p_site   <- c("1" = .38, "2" = .62)
p_gender <- c("8532" = .6, "8507" = .4) # male & female; https://athena.ohdsi.org/search-terms/terms?domain=Gender

# "u" stands for universe
# u_birth_date <- seq.Date(as.Date("1930-01-01"), as.Date("2017-12-31"), by = "day")

# OuhscMunge::readr_spec_aligned(config$path_metadata_concept_simulate) #remotes::install_github("OuhscBbmc/OuhscMunge")
col_types_concept <- readr::cols_only(
  `category`                      = readr::col_character(),
  `concept_id`                    = readr::col_integer(),
  `concept_name`                  = readr::col_character(),
  `probability_within_category`   = readr::col_double()
)

manifest_severity_covid <- function (x) {
  cut(
    x       = x,
    breaks  = c(-Inf,  1.0,     2.0,       3.0,      4.0,     Inf),
    labels  = c(  "none", "mild", "moderate", "severe", "dead")
  )
}
manifest_severity_dx_bird <- function (x) {
  cut(
    x       = x,
    breaks  = c(-Inf,           -2,               0,             Inf),
    labels  = c(  "chicken_peck", "chicken_struck", "duck_struck")
  )
}

site_count <- 3L
# # covid_start_site <-
#   p_site |>
#     names() |>
#     as.integer() |>
#     purrr::

# int_county          <- c(2, 2.1, 4)
# slope_county        <- c(-.04, -.06, -.2)
#
# cor_factor_1_vs_2   <- c(.3, .005)          # Int & slope
# loadings_factor_1   <- c(.4, .5, .6)
# loadings_factor_2   <- c(.3, .4, .1)
# sigma_factor_1      <- c(.1, .2, .1)
# sigma_factor_2      <- c(.2, .3, .5)

# ---- load-data ---------------------------------------------------------------
ds_concept      <- retrieve_duckdb("SELECT * FROM concept")
ds_nation_count <- retrieve_duckdb("SELECT * FROM date_nation_latent")

checkmate::assert_tibble(ds_concept       , min.rows = 4)
checkmate::assert_tibble(ds_nation_count  , min.rows = 4)

# ---- tweak-data --------------------------------------------------------------
ds_concept <-
  ds_concept |>
  tibble::as_tibble()

# ---- site --------------------------------------------------------------------
ds_site <-
  site_count |>
  seq_len() |>
  tibble::tibble(data_partner_id = _) |>
  dplyr::mutate(
    covid_start_site      = config$covid_start_nation + runif(site_count, min = 0, max = 45),
    site_relative_size    = round(rchisq(site_count, 5)               , 4),
    site_int              = round(rbeta(site_count, 4.4, 4.4) - .5    , 4),
    site_slope            = round(rbeta(site_count, .4, 1.4) - .1     , 4),

    school_close = covid_start_site + runif(site_count, min = 0, max = 45),
    school_closed_duration = 104 + round(rchisq(site_count, 4)               , 0),
    school_reopen          = school_close + school_closed_duration,
    # TODO: add `school_close`  date  --runif (similar to `covid_start_site`)
    # TODO: add `school_closed_duration`  (number of days closed) --rchisq(df = 4)
    # TODO: add `school_reopen` date
  )

# hist(rbeta(1000, 4.4, 4.4) - .5, breaks = 40)
# hist(c(0, rchisq(1000, 3.5) + 2), breaks = 40)
# mean(c(0, rchisq(1000, 3.5) + 2))

# ---- person ----------------------------------------------------------------
ds_person_site <-
  ds_site |>
  dplyr::slice_sample(weight_by = site_relative_size, n = pt_count, replace = TRUE) |>
  dplyr::mutate(
    person_id         = factor(10*pt_count + seq_len(pt_count))
  ) |>
  dplyr::select(
    person_id,
    data_partner_id,
    tidyselect::everything()
  )

ds_person <-
  ds_person_site |>
  dplyr::mutate(
    gender_concept_id = as.integer(sample(names(p_gender      ), prob = p_gender      , size = pt_count, replace = TRUE)),
  ) |>
  dplyr::mutate(
    latent_dob_lag    = rbeta(n = pt_count, shape1 = 1, shape2 = 1.9, ncp = 7/8),
    birth_date        = config$boundary_date_max - 40000 * latent_dob_lag,
    year_of_birth     = as.integer(lubridate::year(birth_date)),
    month_of_birth    = as.integer(lubridate::month(birth_date)),
    day_of_birth      = as.integer(lubridate::day(birth_date)),
  ) |>
  dplyr::mutate(
    covid_date              = sample(ds_nation_count$date, prob = ds_nation_count$pt_count, size = pt_count, replace = TRUE),
    calc_outbreak_lag_years = round(as.integer(difftime(covid_date, config$covid_start_nation, units = "days")) / 365.25, 2),
    calc_age_covid          = round(as.integer(difftime(covid_date, birth_date, units = "days")) / 365.25, 2),
  ) |>
  dplyr::mutate(
    latent_risk_1 =
      .2 +
      (1 * site_int) +
      (.005 * site_slope * calc_outbreak_lag_years) +
      (-0.5 * calc_outbreak_lag_years) +
      (.04 * calc_age_covid) +
      rnorm(pt_count, sd = 1.3),
    latent_risk_1   = round(latent_risk_1, 3),
    covid_severity  = manifest_severity_covid(latent_risk_1 + rnorm(pt_count, sd = .8)),
    length_of_stay  = as.integer(latent_risk_1^2 + rchisq(pt_count, 4)) + 1L,
  ) |>
  dplyr::mutate(
    latent_risk_2_int   = rchisq(pt_count, 3.5) + 2,
    latent_risk_2_slope = rnorm(pt_count, mean = 0, sd = .5),
  ) |>
  dplyr::mutate(
    latent_risk_3   = latent_risk_1 + rnorm(pt_count, sd = .4),
    latent_risk_3   = round(latent_risk_3, 3),
    dx_bird         = manifest_severity_dx_bird(latent_risk_3 + rnorm(pt_count, sd = .8)),
  ) |>
  dplyr::mutate(
    race_concept_id           = 0L,
    ethnicity_concept_id      = 0L,
  ) |>
  dplyr::select(
    person_id,
    data_partner_id,
    gender_concept_id,
    year_of_birth,
    month_of_birth,
    day_of_birth,
    birth_datetime    = birth_date,
    # death_datetime,
    race_concept_id,
    ethnicity_concept_id,
    # location_id,
    # provider_id,
    # care_site_id,
    # person_source_value,
    # gender_source_value,
    # gender_source_concept_id,
    # race_source_value,
    # race_source_concept_id,
    # ethnicity_source_value,
    # ethnicity_source_concept_id,
    covid_date,
    latent_risk_1,
    latent_risk_2_int,
    latent_risk_2_slope,
    latent_risk_3,
    covid_severity,
    dx_bird,
    calc_outbreak_lag_years,
    calc_age_covid,
    length_of_stay,
  )
hist(ds_person$latent_risk_3)

# plot(ds_person$dx_bird, ds_person$latent_risk_3)
# plot(ds_person$dx_bird, ds_person$covid_severity)

summary(lm(latent_risk_1 ~ 1 + calc_outbreak_lag_years + calc_age_covid, data = ds_person))
summary(glm(covid_severity ~ 1 + calc_outbreak_lag_years + calc_age_covid, family = binomial, data = ds_person))
# stop()
# https://www.npr.org/sections/health-shots/2020/09/01/816707182/map-tracking-the-spread-of-the-coronavirus-in-the-u-s

# x <- rchisq(n = 100000, df = 12, ncp = 100)
# x <- rt(n = 100000, df = 20, ncp = 0)
# x <- rweibull(n = 100000, shape = 2)
# x <- rgamma(n = 100000, shape = 500, rate = 2)
# x <- rbeta(n = 100000, shape1 = 1, shape2 = 1.9, ncp = 7/8)
# hist(x)
#
# boundary_date_max <- as.Date("2022-12-31")
# dob2 <- boundary_date - 40000 * x
# hist(lubridate::year(dob2))


# ---- dx ----------------------------------------------------------------------


ds_person |>
  dplyr::select(
    person_id,
    covid_date,
    dx_bird,
  )


# ---- join-concepts -----------------------------------------------------------
sql_person_slim <-
  "
    SELECT
      p.person_id
      -- ,p.data_partner_id
      ,p.gender_concept_id
      ,p.year_of_birth
      ,p.month_of_birth
      ,p.day_of_birth
      ,p.birth_datetime
      -- ,p.death_datetime
      ,p.race_concept_id
      ,p.ethnicity_concept_id
      -- ,p.location_id
      -- ,p.provider_id
      -- ,p.care_site_id
      -- ,p.person_source_value
      ,lower(substr(cg.concept_name, 1, 1))  as gender_source_value
      ,p.gender_concept_id                   as gender_source_concept_id
      -- ,p.race_source_value
      -- ,p.race_source_concept_id
      -- ,p.ethnicity_source_value
      -- ,p.ethnicity_source_concept_id
      -- ,p.covid_date
    FROM ds_person p
      left  join ds_concept cg on p.gender_concept_id = cg.concept_id
  "

ds_person_slim <-
  sql_person_slim |>
  sqldf::sqldf() |>
  tibble::as_tibble()


# # ---- inspect, fig.width=10, fig.height=6, fig.path=figure_path -----------------------------------------------------------------
# library(ggplot2)
#
# ggplot(ds_long, aes(x=wave_id, y=value, color=person_id)) + #, ymin=0
#   geom_line() +
#   facet_wrap("manifest", ncol=3, scales="free_y") +
#   theme_minimal() +
#   theme(legend.position="none")
#
# last_plot() %+% aes(x=year)
# last_plot() %+% aes(x=date_at_visit)
# last_plot() %+% aes(x=age)
#
# ggplot(ds, aes(x=year, y=cog_1, color=factor(county_id), group=person_id)) +
#   geom_line() +
#   theme_minimal() +
#   theme(legend.position="top")
#
# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds_person)
# checkmate::assert_factor(   ds_person$person_id       , any.missing=F                          , unique=T)
# checkmate::assert_integer(  ds_person$county_id       , any.missing=F , lower=51, upper=72     )
# checkmate::assert_integer(  ds_person$gender_id       , any.missing=F , lower=1, upper=255     )
# checkmate::assert_character(ds_person$race            , any.missing=F , pattern="^.{5,41}$"    )
# checkmate::assert_character(ds_person$ethnicity       , any.missing=F , pattern="^.{18,30}$"   )
#
# # OuhscMunge::verify_value_headstart(ds)
# checkmate::assert_factor(  ds$person_id         , any.missing=F                          )
# checkmate::assert_integer( ds$wave_id           , any.missing=F , lower=1, upper=10      )
# checkmate::assert_integer( ds$year              , any.missing=F , lower=2000, upper=2014 )
# checkmate::assert_date(    ds$date_at_visit     , any.missing=F , lower=as.Date("2000-01-01"), upper=as.Date("2018-12-31") )
# checkmate::assert_integer( ds$age               , any.missing=F , lower=55, upper=85     )
# checkmate::assert_integer( ds$county_id         , any.missing=F , lower=1, upper=77      )
#
# checkmate::assert_numeric( ds$int_factor_1      , any.missing=F , lower=4, upper=20      )
# checkmate::assert_numeric( ds$slope_factor_1    , any.missing=F , lower=-1, upper=1      )
# checkmate::assert_numeric( ds$int_factor_2      , any.missing=F , lower=6, upper=20      )
# checkmate::assert_numeric( ds$slope_factor_2    , any.missing=F , lower=0, upper=1       )
#
# checkmate::assert_numeric( ds$cog_1             , any.missing=F , lower=0, upper=20      )
# checkmate::assert_numeric( ds$cog_2             , any.missing=F , lower=0, upper=20      )
# checkmate::assert_numeric( ds$cog_3             , any.missing=F , lower=0, upper=20      )
# checkmate::assert_numeric( ds$phys_1            , any.missing=F , lower=0, upper=20      )
# checkmate::assert_numeric( ds$phys_2            , any.missing=F , lower=0, upper=20      )
# checkmate::assert_numeric( ds$phys_3            , any.missing=F , lower=0, upper=20      )
#
# person_wave_combo   <- paste(ds$person_id, ds$wave_id)
# checkmate::assert_character(person_wave_combo, pattern  ="^\\d{4} \\d{1,2}$"   , any.missing=F, unique=T)

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
# cat(paste0("    ", colnames(ds_person), collapse=",\n"))

ds_patient <-
  ds_person |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    person_id,
    data_partner_id,
    covid_date,
    covid_severity,
    dx_bird,
    calc_outbreak_lag_years,
    calc_age_covid,
    length_of_stay,
  )

ds_patient_hidden <-
  ds_person |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    person_id,
    latent_risk_1,
    latent_risk_2_int,
    latent_risk_2_slope,
    latent_risk_3,
  )

# ---- save-to-disk ------------------------------------------------------------
# If there's no PHI, a rectangular CSV is usually adequate, and it's portable to other machines and software.
if (config$produce_csv) {
  readr::write_csv(ds_site            , config$path_csv_site)
  readr::write_csv(ds_person_slim     , config$path_csv_person)
  readr::write_csv(ds_patient         , config$path_csv_patient)
  readr::write_csv(ds_patient_hidden  , config$path_csv_patient_hidden)
}

if (config$produce_rds) {
  readr::write_rds(ds_site            , config$path_rds_site              , compress = "gz")
  readr::write_rds(ds_person_slim     , config$path_rds_person            , compress = "gz")
  readr::write_rds(ds_patient         , config$path_rds_patient           , compress = "gz")
  readr::write_rds(ds_patient_hidden  , config$path_rds_patient_hidden    , compress = "gz")
}

if (config$produce_duckdb) {
  truncate_and_load_table_duckdb(ds_site          , "site_latent")
  truncate_and_load_table_duckdb(ds_person_slim   , "person")
  truncate_and_load_table_duckdb(ds_patient       , "patient")
  truncate_and_load_table_duckdb(ds_patient_hidden, "patient_latent")
}

if (config$produce_parquet) {
  arrow::write_parquet(ds_site                    , config$path_parquet_site)
  arrow::write_parquet(ds_person_slim             , config$path_parquet_person)
  arrow::write_parquet(ds_patient                 , config$path_parquet_patient)
  arrow::write_parquet(ds_patient_hidden          , config$path_parquet_patient_hidden)
}

if (config$produce_sqlite) {
  truncate_and_load_table_sqlite(ds_site          , "site_latent")
  truncate_and_load_table_sqlite(ds_person_slim   , "person")
  truncate_and_load_table_sqlite(ds_patient       , "patient")
  truncate_and_load_table_sqlite(ds_patient_hidden, "patient_latent")
}
