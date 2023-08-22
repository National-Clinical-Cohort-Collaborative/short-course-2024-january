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
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("rlang"        ) # Language constructs, like quosures
requireNamespace("testit"       ) # For asserting conditions meet expected patterns/conditions.
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
requireNamespace("DBI"          ) # Database-agnostic interface
requireNamespace("RSQLite"      ) # Lightweight database for non-PHI data.
requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()
set.seed(453)
# figure_path <- "stitched-output/manipulation/simulation/simulate-mlm-1/"

subject_count       <- 100
# wave_count          <- 10
#
# possible_year_start <- 2000:2005
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

manifest_severity <- function (x) {
  cut(
    x       = x,
    breaks  = c(-Inf,  1.0,     2.0,       3.0,      4.0,     Inf),
    labels  = c(  "none", "mild", "moderate", "severe", "dead")
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
ds_concept <- retrieve_sqlite("SELECT * FROM concept")
ds_nation_count <- retrieve_sqlite("SELECT * FROM latent_nation_count")

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
    covid_start_site  = config$covid_start_nation + runif(site_count, min = 0, max = 45),
    relative_size     = rchisq(site_count, 5)
  )

site_assignment <-
  ds_site |>
  dplyr::slice_sample(weight_by = relative_size, n = subject_count, replace = TRUE) |>
  dplyr::pull(data_partner_id)

# ---- person ----------------------------------------------------------------
ds_person <-
  tibble::tibble(
    person_id         = factor(10*subject_count + seq_len(subject_count)),
    data_partner_id   = site_assignment,
    gender_concept_id = as.integer(sample(names(p_gender      ), prob = p_gender      , size = subject_count, replace = TRUE)),
  ) |>
  dplyr::mutate(
    latent_dob_lag    = rbeta(n = subject_count, shape1 = 1, shape2 = 1.9, ncp = 7/8),
    birth_date        = config$boundary_date_max - 40000 * latent_dob_lag,
    year_of_birth     = as.integer(lubridate::year(birth_date)),
    month_of_birth    = as.integer(lubridate::month(birth_date)),
    day_of_birth      = as.integer(lubridate::day(birth_date)),
  ) |>
  dplyr::mutate(
    covid_date              = sample(ds_nation_count$date, prob = ds_nation_count$pt_count, size = subject_count, replace = TRUE),
    calc_outbreak_lag_years = round(as.integer(difftime(covid_date, config$covid_start_nation, units = "days")) / 365.25, 2),
    calc_age_covid          = round(as.integer(difftime(covid_date, birth_date, units = "days")) / 365.25, 2),
  ) |>
  dplyr::mutate(
    latent_risk =
      .2 +
      # (-0.78 * latent_dob_lag) +
      (-0.5 * calc_outbreak_lag_years) +
      (.04 * calc_age_covid) +
      rnorm(subject_count, sd = 1.3),
    latent_risk     = round(latent_risk, 3),
    covid_severity  = manifest_severity(latent_risk),
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
    # race_concept_id,
    # ethnicity_concept_id,
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
    latent_risk,
    covid_severity,
    calc_outbreak_lag_years,
    calc_age_covid,
  )

summary(lm(latent_risk ~ 1 + calc_outbreak_lag_years + calc_age_covid, data = ds_person))
# summary(lm(latent_risk ~ 1 + latent_dob_lag + covid_date, data = ds_person))
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


# ---- sem ---------------------------------------------------------------------
#
# |>
#   dplyr::mutate(
#     int_factor_1    = int_county[county_index]   + rnorm(n=subject_count, mean=10.0 , sd=2.0),
#     slope_factor_1  = slope_county[county_index] + rnorm(n=subject_count, mean= 0.05, sd=0.04),
#
#     int_factor_2    = rnorm(n = subject_count, mean = 5.0 , sd = 0.8 ) + (cor_factor_1_vs_2[1] * int_factor_1),
#     slope_factor_2  = rnorm(n = subject_count, mean = 0.03, sd = 0.02) + (cor_factor_1_vs_2[2] * int_factor_1)
#   )
# ds_subject
#
# ds <-
#   tidyr::crossing(
#     subject_id      = ds_subject$subject_id,
#     wave_id         = seq_len(wave_count)
#   ) |>
#   dplyr::right_join(ds_subject, by="subject_id") |>
#   dplyr::mutate(
#     year            = wave_id + year_start - 1L,
#     age             = wave_id + age_start  - 1L,
#
#     date_at_visit   =
#       as.Date(
#         ISOdate(year, 1, 1) +
#           lubridate::days(sample(possible_date_offset, size = dplyr::n(), replace = TRUE))
#       )
#   ) |>
#   dplyr::mutate( # Generate cognitive manifest variables (ie, from factor 1)
#     cog_1           =
#       (int_factor_1 * loadings_factor_1[1]) +
#       slope_factor_1 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_1[1]),
#     cog_2           =
#       (int_factor_1 * loadings_factor_1[2]) +
#       slope_factor_1 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_1[2]),
#     cog_3           =
#       (int_factor_1 * loadings_factor_1[3]) +
#       slope_factor_1 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_1[3])
#   ) |>
#   dplyr::mutate( # Generate physical manifest variables (ie, from factor 2)
#     phys_1           =
#       (int_factor_2 * loadings_factor_2[1]) +
#       slope_factor_2 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_2[1]),
#     phys_2           =
#       (int_factor_2 * loadings_factor_2[2]) +
#       slope_factor_2 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_2[2]),
#     phys_3           =
#       (int_factor_2 * loadings_factor_2[3]) +
#       slope_factor_2 * wave_id +
#       rnorm(n=dplyr::n(), mean=0, sd=sigma_factor_2[3])
#   ) |>
#   dplyr::mutate( # Keep the manifest variables positive (which will throw off the correlations)
#     cog_1   = pmax(0, cog_1),
#     cog_2   = pmax(0, cog_2),
#     cog_3   = pmax(0, cog_3),
#     phys_1  = pmax(0, phys_1),
#     phys_2  = pmax(0, phys_2),
#     phys_3  = pmax(0, phys_3)
#   ) |>
#   dplyr::mutate( # Don't simulate unrealistically precise manifest variables
#     int_factor_1    = round(int_factor_1  , 3),
#     slope_factor_1  = round(slope_factor_1, 3),
#     int_factor_2    = round(int_factor_2  , 3),
#     slope_factor_2  = round(slope_factor_2, 3),
#
#     cog_1   = round(cog_1   , 1),
#     cog_2   = round(cog_2   , 1),
#     cog_3   = round(cog_3   , 1),
#     phys_1  = round(phys_1  , 1),
#     phys_2  = round(phys_2  , 1),
#     phys_3  = round(phys_3  , 1)
#   ) |>
#   dplyr::select(-year_start)
#
# ds

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
      -- ,p.race_concept_id
      -- ,p.ethnicity_concept_id
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
# ggplot(ds_long, aes(x=wave_id, y=value, color=subject_id)) + #, ymin=0
#   geom_line() +
#   facet_wrap("manifest", ncol=3, scales="free_y") +
#   theme_minimal() +
#   theme(legend.position="none")
#
# last_plot() %+% aes(x=year)
# last_plot() %+% aes(x=date_at_visit)
# last_plot() %+% aes(x=age)
#
# ggplot(ds, aes(x=year, y=cog_1, color=factor(county_id), group=subject_id)) +
#   geom_line() +
#   theme_minimal() +
#   theme(legend.position="top")
#
# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds_person)
# checkmate::assert_factor(   ds_subject$subject_id     , any.missing=F                          , unique=T)
# checkmate::assert_integer(  ds_subject$county_id      , any.missing=F , lower=51, upper=72     )
# checkmate::assert_integer(  ds_subject$gender_id      , any.missing=F , lower=1, upper=255     )
# checkmate::assert_character(ds_subject$race           , any.missing=F , pattern="^.{5,41}$"    )
# checkmate::assert_character(ds_subject$ethnicity      , any.missing=F , pattern="^.{18,30}$"   )
#
# # OuhscMunge::verify_value_headstart(ds)
# checkmate::assert_factor(  ds$subject_id        , any.missing=F                          )
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
# subject_wave_combo   <- paste(ds$subject_id, ds$wave_id)
# checkmate::assert_character(subject_wave_combo, pattern  ="^\\d{4} \\d{1,2}$"   , any.missing=F, unique=T)

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
  cat(paste0("    ", colnames(ds_person), collapse=",\n"))

ds_patient <-
  ds_person |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    person_id,
    data_partner_id,
    covid_date,
    covid_severity,
    calc_outbreak_lag_years,
    calc_age_covid,
  )

ds_patient_hidden <-
  ds_person |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    person_id,
    latent_risk,
  )

# # ---- save-to-disk ------------------------------------------------------------
# # If there's no PHI, a rectangular CSV is usually adequate, and it's portable to other machines and software.
readr::write_csv(ds_site          , config$path_simulated_site_csv)
readr::write_csv(ds_patient       , config$path_simulated_patient_csv)
readr::write_rds(ds_patient       , config$path_simulated_patient_rds      ,    compress = "gz")
readr::write_csv(ds_patient_hidden , config$path_simulated_patient_hidden_csv)
readr::write_rds(ds_patient_hidden , config$path_simulated_patient_hidden_rds,    compress = "gz")

# ---- save-to-db --------------------------------------------------------------
truncate_and_load_table_sqlite(ds_person_slim   , "person")
truncate_and_load_table_sqlite(ds_patient       , "patient")
truncate_and_load_table_sqlite(ds_patient_hidden, "patient_hidden")
