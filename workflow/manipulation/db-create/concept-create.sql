CREATE TABLE concept (
  concept_id           integer primary key,
  concept_name         text,
  domain_id            text,
  vocabulary_id        text,
  concept_class_id     text,
  standard_concept     text,
  concept_code         text,
  valid_start_date     text, --SQLite doesn't have a native date type
  valid_end_date       text, --SQLite doesn't have a native date type
  invalid_reason       text
)
