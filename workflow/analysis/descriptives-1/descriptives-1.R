rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("SomethingSomething.R")

# ---- load-packages -----------------------------------------------------------
library(ggplot2) #For graphing
# import::from("magrittr", "%>%")
requireNamespace("dplyr")
# requireNamespace("RColorBrewer")
# requireNamespace("scales") #For formating values in graphs
# requireNamespace("mgcv) #For the Generalized Additive Model that smooths the longitudinal graphs.
# requireNamespace("TabularManifest") # remotes::install_github("Melinae/TabularManifest")

# ---- declare-globals ---------------------------------------------------------
options(show.signif.stars = FALSE) #Turn off the annotations on p-values
config                      <- config::get()

# ---- load-data ---------------------------------------------------------------
ds <- readr::read_rds(config$path_derived_person_rds) # 'ds' stands for 'datasets'

ds_person_hidden <- readr::read_rds(config$path_simulated_person_hidden_rds)

# ---- tweak-data --------------------------------------------------------------
ds <-
  ds |>
  dplyr::left_join(ds_person_hidden, by = "person_id") |>
  dplyr::select(
    person_id,
    data_partner_id,
    gender_concept_id,
    year_of_birth,
    month_of_birth,
    day_of_birth,
    birth_datetime,
    covid_date,
    latent_risk,
    calc_outbreak_lag_years,
    calc_age_covid,
  )

# ---- marginals-person ---------------------------------------------------------------
TabularManifest::histogram_discrete(  ds, "person_id")
TabularManifest::histogram_discrete(  ds, "data_partner_id")
TabularManifest::histogram_discrete(  ds, "gender_concept_id")
TabularManifest::histogram_continuous(ds, "year_of_birth")
TabularManifest::histogram_continuous(ds, "month_of_birth")
TabularManifest::histogram_continuous(ds, "day_of_birth")
TabularManifest::histogram_date(      ds, "birth_datetime", bin_unit = "year")
# TabularManifest::histogram_discrete(ds, "race_concept_id")
# TabularManifest::histogram_discrete(ds, "ethnicity_concept_id")
# TabularManifest::histogram_discrete(ds, "location_id")
# TabularManifest::histogram_discrete(ds, "provider_id")
# TabularManifest::histogram_discrete(ds, "care_site_id")
# TabularManifest::histogram_discrete(ds, "person_source_value")
# TabularManifest::histogram_discrete(ds, "gender_source_value")
# TabularManifest::histogram_discrete(ds, "gender_source_concept_id")
# TabularManifest::histogram_discrete(ds, "race_source_value")
# TabularManifest::histogram_discrete(ds, "race_source_concept_id")
# TabularManifest::histogram_discrete(ds, "ethnicity_source_value")
# TabularManifest::histogram_discrete(ds, "ethnicity_source_concept_id")
TabularManifest::histogram_date(ds, "covid_date", bin_unit = "week")

# ---- marginals-person-hidden -------------------------------------------------

TabularManifest::histogram_continuous(ds, "latent_risk"             , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "calc_outbreak_lag_years" , rounded_digits = 1)
TabularManifest::histogram_continuous(ds, "calc_age_covid"          , rounded_digits = 1)


# This helps start the code for graphing each variable.
#   - Make sure you change it to `histogram_continuous()` for the appropriate variables.
#   - Make sure the graph doesn't reveal PHI.
#   - Don't graph the IDs (or other uinque values) of large datasets.  The graph will be worth and could take a long time on large datasets.
# for(column in colnames(ds)) {
#   cat('TabularManifest::histogram_discrete(ds, variable_name="', column,'")\n', sep="")
# }

# ---- scatterplots ------------------------------------------------------------
# g1 <-
#   ggplot(ds, aes(x=birth_year, y=quarter_mile_sec, color=forward_gear_count_f)) +
#   geom_smooth(method="loess", span=2) +
#   geom_point(shape=1) +
#   theme_light() +
#   theme(axis.ticks = element_blank())
# g1
#
# g1 %+% aes(color=NULL)
# g1 %+% aes(color=factor(cylinder_count))
#
# ggplot(ds, aes(x=weight_gear_z, color=forward_gear_count_f, fill=forward_gear_count_f)) +
#   geom_density(alpha=.1) +
#   theme_minimal() +
#   labs(x=expression(z[gear]))

# ---- correlation-matrixes ----------------------------------------------------
# predictor_names <-
#   c(
#     "miles_per_gallon", "displacement_inches_cubed",
#     "cylinder_count", "horsepower",
#     "forward_gear_count"
#   )
#
# cat("### Hyp 1: Prediction of quarter mile time\n\n")
# ds_hyp <- ds[, c("quarter_mile_sec", predictor_names)]
# colnames(ds_hyp) <- gsub("_", "\n", colnames(ds_hyp))
# cor_matrix <- cor(ds_hyp)
# corrplot::corrplot(cor_matrix, method="ellipse", addCoef.col="gray30", tl.col="gray20", diag=F)
# pairs(x=ds_hyp, lower.panel=panel.smooth, upper.panel=panel.smooth)
#
# colnames(cor_matrix) <- gsub("\n", "<br>", colnames(cor_matrix))
# rownames(cor_matrix) <- gsub("\n", "<br>", rownames(cor_matrix))
# knitr::kable(cor_matrix, digits = 3)
# rm(ds_hyp, cor_matrix)
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
# cat("============= Simple model that's just an intercept. =============")
# m0 <- lm(quarter_mile_sec ~ 1, data=ds)
# summary(m0)
#
# cat("============= Model includes one predictor. =============")
# m1 <- lm(quarter_mile_sec ~ 1 + miles_per_gallon, data=ds)
# summary(m1)
#
# cat("The one predictor is significantly tighter.")
# anova(m0, m1)
#
# cat("============= Model includes two predictors. =============")
# m2 <- lm(quarter_mile_sec ~ 1 + miles_per_gallon + forward_gear_count_f, data=ds)
# summary(m2)
#
# cat("The two predictor is significantly tighter.")
# anova(m1, m2)

# ---- model-results-table  -----------------------------------------------
# summary(m2)$coef |>
#   knitr::kable(
#     digits      = 2,
#     format      = "markdown"
#   )

# Uncomment the next line for a dynamic, JavaScript [DataTables](https://datatables.net/) table.
# DT::datatable(round(summary(m2)$coef, digits = 2), options = list(pageLength = 2))
