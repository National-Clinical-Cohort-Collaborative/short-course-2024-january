-- CREATE SCHEMA if not exists latent;

DROP TABLE if exists date_nation_latent;

CREATE TABLE date_nation_latent (
  date                 date      primary key,
  pt_count             integer   not null
);
