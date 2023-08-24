-- CREATE SCHEMA if not exists latent;

DROP TABLE if exists site_latent;
CREATE TABLE site_latent (
  data_partner_id                 integer       primary key,
  covid_start_site                date          not null,
  relative_size                   float         not null,
);

DROP TABLE if exists date_nation_latent;
CREATE TABLE date_nation_latent (
  date                 date      primary key,
  pt_count             integer   not null
);

DROP TABLE if exists patient_latent;
CREATE TABLE patient_latent (
  person_id                       integer       primary key,
  latent_risk                     float         not null
);
