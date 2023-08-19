SELECT
  p.person_id
  ,pt.data_partner_id
  ,p.gender_concept_id
  ,p.year_of_birth
  ,p.month_of_birth
  ,p.day_of_birth
  ,p.birth_datetime
  ,p.race_concept_id
  ,p.ethnicity_concept_id
  ,p.location_id
  ,p.provider_id
  ,p.care_site_id
  ,p.person_source_value
  ,p.gender_source_value
  ,p.gender_source_concept_id
  ,p.race_source_value
  ,p.race_source_concept_id
  ,p.ethnicity_source_value
  ,p.ethnicity_source_concept_id
  ,p.covid_date
  ,pt.calc_outbreak_lag_years
  ,pt.calc_age_covid
  ,pth.latent_risk
FROM person p
  left  join patient         pt   on p.person_id = pt.person_id
  left  join patient_hidden  pth  on p.person_id = pth.person_id

ORDER BY p.person_id
