Session 3 Homework
==============================

Session 3 has two assignments:
1. [Before Session 3 Starts](#before-session-3-starts)
1. [After Session 3 Ends](#after-session-3-ends)


Before Session 3 Starts
------------------------------

Before Session 3,
please complete the reading list and
then create four Code Workbooks.

### Reading

* Reread G2N3C's [Section 8.4.3](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/chapters/tools.html#sec-tools-apps-workbook) that focuses on Code Workbooks
* Watch the video (??need link??)
* Brush up your SQL.  If you don't have an intro book available, I recommend lessons 1-12 of the interactive [SQLBolt](https://sqlbolt.com/).
* Brush up your R or Python.  We won't be programming a lot during class, but you'll need to know enough to follow the rough approach.
  Common recommendations include:
  * [*R for Data Science*, 2E](https://r4ds.hadley.nz/)
  * [*Python for Data Analysis*, 3E](https://wesmckinney.com/book/)
* Read the OMOP & N3C documentation for a few important tables we'll use in Session 3:
  * OMOP's [`person`](https://ohdsi.github.io/CommonDataModel/cdm60.html#PERSON)
  * OMOP's [`observation`](https://ohdsi.github.io/CommonDataModel/cdm60.html#OBSERVATION)
  * OMOP's [`condition_occurrence`](https://ohdsi.github.io/CommonDataModel/cdm60.html#CONDITION_OCCURRENCE)
  * N3C's [covid patients](https://unite.nih.gov/workspace/module/view/latest/ri.workshop.main.module.3ab34203-d7f3-482e-adbd-f4113bfd1a2b?id=KO-BE5C652&view=focus) fact table assembled by the [logic liaisons](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/chapters/support.html#sec-support-liaisons-logic)
    * Read the first part carefully (about two pages).
    * For the sake of Session 3, you can skim starting at the variable definitions in the "DATA DICTIONARY" section.
      But when you use it in a real analysis in a few weeks/months, please the whole document carefully.

### Log into the Enclave and create your personal directory for this class.

The section resembles the [Week 1 Assignment](https://github.com/National-COVID-Cohort-Collaborative/short-course-2024-january/blob/main/sessions/session-1/session-1-assignment.pdf)
so refer to that if you forgot some steps.

1.  Log in to the Enclave, with MFA.
1.  In our class's [L0
    workspace](https://unite.nih.gov/workspace/compass/view/ri.compass.main.folder.86a7020f-db30-4fd1-b735-bbaf53512365),
    open to the "Users/" directory and create your personal folder.
    (if it doesn't already exist).
    For directory & file names, I like [kebab
    case](https://www.freecodecamp.org/news/snake-case-vs-camel-case-vs-pascal-case-vs-kebab-case-whats-the-difference/#kebab-case)
    (eg, "will-beasley", jerrod-anzalone", "james-cheng").

### Create the `manipulation-1` Code Workbook

1.  Make sure you're in the root of your personal directory.
1.  Create a new "Code Workbook".
1.  Once the workbook opens, rename it to "manipulation-1".
    Then say, "Rename" when it asks,
    "Also rename the output folder to `manipulation-1`?"
    (Rename the workbook once it's open, so these behind-the-scenes files are appropriately adjusted.)
1.  Change the environment.
    1.  In the top center of the screen, click the lightning bolt near
        "Environment (default-r-3.5)"
    1.  Click "Configure Environment"
    1.  In the left-hand Profiles panel, click
        "profile-high-driver-cores-and-memory-*limited*". (Remarks that
        will make sense later: \#1 For workbooks that rely on R, we'll
        chose "r4-high-driver-memory". \#2 We're using small datasets
        this session; use more memory for real projects, such as
        "profile-high-driver-cores-and-memory".)
    1.  Click the blue "Update Environment" button.
    1.  Wait a few minutes, or go back to the directory screen and continue creating workbooks.
        It take the servers a few minutes to create environment.

### Create the `graphs-1` Code Workbook

1. Follow the same steps as `manipulation-1`, except
1. Rename it `graphs-1` and
1. Choose the "r4-high-driver-memory" environment.

### Create the `validation-1` Code Workbook

1. Follow the same steps as `manipulation-1`, except
1. Rename it `validation-1` and
1. Choose the "r4-high-driver-memory" environment.

### Create the `modeling-1` Code Workbook

1.  Follow the same steps as `manipulation-1`, except
1.  Rename it `modeling-1` and
1.  Choose the "r4-high-driver-memory" environment.
1.  *Before* clicking "Update environment", add one additional packages:
    1. Click "Customize Profile"
    1. Search for "r-emmeans" and click the green plus button
1.  Click the blue "Update Environment" button.

Note: when you customize an environment, it takes longer to build.
And there's a chance the package versions don't resolve correctly.
So don't add unnecessary packages.

### Crate a README Notepad document

1.  In the root of your personal directory
    (eg, `Users/will-beasley`)
1.  Add a new "Notepad document"
1.  When it opens, rename it to "README"
1.  Add important info and links to help connect different things, like
    1.  Non-Enclave locations your group uses like Google Drive & a GitHub repo
    1.  Link to your group's meeting notes (eg, in Google Docs)
    1.  Link to your group's manuscript & supplement drafts
    1.  Concept sets used or discussed
1.  Describe the workflow among code workbooks.  For Session 3, the order is
    1.  `manipulation-1`
    1.  `graphs-1`
    1.  `validation-1`
    1.  `modeling-1`
1.  For this class, some important resources are
    1.  Our class's GitHub [file repository](https://github.com/National-COVID-Cohort-Collaborative/short-course-2024-january)
    1.  The dataset simulated for this Session, which is stored in the Enclave.
        I like including both the
        * direct link:
          <https://unite.nih.gov/workspace/compass/view/ri.compass.main.folder.32f8e987-c58c-44a0-bff8-8b8fb3d15805>
        * spelled-out path:
          `N3C Training Area/Group Exercises/Introduction to Real World Data Analysis for COVID-19 Research, Spring 2024/analysis-with-synthetic-data/`

**Resources**

* [*The Researcher's Guide to
  N3C*](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/)
  - [Section 8.4.3 Code
    Workbooks](https://national-covid-cohort-collaborative.github.io/guide-to-n3c-v1/chapters/tools.html#sec-tools-apps-workbook)
* [N3C Office Hours](https://covid.cd2h.org/support/) on Tuesdays & Thursdays
* [OMOP tables](https://ohdsi.github.io/CommonDataModel/cdm53.html)

After Session 3 Ends
------------------------------

### Create & Successfully Run Workbooks & Transforms

### Assignments & Questions for `manipulation-1`

1. Incorporate the `condition_occurrence` table.

### Assignments & Questions for `graphs-1`

1.  Which `data_partner` has the *lowest* prevalence of moderate (or worse) covid?  How can you tell?
1.  Which `data_partner` has the *highest* prevalence of moderate (or worse) covid?  How can you tell?
1.  The `data_partner` with the highest prevalence of developing moderate covid does not necessarily mean
    their providers are doing the worst job taking care of their patients.
    Why?
    What are some confounds you can think of?
    How could you start to control for these confounds?
1.  Improve cosmetically (eg, better axis labels)
1.  Improve the graphs in some way, even if it's just a cosmetic improvement. QQQ Give them more direction QQQ
    What did you change and how did you do it?

    qqq let them decide between R or Python for their assignment qqq

### Assignments & Questions for `validation-1`

### Assignments & Questions for `modeling-1`

1.  Interpret the coefficients of `m_covid_moderate_3`.  Should be 3-6 sentences.
1.  Improve the model (for `covid_moderate_plus`) in some way.
    What did you change and how did you do it?
1.  Write a hypothesis for a new outcome variable.
    Develop a model for it and describe the results.

### question during prep

1.  what concept set should I add (ideally builds on something you guys have done)
1.  add more comments for code, and tell them about the sections they don't need ot understand --fairy dust
1.  add @image svg
