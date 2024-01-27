
CREATE TABLE condition_occurrence (
  condition_occurrence_id          integer      primary key,
  person_id                        integer      not null,
  condition_concept_id             integer      not null,
  condition_start_date             date         not null,
  condition_end_date               date,
  condition_type_concept_id        integer      not null,
  condition_source_value           varchar(50),
  data_partner_id                  integer      not null
);
