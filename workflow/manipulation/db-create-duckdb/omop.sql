DROP TABLE if exists concept;
CREATE TABLE concept (
  concept_id          integer         primary key,
  concept_name        varchar(255)    not null,
  domain_id           varchar(20)     not null,
  vocabulary_id       varchar(20)     not null,
  concept_class_id    varchar(20)     not null,
  standard_concept    varchar(1)          null,
  concept_code        varchar(50)     not null,
  valid_start_date    date            not null,
  valid_end_date      date            not null,
  invalid_reason      varchar(1)          null
);
CREATE INDEX ix_concept_vocabulary_id      on concept (vocabulary_id);
CREATE INDEX ix_concept_standard_concept   on concept (standard_concept);

DROP TABLE if exists person;
CREATE TABLE person (
  person_id                    integer       primary key,
  gender_concept_id            integer       not null,
  year_of_birth                integer       not null,
  month_of_birth               integer           null,
  day_of_birth                 integer           null,
  birth_datetime               timestamp         null,
  race_concept_id              integer       not null,
  ethnicity_concept_id         integer       not null,
  location_id                  integer           null,
  provider_id                  integer           null,
  care_site_id                 integer           null,
  person_source_value          varchar(50)       null,
  gender_source_value          varchar(50)       null,
  gender_source_concept_id     integer           null,
  race_source_value            varchar(50)       null,
  race_source_concept_id       integer           null,
  ethnicity_source_value       varchar(50)       null,
  ethnicity_source_concept_id  integer           null
);

DROP TABLE if exists observation;
CREATE TABLE observation(
  observation_id                  bigint       primary key,
  person_id                       bigint       not null,
  observation_concept_id          int          not null,
  observation_date                date             null,
);
-- Adapted from https://github.com/Smart-PACER-Registry/omopv5_4_setup/blob/main/CommonDataModel-5.4.0/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql
-- CREATE TABLE observation(
--   observation_id                  bigint       primary key,
--   person_id                       bigint       not null,
--   observation_concept_id          int          not null,
--   observation_date                date             null,
--   observation_datetime            datetime2(0) not null,
--   observation_type_concept_id     int          not null,
--   value_as_number                 float            null,
--   value_as_string                 varchar(60)      null,
--   value_as_concept_id             int              null,
--   qualifier_concept_id            int              null,
--   unit_concept_id                 int              null,
--   provider_id                     int              null,
--   visit_occurrence_id             bigint           null,
--   visit_detail_id                 bigint           null,
--   observation_source_value        varchar(50)      null,
--   observation_source_concept_id   int          not null,
--   unit_source_value               varchar(50)      null,
--   qualifier_source_value          varchar(50)      null,
--   observation_event_id            bigint           null,
--   obs_event_field_concept_id      int          not null,
--   value_as_datetime               datetime2(0)     null
-- );

CREATE TABLE condition_occurrence (
  condition_occurrence_id          integer      primary key,
  person_id                        integer      not null,
  condition_concept_id             integer      not null,
  condition_start_date             date         not null,
  condition_end_date               date,
  condition_type_concept_id        integer      not null,
  condition_source_value           varchar(50),
  data_partner_id                  integer      not null,
);
-- https://github.com/OHDSI/CommonDataModel/blob/main/inst/ddl/5.4/duckdb/OMOPCDM_duckdb_5.4_ddl.sql
-- CREATE TABLE condition_occurrence (
--   condition_occurrence_id          integer      primary key,
--   person_id                        integer      not null,
--   condition_concept_id             integer      not null,
--   condition_start_date             date         not null,
--   condition_start_datetime         timestamp,
--   condition_end_date               date,
--   condition_end_datetime           timestamp,
--   condition_type_concept_id        integer      not null,
--   condition_status_concept_id      integer,
--   stop_reason                      varchar(20),
--   provider_id                      integer,
--   visit_occurrence_id              integer,
--   visit_detail_id                  integer,
--   condition_source_value           varchar(50),
--   condition_source_concept_id      integer,
--   condition_status_source_value    varchar(50),
-- );