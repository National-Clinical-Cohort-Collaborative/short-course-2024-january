rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("SomethingSomething.R")

# ---- load-packages -----------------------------------------------------------
library(ggplot2) #For graphing
# import::from("magrittr", "%>%")
requireNamespace("dplyr")
requireNamespace("corrplot")
# requireNamespace("RColorBrewer")
# requireNamespace("scales") #For formating values in graphs
# requireNamespace("mgcv) #For the Generalized Additive Model that smooths the longitudinal graphs.
# requireNamespace("TabularManifest") # remotes::install_github("Melinae/TabularManifest")

# ---- declare-globals ---------------------------------------------------------
options(show.signif.stars = FALSE) #Turn off the annotations on p-values
config                      <- config::get()

# ---- load-data ---------------------------------------------------------------
ds_patient        <- arrow::read_parquet(config$path_analysis_patient_parquet) # 'ds' stands for 'datasets'
# ds_patient        <- readr::read_rds(config$path_analysis_patient_rds) # 'ds' stands for 'datasets'

# ---- tweak-data --------------------------------------------------------------
ds_patient <-
  ds_patient |>
  # dplyr::left_join(ds_patient           , by = "person_id") |>
  # dplyr::left_join(ds_patient_hidden    , by = "person_id") |>
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
    # location_id,
    # provider_id,
    # care_site_id,
    # person_source_value,
    gender_source_value,
    gender_source_concept_id,
    # race_source_value,
    # race_source_concept_id,
    # ethnicity_source_value,
    # ethnicity_source_concept_id,
    covid_date,
    covid_severity,
    calc_outbreak_lag_years,
    calc_age_covid,
    length_of_stay,
    latent_risk_1,
    latent_risk_2_int,
    latent_risk_2_slope,
    school_close,
    school_closed_duration,
    school_reopen,
  )
  #TODO: add school_close, school_closed_duration, & school_reopen (date, integer, date)
  # add to dplyr::select() above
  # add to marginals-site_latent below

# ---- marginals-person ---------------------------------------------------------------
ds_patient |>
  dplyr::mutate(
    person_id = as.integer(as.character(person_id))
    ) |>
  TabularManifest::histogram_continuous(         "person_id"            , bin_width = 5)
TabularManifest::histogram_discrete(  ds_patient, "gender_concept_id")
TabularManifest::histogram_continuous(ds_patient, "year_of_birth"        , bin_width = 5)
# TabularManifest::histogram_continuous(ds_patient, "month_of_birth"       , bin_width = 1)
# TabularManifest::histogram_continuous(ds_patient, "day_of_birth"         , bin_width = 1)
TabularManifest::histogram_date(      ds_patient, "birth_date"           , bin_unit = "year")
TabularManifest::histogram_discrete(ds_patient, "race_concept_id")
TabularManifest::histogram_discrete(ds_patient, "ethnicity_concept_id")
# TabularManifest::histogram_discrete(ds_patient, "location_id")
# TabularManifest::histogram_discrete(ds_patient, "provider_id")
# TabularManifest::histogram_discrete(ds_patient, "care_site_id")
# TabularManifest::histogram_discrete(ds_patient, "person_source_value")
TabularManifest::histogram_discrete(ds_patient, "gender_source_value")
TabularManifest::histogram_discrete(ds_patient, "gender_source_concept_id")
# TabularManifest::histogram_discrete(ds_patient, "race_source_value")
# TabularManifest::histogram_discrete(ds_patient, "race_source_concept_id")
# TabularManifest::histogram_discrete(ds_patient, "ethnicity_source_value")

# ---- marginals-patient --------------------------------------------------------
TabularManifest::histogram_discrete(  ds_patient, "data_partner_id")
TabularManifest::histogram_date(      ds_patient, "covid_date"           , bin_unit = "week")
TabularManifest::histogram_discrete(  ds_patient, "covid_severity")
TabularManifest::histogram_continuous(ds_patient, "calc_outbreak_lag_years" , rounded_digits = 1)
TabularManifest::histogram_continuous(ds_patient, "calc_age_covid"          , rounded_digits = 1)
TabularManifest::histogram_continuous(ds_patient, "length_of_stay"          , rounded_digits = 1)

# ---- marginals-patient_latent -------------------------------------------------
TabularManifest::histogram_continuous(ds_patient, "latent_risk_1"           , rounded_digits = 1)
TabularManifest::histogram_continuous(ds_patient, "latent_risk_2_int"       , rounded_digits = 1)
TabularManifest::histogram_continuous(ds_patient, "latent_risk_2_slope"     , rounded_digits = 1)

# ---- marginals-site_latent -------------------------------------------------
TabularManifest::histogram_date(      ds_patient, "school_close"            , bin_unit = "week")
TabularManifest::histogram_continuous(ds_patient, "school_closed_duration"  , rounded_digits = 0)
TabularManifest::histogram_date(      ds_patient, "school_reopen"           , bin_unit = "week")

# This helps start the code for graphing each variable.
#   - Make sure you change it to `histogram_continuous()` for the appropriate variables.
#   - Make sure the graph doesn't reveal PHI.
#   - Don't graph the IDs (or other uinque values) of large datasets.  The graph will be worth and could take a long time on large datasets.
# for(column in colnames(ds)) {
#   cat('TabularManifest::histogram_discrete(ds, variable_name="', column,'")\n', sep="")
# }

# ---- scatterplots ------------------------------------------------------------
g1 <-
  ds_patient |>
  ggplot(aes(
    x = calc_age_covid,
    y = latent_risk_1,
    group = data_partner_id,
    color = data_partner_id
    # fill = data_partner_id
  )) +
  geom_smooth(
    mapping = aes(group = NA, color = NULL, fill = NULL),
    method = "loess",
    span = 2,
    color = "gray40",
    linetype = "88"
  ) +
  geom_smooth(
    method = "loess",
    span = 2,
    se = FALSE
  ) +
  geom_point(shape=1) +
  theme_light() +
  theme(axis.ticks = element_blank())
g1

# g1 %+% aes(color=NULL)
g1 %+% aes(x = birth_date)
g1 %+% aes(x = calc_outbreak_lag_years)
g1 %+% aes(x = covid_date)
#
# ggplot(ds, aes(x=weight_gear_z, color=forward_gear_count_f, fill=forward_gear_count_f)) +
#   geom_density(alpha=.1) +
#   theme_minimal() +
#   labs(x=expression(z[gear]))

# ---- correlation-matrixes ----------------------------------------------------
predictor_names <-
  c(
    "calc_age_covid",
    # "birth_date",
    "calc_outbreak_lag_years"
    # "covid_date"
  )

# cat("### Hyp 1: Prediction of quarter mile time\n\n")
ds_hyp <- ds_patient[, c("latent_risk_1", predictor_names)]
colnames(ds_hyp) <- gsub("_", "\n", colnames(ds_hyp))
cor_matrix <- cor(ds_hyp)
corrplot::corrplot(cor_matrix, method="ellipse", addCoef.col="gray30", tl.col="gray20", diag=F)
pairs(x=ds_hyp, lower.panel=panel.smooth, upper.panel=panel.smooth)

colnames(cor_matrix) <- gsub("\n", "<br>", colnames(cor_matrix))
rownames(cor_matrix) <- gsub("\n", "<br>", rownames(cor_matrix))
knitr::kable(cor_matrix, digits = 3)
rm(ds_hyp, cor_matrix)
#
# cat("### Hyp 2: Prediction of z-score of weight/gear\n\n")
# ds_hyp <- ds[, c("weight_gear_z", predictor_names)]
# colnames(ds_hyp) <- gsub("_", "\n", colnames(ds_hyp))
# cor_matrix <- cor(ds_hyp)
# corrplot::corrplot(cor_matrix, method="ellipse", addCoef.col="gray30", tl.col="gray20", diag=F)
# pairs(x=ds_hyp, lower.panel=panel.smooth, upper.panel=panel.smooth)
#
# colnames(cor_matrix) <- gsub("\n", "<br>", colnames(cor_matrix))
# rownames(cor_matrix) <- gsub("\n", "<br>", rownames(cor_matrix))
# knitr::kable(cor_matrix, digits = 3)
# rm(ds_hyp, cor_matrix)

# ---- models ------------------------------------------------------------------
cat("============= Simple model that's just an intercept. =============")
m0 <- lm(latent_risk_1 ~ 1, data=ds_patient)
summary(m0)

cat("============= Model includes one predictor: `outbreak_lag`. =============")
m1a <- lm(latent_risk_1 ~ 1  + calc_outbreak_lag_years, data=ds_patient)
summary(m1a)

cat("============= Model includes one predictor: `calc_age_covid`. =============")
m1b <- lm(latent_risk_1 ~ 1  + calc_age_covid, data=ds_patient)
summary(m1b)

# cat("The one predictor is significantly tighter.")
# anova(m0, m1)

cat("============= Model includes two predictors. =============")
m2 <- lm(latent_risk_1 ~ 1  + calc_outbreak_lag_years + calc_age_covid, data=ds_patient)
summary(m2)

# cat("The two predictor is significantly tighter.")
# anova(m1, m2)

# ---- model-results-table  -----------------------------------------------
summary(m2)$coef |>
  knitr::kable(
    digits      = 2,
    format      = "markdown"
  )

# Uncomment the next line for a dynamic, JavaScript [DataTables](https://datatables.net/) table.
# DT::datatable(round(summary(m2)$coef, digits = 2), options = list(pageLength = 2))
