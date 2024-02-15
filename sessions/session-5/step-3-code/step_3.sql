-- step_1 code 
SELECT *
FROM Logic_Liaison_Covid_19_patient_summary_fact_table_De_Id
-- Exclude sites with 'incomplete' death reporting
WHERE data_partner_id NOT IN (
    [REDACTED]
)
-- Exclude sites with no macrovisit hospitalizations
AND data_partner_id NOT IN (
    [REDACTED]
)

-- step_2 code
SELECT *
FROM Logic_Liaison_Covid_19_patient_summary_fact_table_De_Id
-- Exclude sites with 'incomplete' death reporting
WHERE data_partner_id NOT IN (
    [REDACTED]
)
-- Exclude sites with no macrovisit hospitalizations
AND data_partner_id NOT IN (
    [REDACTED]
)
-- New exclusion: missing sex
AND sex IN (
    'FEMALE', 'MALE' -- Note that we are really restricting to the two binary
                     -- sex classifications here rather than truly restricting 
                     -- to patients with missing sex. EHR needs to do a much better
                     -- job in this area.
)
-- New exclusion: missing age 
AND age_at_covid IS NOT NULL
-- New exclusion: pediatric patients (<19 years)
AND age_at_covid > 18 -- In hindsight, would probably restrict ages from 19-99

-- step 3 code
SELECT *
FROM Logic_Liaison_Covid_19_patient_summary_fact_table_De_Id
-- Exclude sites with 'incomplete' death reporting
WHERE data_partner_id NOT IN (
    [REDACTED]
)
-- Exclude sites with no macrovisit hospitalizations
AND data_partner_id NOT IN (
    [REDACTED]
)
-- New exclusion: missing sex
AND sex IN (
    'FEMALE', 'MALE' -- Note that we are really restricting to the two binary
                     -- sex classifications here rather than truly restricting 
                     -- to patients with missing sex. EHR needs to do a much better
                     -- job in this area.
)
-- Missing age 
AND age_at_covid IS NOT NULL
-- Pediatric patients (<19 years)
AND age_at_covid > 18 -- In hindsight, would probably restrict ages from 19-99
-- Add exclusion: patients not hospitalized within 14 days of first COVID-19 diagnosis
AND person_id IN 
(
    SELECT DISTINCT person_id
    FROM Logic_Liaison_Covid_19_patients_visit_day_facts_table_De_Id 
    WHERE during_macrovisit_hospitalization = 1
    AND DATEDIFF(date, COVID_first_poslab_or_diagnosis_date) BETWEEN 0 AND 14
)

-- analytic_ll_person_table code
SELECT *
FROM Logic_Liaison_Covid_19_patient_summary_fact_table_De_Id
-- Exclude sites with 'incomplete' death reporting
WHERE data_partner_id NOT IN (
    [REDACTED]
)
-- Exclude sites with no macrovisit hospitalizations
AND data_partner_id NOT IN (
    [REDACTED]
)
-- Missing sex
AND sex IN (
    'FEMALE', 'MALE' -- Note that we are really restricting to the two binary
                     -- sex classifications here rather than truly restricting 
                     -- to patients with missing sex. EHR needs to do a much better
                     -- job in this area.
)
-- Missing age 
AND age_at_covid IS NOT NULL
-- Pediatric patients (<19 years)
AND age_at_covid > 18 -- In hindsight, would probably restrict ages from 19-99
-- Patients not hospitalized within 14 days of first COVID-19 diagnosis
AND person_id IN 
(
    SELECT DISTINCT person_id
    FROM Logic_Liaison_Covid_19_patients_visit_day_facts_table_De_Id 
    WHERE during_macrovisit_hospitalization = 1
    AND DATEDIFF(date, COVID_first_poslab_or_diagnosis_date) BETWEEN 0 AND 14
)
-- New exclusion: restrict infection/diagnosis date
AND COVID_first_poslab_or_diagnosis_date BETWEEN 
date_add('2020-01-31', -180) -- The first 'documented' case was March 9 while likely
                             -- cases were happening before then. We are using a conservative
                             -- estimate here to account for the overall date shift and potential
                             -- site-level date shifting.
AND date_add(current_date, -365)

-- analytic_ll_visit_table code: 
SELECT l.*
FROM Logic_Liaison_Covid_19_patients_visit_day_facts_table_De_Id l
JOIN analytic_ll_person_table a on a.person_id = l.person_id
