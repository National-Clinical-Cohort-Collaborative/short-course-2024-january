DROP TABLE if exists analysis_patient;

CREATE TABLE analysis_patient(
  person_id                       integer          primary key,
  data_partner_id                 integer          not null,
  gender_concept_id               integer          not null,
  year_of_birth                   integer          not null,
--   month_of_birth                  integer              null,
--   day_of_birth                    integer              null,
--   birth_datetime                  timestamp            null,
  birth_date                      date                 null,
  race_concept_id                 integer          not null,
  ethnicity_concept_id            integer          not null,
  location_id                     integer              null,
  provider_id                     integer              null,
  care_site_id                    integer              null,
--   person_source_value             varchar(50)          null,
  gender_source_value             varchar(50)          null,
  gender_source_concept_id        integer              null,
  race_source_value               varchar(50)          null,
  race_source_concept_id          integer              null,
  ethnicity_source_value          varchar(50)          null,
  ethnicity_source_concept_id     integer              null,
  covid_date                      date             not null,
  covid_severity                  covid_severity   not null,
  calc_outbreak_lag_years         float            not null,
  calc_age_covid                  float            not null,
  latent_risk_1                   float            not null
);