WITH obs_before as (
  SELECT
    o.observation_id
    ,o.person_id
    ,o.observation_concept_id
    ,o.observation_date
    -- ,datediff(o.observation_date, p.covid_date) as dx_days_before_covid  -- SparkSQL syntax
    ,datediff('day', o.observation_date, p.covid_date) as dx_days_before_covid -- most other SQL flavors
    ,row_number() over (partition by p.person_id order by o.observation_date desc) as index_within_pt
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
SELECT
  *
FROM obs_before
WHERE index_within_pt = 1
