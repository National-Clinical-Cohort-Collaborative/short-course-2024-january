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

-- Adapted from https://github.com/Smart-PACER-Registry/omopv5_4_setup/blob/main/CommonDataModel-5.4.0/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql
