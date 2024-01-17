CREATE TABLE patient (
  person_id                       integer   primary key,
  data_partner_id                 integer,
  covid_date                      text,
  covid_severity                  text,
  dx_bird                         text,
  calc_outbreak_lag_years         real,
  calc_age_covid                  real,
  length_of_stay                  integer       not null
);
