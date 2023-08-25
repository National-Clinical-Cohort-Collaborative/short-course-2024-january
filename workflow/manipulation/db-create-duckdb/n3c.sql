DROP TABLE if exists patient;
DROP TYPE if exists covid_severity; -- patient table must be dropped first

CREATE TYPE covid_severity as enum ('none', 'mild', 'moderate', 'severe', 'dead');
CREATE TABLE patient (
  person_id                       integer       primary key,
  data_partner_id                 integer       not null,
  covid_date                      date          not null,
  covid_severity                  covid_severity   not null,
  calc_outbreak_lag_years         float         not null,
  calc_age_covid                  float         not null,
  length_of_stay                  integer       not null
);

CREATE INDEX ix_patient_data_partner_id on patient (data_partner_id);
