DROP TABLE if exists observation;
CREATE TABLE observation(
  observation_id                  int          primary key,
  person_id                       int          not null,
  observation_concept_id          int          not null,
  observation_date                text             null,
);
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