SELECT
  p.person_id
  ,p.data_partner_id
  ,p.gender_concept_id
  ,p.year_of_birth
  -- ,p.month_of_birth
  -- ,p.day_of_birth
  ,p.birth_date
  ,p.race_concept_id
  ,p.ethnicity_concept_id
  ,p.location_id
  ,p.provider_id
  ,p.care_site_id
  -- ,p.person_source_value
  ,p.gender_source_value
  ,p.gender_source_concept_id
  ,p.race_source_value
  ,p.race_source_concept_id
  ,p.ethnicity_source_value
  ,p.ethnicity_source_concept_id
  ,p.covid_date
  ,p.covid_severity
  ,p.dx_bird
  ,p.calc_outbreak_lag_years
  ,p.calc_age_covid
  ,p.length_of_stay
  ,p.latent_risk_1
  ,p.latent_risk_2_int
  ,p.latent_risk_2_slope
  ,p.latent_risk_3
  ,p.school_close
  ,p.school_closed_duration
  ,p.school_reopen
FROM analysis_patient p

ORDER BY p.person_id
