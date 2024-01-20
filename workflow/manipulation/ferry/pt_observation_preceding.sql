-- In the Enclave, delete this DELETE & CREATE blocks
DROP TABLE if exists pt_observation_preceding;
CREATE TABLE pt_observation_preceding (
  observation_id            int        primary key,
  person_id                 int        not null,
  observation_concept_id    int        not null,
  observation_date          date       not null,
  dx_days_before_covid      int        not null,
  -- index_within_pt_rev       int        not null,
);

WITH obs_before as (
  SELECT
    o.observation_id
    ,o.person_id
    ,o.observation_concept_id
    ,case
      when o.observation_concept_id = 4314094 then 'Butted by animal'
      when o.observation_concept_id = 4314097 then 'Peck by bird'
      else                                         'Error: concept not classified'
    end                                         as event_animal
    ,o.observation_date
    -- ,datediff(o.observation_date, p.covid_date) as dx_days_before_covid  -- SparkSQL syntax
    ,datediff('day', o.observation_date, p.covid_date) as dx_days_before_covid -- most other SQL flavors
    ,row_number() over (partition by p.person_id order by o.observation_date desc) as index_within_pt_rev
  FROM patient_ll p
    inner join observation o on p.person_id = o.person_id
  WHERE
    o.observation_date < p.covid_date
    and
    o.observation_concept_id in (
      4314094,
      4314097
    )
)

INSERT INTO pt_observation_preceding -- In the Enclave, delete this line
SELECT
  observation_id
  ,person_id
  ,observation_concept_id
  ,event_animal
  ,observation_date
  ,dx_days_before_covid
FROM obs_before
WHERE index_within_pt_rev = 1
