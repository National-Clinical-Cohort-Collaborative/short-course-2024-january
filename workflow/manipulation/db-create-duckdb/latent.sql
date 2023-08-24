-- CREATE SCHEMA if not exists latent;

DROP TABLE if exists site;
CREATE TABLE site (
  data_partner_id                 integer       primary key,
  covid_start_site                date          not null,
  relative_size                   float         not null,
);

DROP TABLE if exists date_nation_latent;
CREATE TABLE date_nation_latent (
  date                 date      primary key,
  pt_count             integer   not null
);

DROP TABLE if exists patient_hidden;
CREATE TABLE patient_hidden (
  person_id                       integer       primary key,
  latent_risk                     float         not null
);
