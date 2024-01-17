CREATE TABLE observation(
  observation_id                  int          primary key,
  person_id                       int          not null,
  observation_concept_id          int          not null,
  observation_date                text             null
);
