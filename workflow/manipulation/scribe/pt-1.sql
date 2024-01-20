SELECT
  cast(row_number() over (order by p.person_id) as int)     as pt_index
  --,p.person_id
  ,p.data_partner_id
  ,p.covid_date
  ,p.calc_age_covid
  ,p.length_of_stay
  ,po.event_animal
  ,po.dx_days_before_covid
  ,case
    when p.covid_date is null         then null
    when p.covid_date <= '2019-12-31' then 'too early'
    when p.covid_date <= '2020-06-30' then '2020H1'
    when p.covid_date <= '2020-12-31' then '2020H2'
    when p.covid_date <= '2021-06-30' then '2021H1'
    when p.covid_date <= '2021-12-31' then '2021H2'
    when p.covid_date <= '2022-06-30' then '2022H1'
    when p.covid_date <= '2022-12-31' then '2022H2'
    when p.covid_date <= '2023-06-30' then '2023H1'
    when p.covid_date <= '2023-12-31' then '2023H2'
    else                                   'error'
  end                                                      as period_first_covid_dx
  ,case
    when p.calc_age_covid is null then 'Unknown'
    when p.calc_age_covid < 0     then 'Unknown'
    when p.calc_age_covid < 2     then 'Too Young'
    when p.calc_age_covid < 19    then '2-18'
    when p.calc_age_covid < 51    then '19-50'
    when p.calc_age_covid < 76    then '51-75'
    else                               '76+'
  end                                                      as age_cut5
  ,p.covid_severity
  ,case
    when p.covid_severity = 'none'      then false
    when p.covid_severity = 'mild'      then true
    when p.covid_severity = 'moderate'  then true
    when p.covid_severity = 'severe'    then true
    when p.covid_severity = 'death'     then true
    else                                     null
  end                                                      as covid_mild_plus
  ,case
    when p.covid_severity = 'none'      then false
    when p.covid_severity = 'mild'      then false
    when p.covid_severity = 'moderate'  then true
    when p.covid_severity = 'severe'    then true
    when p.covid_severity = 'death'     then true
    else                                     null
  end                                                      as covid_moderate_plus
  ,case
    when p.covid_severity = 'none'      then false
    when p.covid_severity = 'mild'      then false
    when p.covid_severity = 'moderate'  then false
    when p.covid_severity = 'severe'    then true
    when p.covid_severity = 'death'     then true
    else                                     null
  end                                                      as covid_severe_plus
  ,case
    when p.covid_severity = 'none'      then false
    when p.covid_severity = 'mild'      then false
    when p.covid_severity = 'moderate'  then false
    when p.covid_severity = 'severe'    then false
    when p.covid_severity = 'death'     then true
    else                                     null
  end                                                      as covid_dead
FROM patient_ll p
  left  join pt_observation_preceding po on p.person_id = po.person_id
WHERE
  2 <= p.calc_age_covid
  and
  p.covid_date between '2020-07-01' and '2022-12-31'
