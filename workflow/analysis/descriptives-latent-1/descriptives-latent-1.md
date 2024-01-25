---
title: (Latent) Descriptives Report 1
date: "Date: 2024-01-25"
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

1. The current report covers 1000 patients, with 3 unique values for `data_partner_id`.


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

![](figure-png/marginals-patient-1.png)<!-- -->![](figure-png/marginals-patient-2.png)<!-- -->![](figure-png/marginals-patient-3.png)<!-- -->![](figure-png/marginals-patient-4.png)<!-- -->![](figure-png/marginals-patient-5.png)<!-- -->![](figure-png/marginals-patient-6.png)<!-- -->![](figure-png/marginals-patient-7.png)<!-- -->

`patient_latent` table
---------------------------------------------------------------------------

![](figure-png/marginals-patient_latent-1.png)<!-- -->![](figure-png/marginals-patient_latent-2.png)<!-- -->![](figure-png/marginals-patient_latent-3.png)<!-- -->![](figure-png/marginals-patient_latent-4.png)<!-- -->

`site_latent` table
---------------------------------------------------------------------------

![](figure-png/marginals-site_latent-1.png)<!-- -->![](figure-png/marginals-site_latent-2.png)<!-- -->![](figure-png/marginals-site_latent-3.png)<!-- -->


Multivariate
===========================================================================

latent risk 1
---------------------------------------------------------------------------

![](figure-png/latent-risk-1-1.png)<!-- -->![](figure-png/latent-risk-1-2.png)<!-- -->![](figure-png/latent-risk-1-3.png)<!-- -->![](figure-png/latent-risk-1-4.png)<!-- -->

COVID Severity
---------------------------------------------------------------------------

![](figure-png/covid-severity-1.png)<!-- -->![](figure-png/covid-severity-2.png)<!-- -->![](figure-png/covid-severity-3.png)<!-- -->![](figure-png/covid-severity-4.png)<!-- -->![](figure-png/covid-severity-5.png)<!-- -->

Correlation Matrixes
---------------------------------------------------------------------------

![](figure-png/correlation-matrixes-1.png)<!-- -->![](figure-png/correlation-matrixes-2.png)<!-- -->

|                                 | latent<br>risk<br>1| calc<br>age<br>covid| calc<br>outbreak<br>lag<br>years|
|:--------------------------------|-------------------:|--------------------:|--------------------------------:|
|latent<br>risk<br>1              |               1.000|                0.634|                           -0.143|
|calc<br>age<br>covid             |               0.634|                1.000|                            0.016|
|calc<br>outbreak<br>lag<br>years |              -0.143|                0.016|                            1.000|


Models
===========================================================================

latent risk 1
---------------------------------------------------------------------------

### latent risk 1 -exploration


```
============= Simple model that's just an intercept. =============
```

```

Call:
lm(formula = latent_risk_1 ~ 1, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-5.4952 -1.2404 -0.0032  1.2763  6.6968 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  1.10617    0.05447   20.31   <2e-16

Residual standard error: 1.722 on 999 degrees of freedom
```

```
============= Model includes one predictor: `outbreak_lag`. =============
```

```

Call:
lm(formula = latent_risk_1 ~ 1 + calc_outbreak_lag_years, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-5.7534 -1.2079  0.0111  1.2012  6.4568 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)
(Intercept)               1.6949     0.1400  12.107  < 2e-16
calc_outbreak_lag_years  -0.3632     0.0797  -4.557 5.83e-06

Residual standard error: 1.706 on 998 degrees of freedom
Multiple R-squared:  0.02039,	Adjusted R-squared:  0.0194 
F-statistic: 20.77 on 1 and 998 DF,  p-value: 5.826e-06
```

```
============= Model includes one predictor: `calc_age_covid`. =============
```

```

Call:
lm(formula = latent_risk_1 ~ 1 + calc_age_covid, data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-3.9340 -0.9132  0.0188  0.9309  4.2699 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)
(Intercept)    -0.643332   0.079675  -8.074 1.94e-15
calc_age_covid  0.039993   0.001546  25.876  < 2e-16

Residual standard error: 1.333 on 998 degrees of freedom
Multiple R-squared:  0.4015,	Adjusted R-squared:  0.4009 
F-statistic: 669.6 on 1 and 998 DF,  p-value: < 2.2e-16
```

```
============= Model includes two predictors. =============
```

```

Call:
lm(formula = latent_risk_1 ~ 1 + calc_outbreak_lag_years + calc_age_covid, 
    data = ds_patient)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.2044 -0.8783 -0.0038  0.9045  4.1004 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)
(Intercept)             -0.019859   0.125337  -0.158    0.874
calc_outbreak_lag_years -0.388767   0.061104  -6.362 3.02e-10
calc_age_covid           0.040145   0.001516  26.481  < 2e-16

Residual standard error: 1.307 on 997 degrees of freedom
Multiple R-squared:  0.4249,	Adjusted R-squared:  0.4237 
F-statistic: 368.3 on 2 and 997 DF,  p-value: < 2.2e-16
```

### latent risk 1 -final


|                        | Estimate| Std. Error| t value| Pr(>&#124;t&#124;)|
|:-----------------------|--------:|----------:|-------:|------------------:|
|(Intercept)             |    -0.02|       0.13|   -0.16|               0.87|
|calc_outbreak_lag_years |    -0.39|       0.06|   -6.36|               0.00|
|calc_age_covid          |     0.04|       0.00|   26.48|               0.00|



Session Information {#session-info}
===========================================================================

For the sake of documentation and reproducibility, the current report was rendered in the following environment.  Click the line below to expand.

  <details>
    <summary>Environment <span class="glyphicon glyphicon-plus-sign"></span></summary>
    
    ```
    ─ Session info ───────────────────────────────────────────────────────────────────────────────────
     setting  value
     version  R version 4.3.1 (2023-06-16)
     os       Ubuntu 23.10
     system   x86_64, linux-gnu
     ui       RStudio
     language (EN)
     collate  en_US.UTF-8
     ctype    en_US.UTF-8
     tz       America/Chicago
     date     2024-01-25
     rstudio  2023.12.0+369 Ocean Storm (desktop)
     pandoc   3.1.11 @ /usr/bin/ (via rmarkdown)
    
    ─ Packages ───────────────────────────────────────────────────────────────────────────────────────
     package         * version    date (UTC) lib source
     archive           1.1.7      2023-12-11 [1] CRAN (R 4.3.1)
     arrow             14.0.0.2   2023-12-02 [1] CRAN (R 4.3.1)
     assertthat        0.2.1      2019-03-21 [1] CRAN (R 4.3.1)
     backports         1.4.1      2021-12-13 [1] CRAN (R 4.3.1)
     base            * 4.3.1      2023-08-02 [4] local
     bit               4.0.5      2022-11-15 [1] CRAN (R 4.3.1)
     bit64             4.0.5      2020-08-30 [1] CRAN (R 4.3.1)
     blob              1.2.4      2023-03-17 [1] CRAN (R 4.3.1)
     bslib             0.6.1      2023-11-28 [1] CRAN (R 4.3.1)
     cachem            1.0.8      2023-05-01 [1] CRAN (R 4.3.1)
     checkmate         2.3.1      2023-12-04 [1] CRAN (R 4.3.1)
     chron             2.3-61     2023-05-02 [1] CRAN (R 4.3.1)
     cli               3.6.2      2023-12-11 [1] CRAN (R 4.3.1)
     colorspace        2.1-0      2023-01-23 [1] CRAN (R 4.3.1)
     compiler          4.3.1      2023-08-02 [4] local
     config            0.3.2      2023-08-30 [1] CRAN (R 4.3.1)
     corrplot          0.92       2021-11-18 [1] CRAN (R 4.3.1)
     crayon            1.5.2      2022-09-29 [1] CRAN (R 4.3.1)
     datasets        * 4.3.1      2023-08-02 [4] local
     DBI               1.2.1      2024-01-12 [1] CRAN (R 4.3.1)
     digest            0.6.34     2024-01-11 [1] CRAN (R 4.3.1)
     dplyr             1.1.4      2023-11-17 [1] CRAN (R 4.3.1)
     duckdb            0.9.2-1    2023-11-28 [1] CRAN (R 4.3.1)
     evaluate          0.23       2023-11-01 [1] CRAN (R 4.3.1)
     fansi             1.0.6      2023-12-08 [1] CRAN (R 4.3.1)
     farver            2.1.1      2022-07-06 [1] CRAN (R 4.3.1)
     fastmap           1.1.1      2023-02-24 [1] CRAN (R 4.3.1)
     forcats           1.0.0      2023-01-29 [1] CRAN (R 4.3.1)
     fs                1.6.3      2023-07-20 [1] CRAN (R 4.3.1)
     generics          0.1.3      2022-07-05 [1] CRAN (R 4.3.1)
     ggplot2         * 3.4.4      2023-10-12 [1] CRAN (R 4.3.1)
     glue              1.7.0      2024-01-09 [1] CRAN (R 4.3.1)
     graphics        * 4.3.1      2023-08-02 [4] local
     grDevices       * 4.3.1      2023-08-02 [4] local
     grid              4.3.1      2023-08-02 [4] local
     gsubfn            0.7        2018-03-16 [1] CRAN (R 4.3.1)
     gtable            0.3.4      2023-08-21 [1] CRAN (R 4.3.1)
     highr             0.10       2022-12-22 [1] CRAN (R 4.3.1)
     hms               1.1.3      2023-03-21 [1] CRAN (R 4.3.1)
     htmltools         0.5.7      2023-11-03 [1] CRAN (R 4.3.1)
     jquerylib         0.1.4      2021-04-26 [1] CRAN (R 4.3.1)
     jsonlite          1.8.8      2023-12-04 [1] CRAN (R 4.3.1)
     knitr           * 1.45       2023-10-30 [1] CRAN (R 4.3.1)
     labeling          0.4.3      2023-08-29 [1] CRAN (R 4.3.1)
     lattice           0.22-5     2023-10-24 [1] CRAN (R 4.3.1)
     lifecycle         1.0.4      2023-11-07 [1] CRAN (R 4.3.1)
     lubridate         1.9.3      2023-09-27 [1] CRAN (R 4.3.1)
     magrittr          2.0.3      2022-03-30 [1] CRAN (R 4.3.1)
     Matrix            1.6-5      2024-01-11 [1] CRAN (R 4.3.1)
     memoise           2.0.1      2021-11-26 [1] CRAN (R 4.3.1)
     methods         * 4.3.1      2023-08-02 [4] local
     mgcv              1.9-1      2023-12-21 [1] CRAN (R 4.3.1)
     munsell           0.5.0      2018-06-12 [1] CRAN (R 4.3.1)
     nlme              3.1-164    2023-11-27 [1] CRAN (R 4.3.1)
     OuhscMunge        0.2.0.9016 2024-01-14 [1] local
     pillar            1.9.0      2023-03-22 [1] CRAN (R 4.3.1)
     pkgconfig         2.0.3      2019-09-22 [1] CRAN (R 4.3.1)
     pkgload           1.3.4      2024-01-16 [1] CRAN (R 4.3.1)
     png               0.1-8      2022-11-29 [1] CRAN (R 4.3.1)
     proto             1.0.0      2016-10-29 [1] CRAN (R 4.3.1)
     purrr             1.0.2      2023-08-10 [1] CRAN (R 4.3.1)
     R6                2.5.1      2021-08-19 [1] CRAN (R 4.3.1)
     Rcpp              1.0.12     2024-01-09 [1] CRAN (R 4.3.1)
     readr             2.1.5      2024-01-10 [1] CRAN (R 4.3.1)
     reticulate        1.34.0     2023-10-12 [1] CRAN (R 4.3.1)
     rlang             1.1.3      2024-01-10 [1] CRAN (R 4.3.1)
     rmarkdown         2.25       2023-09-18 [1] CRAN (R 4.3.1)
     RSQLite         * 2.3.5      2024-01-21 [1] CRAN (R 4.3.1)
     rstudioapi        0.15.0     2023-07-07 [1] CRAN (R 4.3.1)
     sass              0.4.8      2023-12-06 [1] CRAN (R 4.3.1)
     scales            1.3.0      2023-11-28 [1] CRAN (R 4.3.1)
     sessioninfo       1.2.2      2021-12-06 [1] CRAN (R 4.3.1)
     splines           4.3.1      2023-08-02 [4] local
     sqldf             0.4-11     2017-06-28 [1] CRAN (R 4.3.1)
     stats           * 4.3.1      2023-08-02 [4] local
     TabularManifest   0.2.1      2023-11-15 [1] Github (Melinae/TabularManifest@bcb12f7)
     tcltk             4.3.1      2023-08-02 [4] local
     testit            0.13.1     2024-01-13 [1] Github (yihui/testit@698afd4)
     tibble            3.2.1      2023-03-20 [1] CRAN (R 4.3.1)
     tidyr             1.3.0      2023-01-24 [1] CRAN (R 4.3.1)
     tidyselect        1.2.0      2022-10-10 [1] CRAN (R 4.3.1)
     timechange        0.3.0      2024-01-18 [1] CRAN (R 4.3.1)
     tools             4.3.1      2023-08-02 [4] local
     tzdb              0.4.0      2023-05-12 [1] CRAN (R 4.3.1)
     utf8              1.2.4      2023-10-22 [1] CRAN (R 4.3.1)
     utils           * 4.3.1      2023-08-02 [4] local
     vctrs             0.6.5      2023-12-01 [1] CRAN (R 4.3.1)
     vroom             1.6.5      2023-12-05 [1] CRAN (R 4.3.1)
     withr             3.0.0      2024-01-16 [1] CRAN (R 4.3.1)
     xfun              0.41       2023-11-01 [1] CRAN (R 4.3.1)
     yaml              2.3.8      2023-12-11 [1] CRAN (R 4.3.1)
    
     [1] /home/wibeasley/R/x86_64-pc-linux-gnu-library/4.3
     [2] /usr/local/lib/R/site-library
     [3] /usr/lib/R/site-library
     [4] /usr/lib/R/library
    
    ──────────────────────────────────────────────────────────────────────────────────────────────────
    ```
  </details>



Report rendered by wibeasley at 2024-01-25, 09:42 -0600 in 13 seconds.
