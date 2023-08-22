DROP TABLE if exists patient_hidden;
CREATE TABLE patient_hidden (
  person_id                       integer       primary key,
  latent_risk                     float         not null
);
