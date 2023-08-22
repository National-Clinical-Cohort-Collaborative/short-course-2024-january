-- CREATE SCHEMA if not exists latent;

DROP TABLE if exists latent_nation_count;

CREATE TABLE latent_nation_count (
  date                 text   primary key,
  pt_count             integer
);
