---
title: Descriptives Report 1
date: "Date: 2023-08-15"
output:
  # radix::radix_article: # radix is a newer alternative that has some advantages over `html_document`.
  html_document:
    keep_md: yes
    toc: 4
    toc_float: true
    number_sections: true
# css: ../common/styles.css         # analysis/common/styles.css
---

  This report covers the analyses used in the ZZZ project (Marcus Mark, PI).

<!--  Set the working directory to the repository's base directory; this assumes the report is nested inside of two directories.-->


<!-- Set the report-wide options, and point to the external code file. -->


<!-- Load 'sourced' R files.  Suppress the output when loading sources. -->


<!-- Load packages, or at least verify they're available on the local machine.  Suppress the output when loading packages. -->


<!-- Load any global functions and variables declared in the R file.  Suppress the output. -->


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. -->


<!-- Load the datasets.   -->


<!-- Tweak the datasets.   -->


Summary {.tabset .tabset-fade .tabset-pills}
===========================================================================

Notes
---------------------------------------------------------------------------

1. The current report covers 100 patients, with 2 unique values for `data_partner_id`.


Unanswered Questions
---------------------------------------------------------------------------

Answered Questions
---------------------------------------------------------------------------


Graphs
===========================================================================


Marginals
---------------------------------------------------------------------------

![](figure-png/marginals-1.png)<!-- -->![](figure-png/marginals-2.png)<!-- -->![](figure-png/marginals-3.png)<!-- -->![](figure-png/marginals-4.png)<!-- -->![](figure-png/marginals-5.png)<!-- -->![](figure-png/marginals-6.png)<!-- -->


Scatterplots
---------------------------------------------------------------------------




Correlation Matrixes
---------------------------------------------------------------------------




Models
===========================================================================

Model Exploration
---------------------------------------------------------------------------



Final Model
---------------------------------------------------------------------------





Session Information {#session-info}
===========================================================================

For the sake of documentation and reproducibility, the current report was rendered in the following environment.  Click the line below to expand.

  <details>
    <summary>Environment <span class="glyphicon glyphicon-plus-sign"></span></summary>
    
    ```
    ─ Session info ─────────────────────────────────────────────
     setting  value
     version  R version 4.3.1 Patched (2023-07-06 r84647 ucrt)
     os       Windows 11 x64 (build 22621)
     system   x86_64, mingw32
     ui       RStudio
     language (EN)
     collate  English_United States.utf8
     ctype    English_United States.utf8
     tz       America/Chicago
     date     2023-08-15
     rstudio  2023.06.1+524 Mountain Hydrangea (desktop)
     pandoc   3.1.5 @ C:/PROGRA~1/Pandoc/ (via rmarkdown)
    
    ─ Packages ─────────────────────────────────────────────────
     ! package         * version    date (UTC) lib source
     D archive           1.1.5      2022-05-06 [1] CRAN (R 4.3.0)
       backports         1.4.1      2021-12-13 [1] CRAN (R 4.3.0)
       base            * 4.3.1      2023-07-06 [?] local
       bit               4.0.5      2022-11-15 [1] CRAN (R 4.3.0)
       bit64             4.0.5      2020-08-30 [1] CRAN (R 4.3.0)
       blob              1.2.4      2023-03-17 [1] CRAN (R 4.3.0)
       bslib             0.5.0      2023-06-09 [1] CRAN (R 4.3.1)
       cachem            1.0.8      2023-05-01 [1] CRAN (R 4.3.0)
       checkmate         2.2.0      2023-04-27 [1] CRAN (R 4.3.0)
       chron             2.3-61     2023-05-02 [1] CRAN (R 4.3.0)
       cli               3.6.1      2023-03-23 [1] CRAN (R 4.3.0)
       colorspace        2.1-0      2023-01-23 [1] CRAN (R 4.3.0)
     P compiler          4.3.1      2023-07-06 [3] local
       config            0.3.1      2020-12-17 [1] CRAN (R 4.3.0)
       crayon            1.5.2      2022-09-29 [1] CRAN (R 4.3.0)
     P datasets        * 4.3.1      2023-07-06 [3] local
       DBI               1.1.3      2022-06-18 [1] CRAN (R 4.3.0)
       digest            0.6.33     2023-07-07 [1] CRAN (R 4.3.1)
       dplyr             1.1.2      2023-04-20 [1] CRAN (R 4.3.0)
       evaluate          0.21       2023-05-05 [1] CRAN (R 4.3.0)
       fansi             1.0.4      2023-01-22 [1] CRAN (R 4.3.0)
       farver            2.1.1      2022-07-06 [1] CRAN (R 4.3.0)
       fastmap           1.1.1      2023-02-24 [1] CRAN (R 4.3.0)
       forcats           1.0.0      2023-01-29 [1] CRAN (R 4.3.0)
       generics          0.1.3      2022-07-05 [1] CRAN (R 4.3.0)
       ggplot2         * 3.4.2      2023-04-03 [1] CRAN (R 4.3.0)
       glue              1.6.2      2022-02-24 [1] CRAN (R 4.3.0)
     P graphics        * 4.3.1      2023-07-06 [3] local
     P grDevices       * 4.3.1      2023-07-06 [3] local
     P grid              4.3.1      2023-07-06 [3] local
       gsubfn            0.7        2018-03-16 [1] CRAN (R 4.3.0)
       gtable            0.3.3      2023-03-21 [1] CRAN (R 4.3.0)
       highr             0.10       2022-12-22 [1] CRAN (R 4.3.0)
       hms               1.1.3      2023-03-21 [1] CRAN (R 4.3.0)
       htmltools         0.5.5      2023-03-23 [1] CRAN (R 4.3.0)
       jquerylib         0.1.4      2021-04-26 [1] CRAN (R 4.3.0)
       jsonlite          1.8.7      2023-06-29 [1] CRAN (R 4.3.1)
       knitr           * 1.43       2023-05-25 [1] CRAN (R 4.3.0)
       labeling          0.4.2      2020-10-20 [1] CRAN (R 4.3.0)
       lifecycle         1.0.3      2022-10-07 [1] CRAN (R 4.3.0)
       lubridate         1.9.2      2023-02-10 [1] CRAN (R 4.3.0)
       magrittr          2.0.3      2022-03-30 [1] CRAN (R 4.3.0)
       memoise           2.0.1      2021-11-26 [1] CRAN (R 4.3.0)
     P methods         * 4.3.1      2023-07-06 [3] local
       munsell           0.5.0      2018-06-12 [1] CRAN (R 4.3.0)
       odbc              1.3.5      2023-06-29 [1] CRAN (R 4.3.1)
       OuhscMunge        0.2.0.9015 2023-05-25 [1] Github (OuhscBbmc/OuhscMunge@497aa52)
     P parallel          4.3.1      2023-07-06 [3] local
       pillar            1.9.0      2023-03-22 [1] CRAN (R 4.3.0)
       pkgconfig         2.0.3      2019-09-22 [1] CRAN (R 4.3.0)
       proto             1.0.0      2016-10-29 [1] CRAN (R 4.3.0)
       purrr             1.0.2      2023-08-10 [1] CRAN (R 4.3.1)
       R6                2.5.1      2021-08-19 [1] CRAN (R 4.3.0)
       Rcpp              1.0.11     2023-07-06 [1] CRAN (R 4.3.1)
       readr             2.1.4      2023-02-10 [1] CRAN (R 4.3.0)
       rlang             1.1.1      2023-04-28 [1] CRAN (R 4.3.0)
       rmarkdown         2.23       2023-07-01 [1] CRAN (R 4.3.1)
       RSQLite         * 2.3.1      2023-04-03 [1] CRAN (R 4.3.0)
       rstudioapi        0.15.0     2023-07-07 [1] CRAN (R 4.3.1)
       sass              0.4.7      2023-07-15 [1] CRAN (R 4.3.1)
       scales            1.2.1      2022-08-20 [1] CRAN (R 4.3.0)
       sessioninfo       1.2.2      2021-12-06 [1] CRAN (R 4.3.0)
       sqldf             0.4-11     2017-06-28 [1] CRAN (R 4.3.0)
     P stats           * 4.3.1      2023-07-06 [3] local
       TabularManifest   0.2.1      2023-05-25 [1] Github (Melinae/TabularManifest@c50ae48)
     P tcltk             4.3.1      2023-07-06 [3] local
       testit            0.13       2021-04-14 [1] CRAN (R 4.3.0)
       tibble            3.2.1      2023-03-20 [1] CRAN (R 4.3.0)
       tidyr             1.3.0      2023-01-24 [1] CRAN (R 4.3.0)
       tidyselect        1.2.0      2022-10-10 [1] CRAN (R 4.3.0)
       timechange        0.2.0      2023-01-11 [1] CRAN (R 4.3.0)
     P tools             4.3.1      2023-07-06 [3] local
       tzdb              0.4.0      2023-05-12 [1] CRAN (R 4.3.0)
       utf8              1.2.3      2023-01-31 [1] CRAN (R 4.3.0)
     P utils           * 4.3.1      2023-07-06 [3] local
       vctrs             0.6.3      2023-06-14 [1] CRAN (R 4.3.1)
       vroom             1.6.3      2023-04-28 [1] CRAN (R 4.3.0)
       withr             2.5.0      2022-03-03 [1] CRAN (R 4.3.0)
       xfun              0.40       2023-08-09 [1] CRAN (R 4.3.1)
       yaml              2.3.7      2023-01-23 [1] CRAN (R 4.3.0)
    
     [1] D:/projects/r-libraries
     [2] C:/Users/wibea/AppData/Local/R/win-library/4.3
     [3] C:/Program Files/R/R-4.3.1patched/library
    
     P ── Loaded and on-disk path mismatch.
     D ── DLL MD5 mismatch, broken installation.
    
    ────────────────────────────────────────────────────────────
    ```
  </details>



Report rendered by wibea at 2023-08-15, 15:33 -0500 in 1 seconds.
