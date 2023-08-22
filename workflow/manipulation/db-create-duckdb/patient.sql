CREATE TYPE covid_severity as enum ('none', 'mild', 'moderate', 'severe', 'dead');

DROP TABLE if exists patient;
CREATE TABLE patient (
  person_id                       integer       primary key,
  data_partner_id                 integer       not null,
  covid_date                      date          not null,
  covid_severity                  covid_severity   not null,
  calc_outbreak_lag_years         float         not null,
  calc_age_covid                  float         not null
);

DROP TABLE if exists patient_hidden;
CREATE TABLE patient_hidden (
  person_id                       integer       primary key,
  latent_risk                     float         not null
);
