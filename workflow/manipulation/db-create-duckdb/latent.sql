-- CREATE SCHEMA if not exists latent;

DROP TABLE if exists site_latent;
CREATE TABLE site_latent (
  data_partner_id                 integer       primary key,
  covid_start_site                date          not null,
  site_relative_size              float         not null,
  site_int                        float         not null,
  site_slope                      float         not null,
  school_close                    date          not null,
  school_closed_duration          integer       not null,
  school_reopen                   date          not null,
  --TODO: add school_close, school_closed_duration, & school_reopen (date, integer, date)
);

DROP TABLE if exists date_nation_latent;
CREATE TABLE date_nation_latent (
  date                 date      primary key,
  pt_count             integer   not null
);

DROP TABLE if exists patient_latent;
DROP TYPE if exists obs_animal cascade; -- patient_latent table must be dropped first

CREATE TYPE obs_animal as enum ('pecked', 'butted');
CREATE TABLE patient_latent (
  person_id                       integer          primary key,
  latent_risk_1                   float            not null,
  latent_risk_2_int               float            not null,
  latent_risk_2_slope             float            not null,
  latent_risk_3                   float            not null,
  latent_risk_4                   float            not null,
  obs_animal                      obs_animal       not null,
);
