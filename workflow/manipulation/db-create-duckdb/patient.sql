DROP TABLE if exists patient;
CREATE TABLE patient (
  person_id                       integer       primary key,
  data_partner_id                 integer       not null,
  covid_date                      date          not null,
  covid_severity                  varchar(15)   not null,
  calc_outbreak_lag_years         float         not null,
  calc_age_covid                  float         not null
);

DROP TABLE if exists patient_hidden;
CREATE TABLE patient_hidden (
  person_id                       integer       primary key,
  latent_risk                     float         not null
);
