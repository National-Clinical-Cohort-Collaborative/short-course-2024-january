CREATE TABLE patient (
  person_id                       integer   primary key,
  data_partner_id                 integer,
  calc_outbreak_lag_years         real,
  calc_age_covid                  real
);
