---
title: Descriptives Report 1
date: "Date: 2023-08-24"
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

1. The current report covers 100 patients, with 3 unique values for `data_partner_id`.


Unanswered Questions
---------------------------------------------------------------------------

Answered Questions
---------------------------------------------------------------------------


Univariate
===========================================================================

`person` table
---------------------------------------------------------------------------

![](figure-png/marginals-person-1.png)<!-- -->![](figure-png/marginals-person-2.png)<!-- -->![](figure-png/marginals-person-3.png)<!-- -->![](figure-png/marginals-person-4.png)<!-- -->![](figure-png/marginals-person-5.png)<!-- -->![](figure-png/marginals-person-6.png)<!-- -->![](figure-png/marginals-person-7.png)<!-- -->![](figure-png/marginals-person-8.png)<!-- -->

`patient` table
---------------------------------------------------------------------------

![](figure-png/marginals-patient-1.png)<!-- -->![](figure-png/marginals-patient-2.png)<!-- -->![](figure-png/marginals-patient-3.png)<!-- -->![](figure-png/marginals-patient-4.png)<!-- -->![](figure-png/marginals-patient-5.png)<!-- -->

`patient_latent` table
---------------------------------------------------------------------------

![](figure-png/marginals-patient_latent-1.png)<!-- -->


Multivariate
===========================================================================

Scatterplots
---------------------------------------------------------------------------

![](figure-png/scatterplots-1.png)<!-- -->![](figure-png/scatterplots-2.png)<!-- -->![](figure-png/scatterplots-3.png)<!-- -->![](figure-png/scatterplots-4.png)<!-- -->


Correlation Matrixes
---------------------------------------------------------------------------

![](figure-png/correlation-matrixes-1.png)<!-- -->![](figure-png/correlation-matrixes-2.png)<!-- -->

|                                 | latent<br>risk| calc<br>age<br>covid| calc<br>outbreak<br>lag<br>years|
|:--------------------------------|--------------:|--------------------:|--------------------------------:|
|latent<br>risk                   |          1.000|                0.637|                           -0.151|
|calc<br>age<br>covid             |          0.637|                1.000|                            0.115|
|calc<br>outbreak<br>lag<br>years |         -0.151|                0.115|                            1.000|


Models
===========================================================================

Model Exploration
---------------------------------------------------------------------------

```
============= Simple model that's just an intercept. =============
```

```

Call:
lm(formula = latent_risk ~ 1, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.0664 -1.3099  0.1101  1.5069  4.4186 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)   1.2214     0.1895   6.445 4.23e-09

Residual standard error: 1.895 on 99 degrees of freedom
```

```
============= Model includes one predictor: `outbreak_lag`. =============
```

```

Call:
lm(formula = latent_risk ~ 1 + calc_outbreak_lag_years, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-5.9510 -1.2049  0.0603  1.4355  4.0833 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)
(Intercept)               1.9558     0.5221   3.746 0.000303
calc_outbreak_lag_years  -0.4292     0.2845  -1.508 0.134693

Residual standard error: 1.883 on 98 degrees of freedom
Multiple R-squared:  0.02269,	Adjusted R-squared:  0.01271 
F-statistic: 2.275 on 1 and 98 DF,  p-value: 0.1347
```

```
============= Model includes one predictor: `calc_age_covid`. =============
```

```

Call:
lm(formula = latent_risk ~ 1 + calc_age_covid, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.5786 -0.8834 -0.0526  0.9609  3.8328 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)
(Intercept)    -0.705321   0.277327  -2.543   0.0125
calc_age_covid  0.042451   0.005184   8.188 1.01e-12

Residual standard error: 1.468 on 98 degrees of freedom
Multiple R-squared:  0.4062,	Adjusted R-squared:  0.4002 
F-statistic: 67.05 on 1 and 98 DF,  p-value: 1.005e-12
```

```
============= Model includes two predictors. =============
```

```

Call:
lm(formula = latent_risk ~ 1 + calc_outbreak_lag_years + calc_age_covid, 
    data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.3439 -0.9266 -0.0575  0.9118  3.2998 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)
(Intercept)              0.322437   0.432856   0.745  0.45813
calc_outbreak_lag_years -0.646705   0.214600  -3.014  0.00329
calc_age_covid           0.044191   0.005016   8.809 4.98e-14

Residual standard error: 1.411 on 97 degrees of freedom
Multiple R-squared:  0.4571,	Adjusted R-squared:  0.4459 
F-statistic: 40.83 on 2 and 97 DF,  p-value: 1.367e-13
```


Final Model
---------------------------------------------------------------------------


|                        | Estimate| Std. Error| t value| Pr(>&#124;t&#124;)|
|:-----------------------|--------:|----------:|-------:|------------------:|
|(Intercept)             |     0.32|       0.43|    0.74|               0.46|
|calc_outbreak_lag_years |    -0.65|       0.21|   -3.01|               0.00|
|calc_age_covid          |     0.04|       0.01|    8.81|               0.00|



Session Information {#session-info}
===========================================================================

For the sake of documentation and reproducibility, the current report was rendered in the following environment.  Click the line below to expand.

  <details>
    <summary>Environment <span class="glyphicon glyphicon-plus-sign"></span></summary>
    
    ```
    ─ Session info ──────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.3.1 Patched (2023-07-06 r84647 ucrt)
     os       Windows 11 x64 (build 22621)
     system   x86_64, mingw32
     ui       RStudio
     language (EN)
     collate  English_United States.utf8
     ctype    English_United States.utf8
     tz       America/Chicago
     date     2023-08-24
     rstudio  2023.06.1+524 Mountain Hydrangea (desktop)
     pandoc   3.1.5 @ C:/PROGRA~1/Pandoc/ (via rmarkdown)
    
    ─ Packages ──────────────────────────────────────────────────────────────────
     ! package         * version    date (UTC) lib source
     D archive           1.1.5      2022-05-06 [1] CRAN (R 4.3.0)
       arrow             12.0.1.1   2023-07-18 [1] CRAN (R 4.3.1)
       assertthat        0.2.1      2019-03-21 [1] CRAN (R 4.3.0)
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
       corrplot          0.92       2021-11-18 [1] CRAN (R 4.3.0)
       crayon            1.5.2      2022-09-29 [1] CRAN (R 4.3.0)
     P datasets        * 4.3.1      2023-07-06 [3] local
       DBI               1.1.3      2022-06-18 [1] CRAN (R 4.3.0)
       digest            0.6.33     2023-07-07 [1] CRAN (R 4.3.1)
       dplyr             1.1.2      2023-04-20 [1] CRAN (R 4.3.0)
       duckdb            0.8.1-1    2023-07-17 [1] CRAN (R 4.3.1)
       evaluate          0.21       2023-05-05 [1] CRAN (R 4.3.0)
       fansi             1.0.4      2023-01-22 [1] CRAN (R 4.3.0)
       farver            2.1.1      2022-07-06 [1] CRAN (R 4.3.0)
       fastmap           1.1.1      2023-02-24 [1] CRAN (R 4.3.0)
       forcats           1.0.0      2023-01-29 [1] CRAN (R 4.3.0)
       fs                1.6.3      2023-07-20 [1] CRAN (R 4.3.1)
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
       lattice           0.21-8     2023-04-05 [3] CRAN (R 4.3.1)
       lifecycle         1.0.3      2022-10-07 [1] CRAN (R 4.3.0)
       lubridate         1.9.2      2023-02-10 [1] CRAN (R 4.3.0)
       magrittr          2.0.3      2022-03-30 [1] CRAN (R 4.3.0)
       Matrix            1.6-0      2023-07-08 [1] CRAN (R 4.3.1)
       memoise           2.0.1      2021-11-26 [1] CRAN (R 4.3.0)
     P methods         * 4.3.1      2023-07-06 [3] local
       mgcv              1.8-42     2023-03-02 [3] CRAN (R 4.3.1)
       munsell           0.5.0      2018-06-12 [1] CRAN (R 4.3.0)
       n3cshortcourse  * 0.0.0.9000 2023-08-24 [1] local
       nlme              3.1-162    2023-01-31 [3] CRAN (R 4.3.1)
       OuhscMunge        0.2.0.9015 2023-05-25 [1] Github (OuhscBbmc/OuhscMunge@497aa52)
     P parallel          4.3.1      2023-07-06 [3] local
       pillar            1.9.0      2023-03-22 [1] CRAN (R 4.3.0)
       pkgconfig         2.0.3      2019-09-22 [1] CRAN (R 4.3.0)
       proto             1.0.0      2016-10-29 [1] CRAN (R 4.3.0)
       purrr             1.0.2      2023-08-10 [1] CRAN (R 4.3.1)
       R6                2.5.1      2021-08-19 [1] CRAN (R 4.3.0)
       readr             2.1.4      2023-02-10 [1] CRAN (R 4.3.0)
       rlang             1.1.1      2023-04-28 [1] CRAN (R 4.3.0)
       rmarkdown         2.23       2023-07-01 [1] CRAN (R 4.3.1)
       RSQLite         * 2.3.1      2023-04-03 [1] CRAN (R 4.3.0)
       rstudioapi        0.15.0     2023-07-07 [1] CRAN (R 4.3.1)
       sass              0.4.7      2023-07-15 [1] CRAN (R 4.3.1)
       scales            1.2.1      2022-08-20 [1] CRAN (R 4.3.0)
       sessioninfo       1.2.2      2021-12-06 [1] CRAN (R 4.3.0)
     P splines           4.3.1      2023-07-06 [3] local
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
    
    ─────────────────────────────────────────────────────────────────────────────
    ```
  </details>



Report rendered by wibea at 2023-08-24, 14:12 -0500 in 3 seconds.
