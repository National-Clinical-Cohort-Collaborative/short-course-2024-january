
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
  pecked or buttened

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
4.  Hold \[shift\], click `observation` and `patient`, and click the
    blue “Select” button.

## Create Initial SQL Transforms and Write SQL Code

1.  Click the `patient` transform, then click the blue plus button, then
    select “SQL code”.

2.  Click the gray plus button (above the code), and click the
    `observation` transform.

3.  Change the new transform’s name from “unnamed” to
    “pt_observation_preceding”.

4.  Click “Save as dataset”, so it’s toggled blue.

5.  Verify that you have two inputs: `patient` & `observation`. The
    colors are orange & purple, but the order doesn’t matter.

6.  Replace the code with

    ``` sql
     WITH obs_before as (
       SELECT
         o.observation_id
         ,o.person_id
         ,o.observation_concept_id
         ,o.observation_date
         ,datediff(o.observation_date, p.covid_date) as dx_days_before_covid  -- SparkSQL syntax
         --,datediff('day', o.observation_date, p.covid_date) as dx_days_before_covid -- most other SQL flavors
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
     )
     SELECT
       *
     FROM obs_before
     WHERE index_within_pt = 1
    ```

7.  Verify resulting table has 6 columns & 64 rows.  

8.  Notice `pt_observation` has fewer rows than `patient`.

    - Q1: Why?  
    - Q2: Can we use `pt_observation` directly in the analysis? Why not?
    - Q3: What rows are missing from `pt_observation`, and how can we
      fill in those rows?

## Save as Rds File
