DROP TABLE if exists patient;
CREATE TABLE patient (
  person_id                       integer   primary key,
  data_partner_id                 integer,
  covid_date                      date,
  covid_severity                  varchar(15),
  calc_outbreak_lag_years         float,
  calc_age_covid                  float
);

DROP TABLE if exists patient_hidden;
CREATE TABLE patient_hidden (
  person_id                       integer   primary key,
  latent_risk                     float
);
