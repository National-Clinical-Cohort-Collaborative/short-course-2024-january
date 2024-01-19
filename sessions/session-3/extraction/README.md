
# Data Extraction & Assembly with Synthetic Data

Feb 1, 2024

Combining multiple OMOP tables into a single R data frame that can be
analyzed.

This is part of the [Analysis with Synthetic Data](../) session.

## Important Terminology for this Lesson

- *table grain*: what one row in a table represents. For example, the
  grain of the
  [`person`](https://ohdsi.github.io/CommonDataModel/cdm60.html#PERSON)
  table is “person”; each row represents one distinct person/patient.
  Similarly, the grain of the
  [`visit_occurrence`](https://ohdsi.github.io/CommonDataModel/cdm60.html#VISIT_OCCURRENCE)
  table is “visit”; each row represents one distinct visit/encounter the
  patient had with the health system..

## Start a “Code Workbook” in the Foundry Enclave

1.  In our class’s [L0
    workspace](https://unite.nih.gov/workspace/compass/view/ri.compass.main.folder.86a7020f-db30-4fd1-b735-bbaf53512365),
    open to the “Users/” directory and create your personal folder. I
    like [kebab
    case](https://www.freecodecamp.org/news/snake-case-vs-camel-case-vs-pascal-case-vs-kebab-case-whats-the-difference/#kebab-case)
    for directory & file names (eg, “will-beasley”, “jerrod-anzalone”,
    “james-cheng”).
2.  Create a new “Code Workbook”.
3.  Once the workbook opens, rename it to “manipulation-1”. (Rename it
    once it’s open, so some behdin-the-scenes files are approrpiately
    adjusted.)
4.  Change the environment.
    1.  In the top center of the screen, click the lightning bolt near
        “Enviroment (default-r-3.5)”
    2.  Click “Configure Environment”
    3.  In the left-hand Profiles panel, click “r4-high-driver-memory”
    4.  Click the blue “Update Environment” button and wait a few
        minutes.
5.  It will take the servers a few minutes to create environments for
    all of us. So let’s talk concepts next.

**Resources**

- [*The Researcher’s Guide to
  N3C*](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/)
  - [Section 8.4.3 Code
    Workbooks](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/chapters/tools.html#sec-tools-apps-workbook)

## Challenge for Today’s Session –1st Try

- Investigate the observational relationship between covid outcomes and

  - pecked by chicken, initial encounter
    ([W61.33XA](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-/W61.33XA))
    <!--* pecked by chicken, subsequent encounter ([W61.33XD](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-/W61.33XD))-->
  - struck by a chicken, initial encounter
    ([W61.32XA](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-/W61.32XA))
  - struck by a duck, initial encounter
    ([W61.62XA](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-/W61.62XA))
    <!--* struck by a duck, subsequent encounter ([W61.62XD](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-/W61.62XD))-->

  <img src="assets/image-from-rawpixel-id-8929027-svg.svg" alt="chicken" height="200">
  <img src="assets/image-from-rawpixel-id-6770236-svg.svg" alt="duck" height="200">

- In OMOP, ICD codes are translated to SNOMED codes, and can lose some
  granularity.

  | ICD<br>Description    | SNOMED<br>Description     |                                                OMOP Concept ID<br>(OMOP Domain) |
  |:----------------------|:--------------------------|--------------------------------------------------------------------------------:|
  | “pecked by chicken”   | “Peck by bird”            | [4314097](https://athena.ohdsi.org/search-terms/terms/4314097)<br>(Observation) |
  | “struck by a chicken” | “Contact with chicken”    | [1575676](https://athena.ohdsi.org/search-terms/terms/1575676)<br>(Observation) |
  | “struck by a duck”    | “Injury caused by animal” |     [438039](https://athena.ohdsi.org/search-terms/terms/438039)<br>(Condition) |

## Challenge for Today’s Session –2nd Try

- Talk to PI and revise hypothesis so it can be addressed by an OMOP
  dataset.

- The group decides to step back and address the associations of being
  pecked or butted

  | SNOMED<br>Description |                                                OMOP Concept ID<br>(OMOP Domain) |
  |:----------------------|--------------------------------------------------------------------------------:|
  | “Peck by bird”        | [4314097](https://athena.ohdsi.org/search-terms/terms/4314097)<br>(Observation) |
  | “Butted by animal”    | [4314094](https://athena.ohdsi.org/search-terms/terms/4314094)<br>(Observation) |

**Resources**

- [ICD10CM codes for Contact with birds (domestic)
  (wild)](https://www.icd10data.com/ICD10CM/Codes/V00-Y99/W50-W64/W61-#W61.33)

## Identify Source Tables & their Relationships

- In most EHR research, conceptually start with the database’s patient.
  With OMOP, this table is called
  [`person`](https://ohdsi.github.io/CommonDataModel/cdm60.html#PERSON).

- But with N3C, a talented group of people have faced and addressed many
  of the problems we’ll face. So let’s leverage the [Logic
  Liaisons’](https://covid.cd2h.org/liaisons/) contributions to the N3C
  Knowledge Store.

**Resources**

- [OMOP Table
  Structure](https://ohdsi.github.io/CommonDataModel/cdm60.html#Clinical_Data_Tables)
- Logic Liaison Fact Tables
  - [COVID-19 Diagnosed or Lab Confirmed
    Patients](https://unite.nih.gov/workspace/module/view/latest/ri.workshop.main.module.3ab34203-d7f3-482e-adbd-f4113bfd1a2b?id=KO-BE5C652&view=focus)
  - [Combined Variables ALL
    PATIENTS](https://unite.nih.gov/workspace/module/view/latest/ri.workshop.main.module.3ab34203-d7f3-482e-adbd-f4113bfd1a2b?id=KO-DE908D4&view=focus)
- [*The Researcher’s Guide to
  N3C*](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/)
  - [Section 8.3.3 Logic Liaison Fact Tables and
    Templates](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/chapters/tools.html#sec-tools-store-ll0)

## Sketch Plan

## Select Input Datasets

1.  Click the blue “Import dataset” button.
2.  Go to the directory for this class’s L0 DUR: “All \> All projects \>
    N3C Training Area \> Group Exercises \> Introduction to Real World
    Data Analysis for COVID-19 Research, Spring 2024”
3.  Go to the directory that has the simulated for today’s session:
    “analysis-with-synthetic-data”
4.  Hold \[shift\], click `observation` and `patient_ll`, and click the
    blue “Select” button.

## First SQL Transform: Isolate Relevant Animal Event

1.  Click the `patient_ll` transform, then click the blue plus button,
    then select “SQL code”.

2.  Click the gray plus button (above the code), and click the
    `observation` transform.

3.  Change the new transform’s name from “unnamed” to
    `pt_observation_preceding`.

4.  Click “Save as dataset”, so it’s toggled blue.

5.  Verify that you have two inputs: `patient_ll` & `observation`. The
    colors are orange & purple, but the order doesn’t matter.

6.  Replace the code with

    ``` sql
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
        ,p.covid_date
        ,datediff(p.covid_date, o.observation_date) as dx_days_before_covid
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
    SELECT
      observation_id
      ,person_id
      ,observation_concept_id
      ,event_animal
      ,observation_date
      ,dx_days_before_covid
    FROM obs_before
    WHERE index_within_pt_rev = 1
    ```

7.  Click blue “Run” button.  

8.  Verify resulting table has 6 columns & 64 rows.

9.  Notice `pt_observation_preceding` has fewer rows than `patient_ll`.

    - Q1: Why?
    - Q2: Can we use `pt_observation_preceding` directly in the
      analysis? Why not?
    - Q3: What rows are missing from `pt_observation_preceding`, and how
      can we fill in those rows?

## Dissecting Previous SQL Code

1.  `SELECT` clause
2.  `FROM` clause
3.  `inner join` operator
4.  `case when` statement
5.  `row_number()` function
6.  `o.observation_concept_id` in `WHERE` clause
7.  `obs_before` CTE
8.  Second `SELECT` & `FROM` statements
9.  `WHERE index_within_pt_rev = 1`

## Second SQL Transform: Rejoin with `patient_ll`

1.  Go back to this table to get

    1.  …patients that didn’t have a documented animal event.
    2.  …useful variables the logic liaisons calculated for us.

2.  Click the `patient_ll` transform, then click the blue plus button,
    then select “SQL code” (again).

3.  Click the gray plus button (above the code), and click the
    `observation` transform.

4.  Change the new transform’s name from “unnamed” to `patient`.

5.  Click “Save as dataset”, so it’s toggled blue.

6.  Verify that you have two inputs: `patient_ll` & `patient`. The
    colors are orange & purple, but the order doesn’t matter.

7.  Replace the code with

    ``` sql
    SELECT
      p.person_id
      ,p.data_partner_id
      ,p.covid_date
      ,p.covid_severity
      -- ,p.calc_outbreak_lag_years -- There will be some LL columns that won't be relevant to us
      ,p.calc_age_covid
      ,p.length_of_stay
      ,po.event_animal
      ,po.dx_days_before_covid
    FROM patient_ll p
      left  join pt_observation_preceding po on p.person_id = po.person_id
    ```

8.  Click blue “Run” button.  

9.  Verify resulting table has 8 columns & 100 rows.

10. Notice `pt` and `patient_ll` have the same record count.

    - Q1: Why?
    - Q2: If `pt` had *more* records than `patient_ll`, what went wrong?
    - Q3: If `pt` had *fewer* records than `patient_ll`, what went
      wrong?

## Improve `pt` transform

1.  Writing code can be hard. Starting with complex code is almost
    always slower.

2.  Instead start simple, and gradually add complexity.

3.  Replace the code with

    ``` sql
    SELECT
      p.person_id
      ,p.data_partner_id
      ,p.covid_date
      ,p.calc_age_covid
      ,p.length_of_stay
      ,po.event_animal
      ,po.dx_days_before_covid
      ,case
        when p.calc_age_covid is null then 'Unknown'
        when p.calc_age_covid < 0     then 'Unknown'
        when p.calc_age_covid < 19    then '0-18'
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
    ```

4.  Click blue “Run” button.

## Strategies for Organizing Transforms

1.  The `pt_observation_preceding` and `pt` transforms could be combined
    into one transform
2.  Pros for splitting into well-designed segments that are eventually
    assembled.
    1.  Human mind is better an reasoning through one focused piece at a
        time.  
        Development is easier. Communication to teammates is easier
        (especially if different grains are involved).
    2.  Easier to modify later.
    3.  Database engines can better optimize. This is particularly true
        for non-N3C databases you might use, like SQL Server, Oracle,
        Postgres, DuckDB.
3.  Cons for splitting
    1.  Requires more time if you copy & paste code somewhere.

## Beauty of CTES

1.  A [Common Table
    Expression](https://www.atlassian.com/data/sql/using-common-table-expressions)
    (CTE) allows you to write sql code that’s mode top-to-bottom, and
    less inside-out.

2.  Similar cognitive as breaking up complicated monolithic
    transforms/queries into smaller ones.

3.  “Subquery style”

    ``` sql
    SELECT
      observation_id
      ,person_id
      ,observation_concept_id
      ,event_animal
      ,observation_date
      ,dx_days_before_covid
    FROM (
      ...(contents of CTE)...
    ) obs_before
    WHERE index_within_pt_rev = 1
    ```

4.  “CTE style”:

    ``` sql
    WITH obs_before as (
      ...(contents of CTE)...
    )
    SELECT
      observation_id
      ,person_id
      ,observation_concept_id
      ,event_animal
      ,observation_date
      ,dx_days_before_covid
    FROM obs_before
    WHERE index_within_pt_rev = 1
    ```

## Global Code

1.  The [Global
    Code](https://www.palantir.com/docs/foundry/code-workbook/workbooks-global-code/)
    (in a right-hand pane), lets us define variables and functions that
    are available in all code transforms *in the workbook* (not the
    workspace). In today’s “manipulation-1” workbook, we’ll define
    constants that will be used in multiple transforms or define helper
    functions you want to use repeatedly.

``` r
load_packages <- function () {
  library(magrittr)
  requireNamespace("arrow")
  requireNamespace("dplyr")
  requireNamespace("tidyr") 
}
```

## R Transform

## Save as Rds File

## Assignments

1.  Add a new variable to `pt` from an existing input table.
2.  Improve the definition of the `event_animal` variable by using a
    look up table.
3.  Incorporate a new input table into `pt`.
4.  List three areas outside software development where it’s
    advantageous to breakup bigger challenges into smaller ones.
