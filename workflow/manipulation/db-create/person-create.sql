-- DDL adapted from "cdm.sqlite" from https://ohdsi.github.io/Eunomia/
CREATE TABLE person (
  person_id                       integer   primary key,
  gender_concept_id               integer,
  year_of_birth                   integer,
  month_of_birth                  integer,
  day_of_birth                    integer,
  birth_datetime                  text, --SQLite doesn't have a native date type
  race_concept_id                 integer,
  ethnicity_concept_id            integer,
  location_id                     integer,
  provider_id                     integer,
  care_site_id                    integer,
  person_source_value             text,
  gender_source_value             text,
  gender_source_concept_id        integer,
  race_source_value               text,
  race_source_concept_id          integer,
  ethnicity_source_value          text,
  ethnicity_source_concept_id     integer
);
