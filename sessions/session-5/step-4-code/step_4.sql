-- state_cleaning code
SELECT person_id,
       city,
       3_DIGIT_ZIP,
       county,
       /* Assign state to 3-digit ZIP Code prefix. */
       CASE
         WHEN state IS NOT NULL THEN state
         WHEN 3_DIGIT_ZIP BETWEEN 995 AND 999 THEN 'AK'
         WHEN 3_DIGIT_ZIP BETWEEN 350 AND 352 THEN 'AL'
         WHEN 3_DIGIT_ZIP BETWEEN 354 AND 369 THEN 'AL'
         WHEN 3_DIGIT_ZIP BETWEEN 716 AND 729 THEN 'AR'
         WHEN 3_DIGIT_ZIP BETWEEN 850 AND 850 THEN 'AZ'
         WHEN 3_DIGIT_ZIP BETWEEN 852 AND 853 THEN 'AZ'
         WHEN 3_DIGIT_ZIP BETWEEN 855 AND 857 THEN 'AZ'
         WHEN 3_DIGIT_ZIP BETWEEN 859 AND 860 THEN 'AZ'
         WHEN 3_DIGIT_ZIP BETWEEN 863 AND 865 THEN 'AZ'
         WHEN 3_DIGIT_ZIP BETWEEN 900 AND 908 THEN 'CA'
         WHEN 3_DIGIT_ZIP BETWEEN 910 AND 928 THEN 'CA'
         WHEN 3_DIGIT_ZIP BETWEEN 930 AND 961 THEN 'CA'
         WHEN 3_DIGIT_ZIP BETWEEN 800 AND 816 THEN 'CO'
         WHEN 3_DIGIT_ZIP BETWEEN 60 AND 69 THEN 'CT'
         WHEN 3_DIGIT_ZIP BETWEEN 200 AND 200 THEN 'DC'
         WHEN 3_DIGIT_ZIP BETWEEN 202 AND 205 THEN 'DC'
         WHEN 3_DIGIT_ZIP BETWEEN 197 AND 199 THEN 'DE'
         WHEN 3_DIGIT_ZIP BETWEEN 320 AND 339 THEN 'FL'
         WHEN 3_DIGIT_ZIP BETWEEN 341 AND 342 THEN 'FL'
         WHEN 3_DIGIT_ZIP BETWEEN 344 AND 344 THEN 'FL'
         WHEN 3_DIGIT_ZIP BETWEEN 346 AND 347 THEN 'FL'
         WHEN 3_DIGIT_ZIP BETWEEN 349 AND 349 THEN 'FL'
         WHEN 3_DIGIT_ZIP BETWEEN 300 AND 319 THEN 'GA'
         WHEN 3_DIGIT_ZIP BETWEEN 399 AND 399 THEN 'GA'
         WHEN 3_DIGIT_ZIP BETWEEN 969 AND 969 THEN 'GU'
         WHEN 3_DIGIT_ZIP BETWEEN 967 AND 968 THEN 'HI'
         WHEN 3_DIGIT_ZIP BETWEEN 500 AND 528 THEN 'IA'
         WHEN 3_DIGIT_ZIP BETWEEN 832 AND 838 THEN 'ID'
         WHEN 3_DIGIT_ZIP BETWEEN 600 AND 620 THEN 'IL'
         WHEN 3_DIGIT_ZIP BETWEEN 622 AND 629 THEN 'IL'
         WHEN 3_DIGIT_ZIP BETWEEN 460 AND 470 THEN 'IN'
         WHEN 3_DIGIT_ZIP BETWEEN 472 AND 479 THEN 'IN'
         WHEN 3_DIGIT_ZIP BETWEEN 660 AND 662 THEN 'KS'
         WHEN 3_DIGIT_ZIP BETWEEN 664 AND 679 THEN 'KS'
         WHEN 3_DIGIT_ZIP BETWEEN 400 AND 427 THEN 'KY'
         WHEN 3_DIGIT_ZIP BETWEEN 471 AND 471 THEN 'KY'
         WHEN 3_DIGIT_ZIP BETWEEN 700 AND 701 THEN 'LA'
         WHEN 3_DIGIT_ZIP BETWEEN 703 AND 708 THEN 'LA'
         WHEN 3_DIGIT_ZIP BETWEEN 710 AND 714 THEN 'LA'
         WHEN 3_DIGIT_ZIP BETWEEN 10 AND 27 THEN 'MA'
         WHEN 3_DIGIT_ZIP BETWEEN 55 AND 55 THEN 'MA'
         WHEN 3_DIGIT_ZIP BETWEEN 206 AND 212 THEN 'MD'
         WHEN 3_DIGIT_ZIP BETWEEN 214 AND 219 THEN 'MD'
         WHEN 3_DIGIT_ZIP BETWEEN 39 AND 49 THEN 'ME'
         WHEN 3_DIGIT_ZIP BETWEEN 480 AND 499 THEN 'MI'
         WHEN 3_DIGIT_ZIP BETWEEN 550 AND 551 THEN 'MN'
         WHEN 3_DIGIT_ZIP BETWEEN 553 AND 566 THEN 'MN'
         WHEN 3_DIGIT_ZIP BETWEEN 630 AND 631 THEN 'MO'
         WHEN 3_DIGIT_ZIP BETWEEN 633 AND 641 THEN 'MO'
         WHEN 3_DIGIT_ZIP BETWEEN 644 AND 658 THEN 'MO'
         WHEN 3_DIGIT_ZIP BETWEEN 386 AND 397 THEN 'MS'
         WHEN 3_DIGIT_ZIP BETWEEN 590 AND 599 THEN 'MT'
         WHEN 3_DIGIT_ZIP BETWEEN 270 AND 289 THEN 'NC'
         WHEN 3_DIGIT_ZIP BETWEEN 567 AND 567 THEN 'ND'
         WHEN 3_DIGIT_ZIP BETWEEN 580 AND 588 THEN 'ND'
         WHEN 3_DIGIT_ZIP BETWEEN 680 AND 681 THEN 'NE'
         WHEN 3_DIGIT_ZIP BETWEEN 683 AND 693 THEN 'NE'
         WHEN 3_DIGIT_ZIP BETWEEN 30 AND 38 THEN 'NH'
         WHEN 3_DIGIT_ZIP BETWEEN 70 AND 89 THEN 'NJ'
         WHEN 3_DIGIT_ZIP BETWEEN 870 AND 875 THEN 'NM'
         WHEN 3_DIGIT_ZIP BETWEEN 877 AND 884 THEN 'NM'
         WHEN 3_DIGIT_ZIP BETWEEN 889 AND 891 THEN 'NV'
         WHEN 3_DIGIT_ZIP BETWEEN 893 AND 895 THEN 'NV'
         WHEN 3_DIGIT_ZIP BETWEEN 897 AND 898 THEN 'NV'
         WHEN 3_DIGIT_ZIP BETWEEN 5 AND 5 THEN 'NY'
         WHEN 3_DIGIT_ZIP BETWEEN 100 AND 149 THEN 'NY'
         WHEN 3_DIGIT_ZIP BETWEEN 430 AND 459 THEN 'OH'
         WHEN 3_DIGIT_ZIP BETWEEN 730 AND 731 THEN 'OK'
         WHEN 3_DIGIT_ZIP BETWEEN 734 AND 741 THEN 'OK'
         WHEN 3_DIGIT_ZIP BETWEEN 743 AND 749 THEN 'OK'
         WHEN 3_DIGIT_ZIP BETWEEN 970 AND 979 THEN 'OR'
         WHEN 3_DIGIT_ZIP BETWEEN 150 AND 196 THEN 'PA'
         WHEN 3_DIGIT_ZIP BETWEEN 6 AND 7 THEN 'PR'
         WHEN 3_DIGIT_ZIP BETWEEN 9 AND 9 THEN 'PR'
         WHEN 3_DIGIT_ZIP BETWEEN 28 AND 29 THEN 'RI'
         WHEN 3_DIGIT_ZIP BETWEEN 290 AND 299 THEN 'SC'
         WHEN 3_DIGIT_ZIP BETWEEN 570 AND 577 THEN 'SD'
         WHEN 3_DIGIT_ZIP BETWEEN 370 AND 385 THEN 'TN'
         WHEN 3_DIGIT_ZIP BETWEEN 733 AND 733 THEN 'TX'
         WHEN 3_DIGIT_ZIP BETWEEN 750 AND 799 THEN 'TX'
         WHEN 3_DIGIT_ZIP BETWEEN 885 AND 885 THEN 'TX'
         WHEN 3_DIGIT_ZIP BETWEEN 840 AND 847 THEN 'UT'
         WHEN 3_DIGIT_ZIP BETWEEN 201 AND 201 THEN 'VA'
         WHEN 3_DIGIT_ZIP BETWEEN 220 AND 246 THEN 'VA'
         WHEN 3_DIGIT_ZIP BETWEEN 8 AND 8 THEN 'VI'
         WHEN 3_DIGIT_ZIP BETWEEN 50 AND 54 THEN 'VT'
         WHEN 3_DIGIT_ZIP BETWEEN 56 AND 59 THEN 'VT'
         WHEN 3_DIGIT_ZIP BETWEEN 980 AND 986 THEN 'WA'
         WHEN 3_DIGIT_ZIP BETWEEN 988 AND 994 THEN 'WA'
         WHEN 3_DIGIT_ZIP BETWEEN 530 AND 532 THEN 'WI'
         WHEN 3_DIGIT_ZIP BETWEEN 534 AND 535 THEN 'WI'
         WHEN 3_DIGIT_ZIP BETWEEN 537 AND 549 THEN 'WI'
         WHEN 3_DIGIT_ZIP BETWEEN 247 AND 266 THEN 'WV'
         WHEN 3_DIGIT_ZIP BETWEEN 820 AND 831 THEN 'WY'
         ELSE NULL
       END AS state
FROM   (SELECT person_id,
               city,
               postal_code AS 3_DIGIT_ZIP,
               county,
               /* Clean up states and assign appropriate abbreviation. */
               CASE
                 WHEN upper(state) LIKE 'AK%'
                       OR upper(state) LIKE '%ALASKA%' THEN 'AK'
                 WHEN upper(state) LIKE 'AL%'
                       OR upper(state) LIKE '%ALABAMA%' THEN 'AL'
                 WHEN upper(state) LIKE 'AZ%'
                       OR upper(state) LIKE '%ARIZONA%' THEN 'AZ'
                 WHEN upper(state) LIKE 'AR%'
                       OR upper(state) LIKE '%ARKANSAS%' THEN 'AR'
                 WHEN upper(state) LIKE 'CA%'
                       OR upper(state) LIKE '%CALIFORNIA%' THEN 'CA'
                 WHEN upper(state) LIKE 'CT%'
                       OR upper(state) LIKE '%CONNECTICUT%' THEN 'CT'
                 WHEN upper(state) LIKE 'CO%'
                       OR upper(state) LIKE '%COLORADO%' THEN 'CO'
                 WHEN upper(state) LIKE 'DC%'
                       OR upper(state) LIKE '%DISTRICT OF COLUMBIA%' THEN 'DC'
                 WHEN upper(state) LIKE 'DE%'
                       OR upper(state) LIKE '%DELAWARE%' THEN 'DE'
                 WHEN upper(state) LIKE 'FL%'
                       OR upper(state) LIKE '%FLORIDA%' THEN 'FL'
                 WHEN upper(state) LIKE 'GA%'
                       OR upper(state) LIKE '%GEORGIA%' THEN 'GA'
                 WHEN upper(state) LIKE 'GU%'
                       OR upper(state) LIKE '%GUAM%' THEN 'GU'
                 WHEN upper(state) LIKE 'HI%'
                       OR upper(state) LIKE '%HAWAII%' THEN 'HI'
                 WHEN upper(state) LIKE 'IA%'
                       OR upper(state) LIKE '%IOWA%' THEN 'IA'
                 WHEN upper(state) LIKE 'ID%'
                       OR upper(state) LIKE '%IDAHO%' THEN 'ID'
                 WHEN upper(state) LIKE 'IL%'
                       OR upper(state) LIKE '%ILLINOIS%' THEN 'IL'
                 WHEN upper(state) LIKE 'IN%'
                       OR upper(state) LIKE '%INDIANA%' THEN 'IN'
                 WHEN upper(state) LIKE 'KS%'
                       OR upper(state) LIKE '%KANSAS%' THEN 'KS'
                 WHEN upper(state) LIKE 'KY%'
                       OR upper(state) LIKE '%KENTUCKY%' THEN 'KY'
                 WHEN upper(state) LIKE 'LA%'
                       OR upper(state) LIKE '%LOUISIANA%' THEN 'LA'
                 WHEN upper(state) LIKE 'MD%'
                       OR upper(state) LIKE '%MARYLAND%' THEN 'MD'
                 WHEN upper(state) LIKE 'ME%'
                       OR upper(state) LIKE '%MAINE%' THEN 'ME'
                 WHEN upper(state) LIKE 'MS%'
                       OR upper(state) LIKE '%MISSISSIPPI%' THEN 'MS'
                 WHEN upper(state) LIKE 'MN%'
                       OR upper(state) LIKE '%MINNESOTA%' THEN 'MN'
                 WHEN upper(state) LIKE 'MT%'
                       OR upper(state) LIKE '%MONTANA%' THEN 'MT'
                 WHEN upper(state) LIKE 'MO%'
                       OR upper(state) LIKE '%MISSOURI%' THEN 'MO'
                 WHEN upper(state) LIKE 'MI%'
                       OR upper(state) LIKE '%MICHIGAN%' THEN 'MI'
                 WHEN upper(state) LIKE 'MA%'
                       OR upper(state) LIKE '%MASSACHUSETTS%' THEN 'MA'
                 WHEN upper(state) LIKE 'NC%'
                       OR upper(state) LIKE '%NORTH CAROLINA%' THEN 'NC'
                 WHEN upper(state) LIKE 'ND%'
                       OR upper(state) LIKE '%NORTH DAKOTA%' THEN 'ND'
                 WHEN upper(state) LIKE 'NH%'
                       OR upper(state) LIKE '%NEW HAMPSHIRE%' THEN 'NH'
                 WHEN upper(state) LIKE 'NJ%'
                       OR upper(state) LIKE '%NEW JERSEY%' THEN 'NJ'
                 WHEN upper(state) LIKE 'NM%'
                       OR upper(state) LIKE '%NEW MEXICO%' THEN 'NM'
                 WHEN upper(state) LIKE 'NV%'
                       OR upper(state) LIKE '%NEVADA%' THEN 'NV'
                 WHEN upper(state) LIKE 'NY%'
                       OR upper(state) LIKE '%NEW YORK%' THEN 'NY'
                 WHEN upper(state) LIKE 'NE%'
                       OR upper(state) LIKE '%NEBRASKA%' THEN 'NE'
                 WHEN upper(state) LIKE 'OH%'
                       OR upper(state) LIKE '%OHIO%' THEN 'OH'
                 WHEN upper(state) LIKE 'OK%'
                       OR upper(state) LIKE '%OKLAHOMA%' THEN 'OK'
                 WHEN upper(state) LIKE 'OR%'
                       OR upper(state) LIKE '%OREGON%' THEN 'OR'
                 WHEN upper(state) LIKE 'PA%'
                       OR upper(state) LIKE '%PENNSYLVANIA%' THEN 'PA'
                 WHEN upper(state) LIKE 'RI%'
                       OR upper(state) LIKE '%RHODE ISLAND%' THEN 'RI'
                 WHEN upper(state) LIKE 'SC%'
                       OR upper(state) LIKE '%SOUTH CAROLINA%' THEN 'SC'
                 WHEN upper(state) LIKE 'SD%'
                       OR upper(state) LIKE '%SOUTH DAKOTA%' THEN 'SD'
                 WHEN upper(state) LIKE 'TN%'
                       OR upper(state) LIKE '%TENNESSEE%' THEN 'TN'
                 WHEN upper(state) LIKE 'TX%'
                       OR upper(state) LIKE '%TEXAS%' THEN 'TX'
                 WHEN upper(state) LIKE 'UT%'
                       OR upper(state) LIKE '%UTAH%' THEN 'UT'
                 WHEN upper(state) LIKE 'VT%'
                       OR upper(state) LIKE '%VERMONT%' THEN 'VT'
                 WHEN upper(state) LIKE 'WA%'
                       OR upper(state) LIKE '%WASHINGTON%' THEN 'WA'
                 WHEN upper(state) LIKE 'WI%'
                       OR upper(state) LIKE '%WISCONSIN%' THEN 'WI'
                 WHEN upper(state) LIKE 'WV%'
                       OR upper(state) LIKE '%WEST VIRGINIA%' THEN 'WV'
                 WHEN upper(state) LIKE 'WY%'
                       OR upper(state) LIKE '%WYOMING%' THEN 'WY'
                 WHEN upper(state) LIKE 'VA%'
                       OR upper(state) LIKE '%VIRGINIA%' THEN 'VA'
                 WHEN upper(state) LIKE 'PR%'
                       OR upper(state) LIKE '%PUERTO RICO%' THEN 'PR'
                 WHEN upper(state) LIKE 'VIRGIN ISLANDS%'
                       OR upper(state) LIKE '%VI%' THEN 'VI'
                 ELSE NULL
               END AS state
        FROM   Analytic_ll_person_table) x 

-- census_divisions code
SELECT *, 
CASE 
    WHEN subregion IN ('New England','Middle Atlantic') THEN 'Northeast'
    WHEN subregion IN ('East North Central', 'West North Central') THEN 'Midwest'
    WHEN subregion IN ('South Atlantic', 'East South Central', 'West South Central') THEN 'South'
    WHEN subregion IN ('Mountain', 'Pacific') THEN 'West'
ELSE 'Missing'
END AS region
FROM
(SELECT *, 
CASE 
    WHEN state IN ('ME', 'NH', 'VT', 'MA', 'CT', 'RI') THEN 'New England'
    WHEN state IN ('NJ', 'NY', 'PA') THEN 'Middle Atlantic'
    WHEN state IN ('IN', 'OH', 'MI', 'IL', 'WI') THEN 'East North Central'
    WHEN state IN ('IA', 'NE', 'KS', 'ND', 'MN', 'SD', 'MO') THEN 'West North Central'
    WHEN state IN ('DE', 'DC', 'FL', 'GA', 'MD', 'NC', 'SC', 'VA', 'WV') Then 'South Atlantic'
    WHEN state IN ('AL', 'KY', 'MS', 'TN') Then 'East South Central'
    WHEN state IN ('AR', 'LA', 'OK', 'TX') Then 'West South Central'
    WHEN state IN ('MT', 'WY', 'CO', 'NM', 'AZ', 'UT', 'NV', 'ID') Then 'Mountain'
    WHEN state IN ('CA', 'HI', 'OR', 'AK', 'WA') Then 'Pacific'
    ELSE 'Missing'
END AS subregion
FROM state_cleaning) x

-- cci_calculation code
SELECT person_id, CAST((MI+CHF+PVD+CVD+DEM+COPD+RD+PEP+LIV+DIA+HEM+REN+CAN+HIV) AS INT) AS CCI_BEFORE_COVID
FROM
(SELECT person_id,
MYOCARDIALINFARCTION_before_or_day_of_covid_indicator * 1 AS MI,
HEARTFAILURE_before_or_day_of_covid_indicator * 1 AS CHF,
PERIPHERALVASCULARDISEASE_before_or_day_of_covid_indicator * 1 AS PVD,
CEREBROVASCULARDISEASE_before_or_day_of_covid_indicator * 1 AS CVD,
DEMENTIA_before_or_day_of_covid_indicator * 1 AS DEM,
CHRONICLUNGDISEASE_before_or_day_of_covid_indicator * 1 AS COPD,
RHEUMATOLOGICDISEASE_before_or_day_of_covid_indicator * 1 AS RD,
PEPTICULCER_before_or_day_of_covid_indicator * 1 AS PEP,
CASE WHEN MODERATESEVERELIVERDISEASE_before_or_day_of_covid_indicator = 0 THEN MILDLIVERDISEASE_before_or_day_of_covid_indicator * 1 WHEN MODERATESEVERELIVERDISEASE_before_or_day_of_covid_indicator = 1 THEN MODERATESEVERELIVERDISEASE_before_or_day_of_covid_indicator * 3 ELSE 0 END AS LIV,
CASE WHEN DIABETESCOMPLICATED_before_or_day_of_covid_indicator = 0 THEN DIABETESUNCOMPLICATED_before_or_day_of_covid_indicator * 1 WHEN  DIABETESCOMPLICATED_before_or_day_of_covid_indicator = 1 THEN DIABETESCOMPLICATED_before_or_day_of_covid_indicator * 2 ELSE 0 END AS DIA,
HEMIPLEGIAORPARAPLEGIA_before_or_day_of_covid_indicator * 2 AS HEM,
KIDNEYDISEASE_before_or_day_of_covid_indicator * 2 AS REN,
CASE WHEN METASTATICSOLIDTUMORCANCERS_before_or_day_of_covid_indicator = 0 THEN MALIGNANTCANCER_before_or_day_of_covid_indicator * 2 WHEN METASTATICSOLIDTUMORCANCERS_before_or_day_of_covid_indicator = 1 THEN METASTATICSOLIDTUMORCANCERS_before_or_day_of_covid_indicator * 6 ELSE 0 END AS CAN,
HIVINFECTION_before_or_day_of_covid_indicator * 6 AS HIV 
FROM Analytic_ll_person_table ) x

-- race_ethnicity code
SELECT person_id, CASE WHEN race_ethnicity IN ('White Non-Hispanic', 'Black or African American Non-Hispanic', 'Hispanic or Latino Any Race', 'Unknown') THEN race_ethnicity ELSE 'Other' END AS race_ethnicity
FROM Analytic_ll_person_table

-- race_ethnicity code
SELECT person_id, MIN(DATEDIFF(date, COVID_first_poslab_or_diagnosis_date)) AS time_covid_to_hospitalization
FROM Analytic_ll_visit_table 
WHERE during_macrovisit_hospitalization = 1
-- Note that depending on your flavor of SQL, the DATEDIFF order swaps.
-- In Spark SQL it is DATEDIFF(endDate, startDate). 
AND DATEDIFF(date, COVID_first_poslab_or_diagnosis_date) BETWEEN 0 AND 14
GROUP BY person_id

-- covid_death_within_30_days code
SELECT person_id, MIN(DATEDIFF(date, COVID_first_poslab_or_diagnosis_date)) AS time_covid_to_death, MIN(date) AS death_or_hospice_date
FROM Analytic_ll_visit_table 
WHERE COVID_patient_death = 1
-- Note that depending on your flavor of SQL, the DATEDIFF order swaps.
-- In Spark SQL it is DATEDIFF(endDate, startDate). 
AND DATEDIFF(date, COVID_first_poslab_or_diagnosis_date) BETWEEN 0 AND 30
GROUP BY person_id

-- malnutrition_exposure code
SELECT 
    a.person_id, 
    CASE WHEN earliest_malnutrition_date < COVID_first_poslab_or_diagnosis_date THEN 'Hx of Malnutrition'
    -- Note that this is a simplification of what we did. In the study, we identied the first hospitalization and 
    -- identified malnutrition documented during that hospitalization. 
    WHEN DATEDIFF(earliest_malnutrition_date, COVID_first_poslab_or_diagnosis_date) BETWEEN 0 AND 30 THEN 'Hospital-Acquired Malnutrition'
    ELSE 'No Malnutrition Documented'
    END AS malnutrition
FROM Analytic_ll_person_table a
LEFT JOIN
(
    SELECT person_id, MIN(date) AS earliest_malnutrition_date
    FROM Analytic_ll_visit_table
    WHERE MALNUTRITION = 1
    GROUP BY person_id
) mal ON mal.person_id = a.person_id 