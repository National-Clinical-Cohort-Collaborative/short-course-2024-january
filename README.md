Introduction to Analyzing Real-World Data<br>Using the National COVID Cohort Collaborative<br>(N3C)
=======

Educational material for the N3C short course, January 2024. (All assignments are contained in the secure Enclave.)

Assets For Students
-------

* This GitHub public repo:<br><https://github.com/National-COVID-Cohort-Collaborative/short-course-2024-january>
* [Syllabus](background/syllabus/Student%20Syllabus%20Short%20Course%202024.pdf)
* N3C Resources
  * *The Researcher's Guide to N3C*: <https://covid.cd2h.org/guide-to-n3c>
  * N3C YouTube Channel: <https://www.youtube.com/channel/UC-_3k5lsVb8g4yqSHAraC_Q>
* OHDSI Resources:
  * *The Book of OHDSI*: <https://ohdsi.github.io/TheBookOfOhdsi>
  * OMOP table structure: <https://ohdsi.github.io/CommonDataModel/cdm53.html>
  * Athena to view OMOP concepts: <https://athena.ohdsi.org/search-terms/terms>
  * Atlas to view concept sets: <https://atlas-demo.ohdsi.org/#/home>
* [Level 0 Workspace](https://unite.nih.gov/workspace/compass/view/ri.compass.main.folder.86a7020f-db30-4fd1-b735-bbaf53512365) (that can be shared to anyone with an Enclave account)
* [Level 2 Workspace](https://unite.nih.gov/workspace/compass/view/ri.compass.main.folder.713d3259-a7b4-43f4-bbac-d1db215aff8b) (that is open only to students of this course)

| Session                                                                                   | Assignments           | Recordings (1)           |
| :---------------------------------------------------------------------------------------- | :-------------------- | :---------           |
| [1. Introduction to N3C](sessions/session-1#readme)                                       | post-work: [due Jan 25](sessions/session-1/session-1-assignment.pdf) |  |
| [2. Vocabularies, OHDSI Tools, and N3C](sessions/session-2#readme)                        | post-work: [due Feb 1](sessions/session-2/session-2-assignment.pdf) |  |
| [3. Analysis Using Synthetic Data](sessions/session-3#readme)                             | pre-work: [due Feb 1](sessions/session-3/homework#before-session-3-starts) &<br>post-work: [due Feb 8](sessions/session-3/homework#after-session-3-ends) | |
| [4. Building an Analytic Dataset<br>Using Shared N3C Resources](sessions/session-4#readme)| pre-work: [due Feb 8](sessions/session-4#homework-before-session-4-starts) |  |
| [5. Analyzing Data Curated from N3C:<br>A Replication Study](sessions/session-5#readme)   |                       |  |
| [6. N3C Policies and Procedures:<br>From Access to Publication](sessions/session-6#readme)|                       |  |

(1) Live class sessions are not consented for public use, enquire for access

Assets For Instructors
-------

* 2022 short course:<br><https://github.com/National-COVID-Cohort-Collaborative/short-course-2022-june>

Installing package

```r
remotes::install_github(
  "National-COVID-Cohort-Collaborative/short-course-2024-january",
  subdir = "workflow"
)
```
