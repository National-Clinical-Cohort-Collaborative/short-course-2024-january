--TODO
-- 1. create (maybe temp) table that's the last animal observation before covid DX
-- 2. join to LL patient table
SELECT
  p.person_id
  ,*
  ,row_number() over (partition by p.person_id order by o.observation_date desc) as index_within_pt
FROM patient p
  inner join observation o on p.person_id = o.person_id
WHERE
  o.observation_date < p.covid_date
  and
  o.observation_concept_id in (
    4314094,
    4314097
  )
