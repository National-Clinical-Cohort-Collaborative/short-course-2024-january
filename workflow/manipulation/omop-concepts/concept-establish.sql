SELECT
  TOP (1000)
  concept_id
  ,concept_name
  ,domain_id
  ,vocabulary_id
  ,concept_class_id
  ,standard_concept
  ,concept_code
  ,valid_start_date
  ,valid_end_date
  ,invalid_reason
FROM cdw_omop_1.v6.concept
WHERE
  concept_id in (
    8507, 8532       -- gender (M & F)
    ,4152194	 	-- Systolic blood pressure
    ,4154790	  -- Diastolic blood pressure
    ,702953     -- covid dx {ICD10CM U07.1}; note it's not standard
    ,37311061   -- covid dx (snomed)
    ,40762636	  -- Body mass index (BMI) Percentile {loinc 59574-4}
  )
