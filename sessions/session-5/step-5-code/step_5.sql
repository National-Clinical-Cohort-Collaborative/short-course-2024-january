-- table_1_overall_clean code
SELECT 
-- Assign the type so the download review process is easier (e.g., whether you are showing counts or ranges)
CASE WHEN stat_1 LIKE '%, %' THEN CONCAT(label, ', Median (IQR)') 
	WHEN stat_1 IS NOT NULL THEN CONCAT(label, ', Count (%)') 
	ELSE label 
END AS label, 

-- Small cell count censoring
CASE WHEN CAST(substring_index(stat_0, ' ', 1) AS INT) >= 1000 
	THEN CONCAT(format_number(CAST(substring_index(stat_0, ' ', 1) AS INT), 0), ' ', substring_index(stat_0, ' ', -1)) 
	WHEN CAST(substring_index(stat_0, ' ', 1) AS INT) BETWEEN 20 AND 999 
	THEN stat_0 
	WHEN stat_0 NOT LIKE '%, %' AND substring_index(stat_0, ' ', 1) < 20 
	THEN '<20' ELSE stat_0 
END AS overall,

-- Small cell count censoring
CASE WHEN CAST(substring_index(stat_1, ' ', 1) AS INT) >= 1000 
	THEN CONCAT(format_number(CAST(substring_index(stat_1, ' ', 1) AS INT), 0), ' ', substring_index(stat_1, ' ', -1)) 
	WHEN CAST(substring_index(stat_1, ' ', 1) AS INT) BETWEEN 20 AND 999 
	THEN stat_1 
	WHEN stat_1 NOT LIKE '%, %' AND substring_index(stat_1, ' ', 1) < 20 
	THEN '<20' ELSE stat_1 
END AS no_hx_of_malnutrition,

CASE WHEN CAST(substring_index(stat_2, ' ', 1) AS INT) >= 1000 
	THEN CONCAT(format_number(CAST(substring_index(stat_2, ' ', 1) AS INT), 0), ' ', substring_index(stat_2, ' ', -1)) 
	WHEN CAST(substring_index(stat_2, ' ', 1) AS INT) BETWEEN 20 AND 999 
	THEN stat_2 
	WHEN stat_2 NOT LIKE '%, %' AND substring_index(stat_2, ' ', 1) < 20 
	THEN '<20' ELSE stat_2 
END AS hx_of_malnutrition,

-- Small cell count censoring
CASE WHEN CAST(substring_index(stat_3, ' ', 1) AS INT) >= 1000 
	THEN CONCAT(format_number(CAST(substring_index(stat_3, ' ', 1) AS INT), 0), ' ', substring_index(stat_3, ' ', -1)) 
	WHEN CAST(substring_index(stat_3, ' ', 1) AS INT) BETWEEN 20 AND 999 
	THEN stat_3 
	WHEN stat_3 NOT LIKE '%, %' AND substring_index(stat_3, ' ', 1) < 20 
	THEN '<20' ELSE stat_3 
END AS hospital_acquired_malnutrition,

p_value
FROM table_1_overall

-- death_glm_overall_clean code
SELECT 
label, 

-- death events
-- This first bit of code cleans up the formatting and censoring cells where the numerator 
-- is <20
CASE 
    WHEN CAST(substring_index(stat_nevent_2, ' / ', 1) AS INT) < 20 THEN '<20' 
    WHEN stat_nevent_2 IS NULL THEN ' ' 
    ELSE CONCAT(format_number(CAST(substring_index(stat_nevent_2, ' / ', 1) AS INT), '###,###,###'), ' / ', substring_index(stat_nevent_2, ' / ', -1)) 
END AS death_events,

-- crude odds ratios
-- This bit of code cleans up the output a bit so you don't have to do it manually
CASE 
    WHEN label IN ('malnutrition', 'sex', 'race_ethnicity', 'tobacco', 'region') THEN ' ' 
    WHEN label IN ('No Malnutrition Documented', 'Female', 'White Non-Hispanic', 'No Hx of Tobacco Usage', 'Midwest') THEN 'Reference' 
    ELSE CONCAT(estimate_1, ' (', ci_1, ')') 
END AS crude_odds_ratio,

-- adjusted odds ratios
-- This bit of code cleans up the output a bit so you don't have to do it manually
CASE 
    WHEN label IN ('malnutrition', 'sex', 'race_ethnicity', 'tobacco', 'region') THEN ' ' 
    WHEN label IN ('No Malnutrition Documented', 'Female', 'White Non-Hispanic', 'No Hx of Tobacco Usage', 'Midwest') THEN 'Reference' 
    ELSE CONCAT(estimate_2, ' (', ci_2, ')') 
END AS adjusted_odds_ratio

FROM death_glm_overall