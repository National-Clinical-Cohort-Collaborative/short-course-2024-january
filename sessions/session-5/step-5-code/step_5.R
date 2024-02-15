# local_overall code
local_overall <- function(Analytic_dataset) {
# Run time: ~10s
library(dplyr)

local_df <- Analytic_dataset

# Remove person_id from the dataframe so it's not in the summary tables
local_df <- local_df %>% select(-person_id)

# Set factor levels

# Malnutrition
local_df$malnutrition <- factor(local_df$malnutrition, levels=c("No Malnutrition Documented", "Hx of Malnutrition", "Hospital-Acquired Malnutrition"))

# Race/Ethnicity
local_df$race_ethnicity <- factor(local_df$race_ethnicity, levels=c("White Non-Hispanic", "Black or African American Non-Hispanic", "Hispanic or Latino Any Race",  "Other", "Unknown"))

# Sex
local_df$sex <- factor(local_df$sex, levels=c("Female", "Male"))

# Tobacco
local_df$tobacco <- factor(local_df$tobacco, levels=c("0","1"))
levels(local_df$tobacco)[levels(local_df$tobacco)=="0"] <- "No Hx of Tobacco Usage"
levels(local_df$tobacco)[levels(local_df$tobacco)=="1"] <- "Current or Former Tobacco User"
local_df$tobacco=relevel(as.factor(local_df$tobacco),ref="No Hx of Tobacco Usage")

# Region
local_df$region <- factor(local_df$region, levels=c("Midwest", "Northeast", "South", "West", "Missing"))

return(to_rdata(local_df))

}

# table_1_overall code
table_1_overall <- function(local_overall) {
# Run time: ~27s
library(gtsummary)

local_df <- from_rdata(local_overall)

# Use gtsummary to create descriptive statistics, stratified by
# malnutrition status
table1 <- local_df %>%
    # Only use the missing = "no" option if you are very confident your data isn't missing things
    # it's supposed to have...
    tbl_summary(by = malnutrition, missing = "no") %>%
    add_overall() %>% 
    add_p()

# Convert to tibble to coerce to a dataframe
table1 <- as_tibble(table1, col_labels = FALSE)

# Return summary stats. Note: column labels are excluded because they
# cannot be coerced into a data frame in this platform.
return(table1)   
}

# death_glm_overall code
death_glm_overall <- function(local_overall) {
# Run time: ~7ms
library(gtsummary)

local_df <- from_rdata(local_overall)

cOR <-
  tbl_uvregression(
    local_df[c("death_or_hospice", "malnutrition", "age_at_covid", "sex", "race_ethnicity", "cci", "tobacco", "region")],
    method = glm,
    y = death_or_hospice,
    method.args = list(family = binomial),
    exponentiate = TRUE
  )

aOR <- glm(death_or_hospice ~ malnutrition + age_at_covid + sex + race_ethnicity + cci + tobacco + region, data=local_df, family = binomial(link = "logit")) %>%
  tbl_regression(exponentiate = TRUE)   %>%
    add_nevent(location = "level") %>%
  add_n(location = "level") %>%
  # adding event rate
  modify_table_body(
    ~ .x %>% 
      dplyr::mutate(
        stat_nevent_rate = 
          ifelse(
            !is.na(stat_nevent),
            paste0(style_sigfig(stat_nevent / stat_n, scale = 100), "%"),
            NA
          ), 
        .after = stat_nevent
      )
  ) %>%
  # merge the colums into a single column
  modify_cols_merge(
    pattern = "{stat_nevent} / {stat_n} ({stat_nevent_rate})",
    rows = !is.na(stat_nevent)
  ) %>%
  # update header to event rate
  modify_header(stat_nevent = "**Event Rate**")

merged_tbl <-
  tbl_merge(
    tbls = list(cOR, aOR)
  )
  
table1 <- as_tibble(merged_tbl, col_labels = FALSE)

return(table1)     
}
