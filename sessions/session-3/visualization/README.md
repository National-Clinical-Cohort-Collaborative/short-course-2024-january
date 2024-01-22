Data Visualization with Synthetic Data
==================

This is part of the [Analysis with Synthetic Data](../) session.


## Open the "graphs-1" Code Workbook in the Found

That you created already in the [assignments leading into
Session 3](../homework#create-the-graphs-1-code-workbook).

## Select `pt_rds` as Input Dataset

1.  Click the blue "Import dataset" button.
1.  Go to the directory for this class's L0 DUR: "All \> All projects \>
    N3C Training Area \> Group Exercises \> Introduction to Real World
    Data Analysis for COVID-19 Research, Spring 2024"
1.  Go to the "Users" directory.
1.  Go to your personal directory.
1.  Go to "workbook-output/manipulation-1/" directory.
1.  Select `pt_rds`.

## Create R Transform: `g_calc_age_covid`

1.  Click the `pt_rds` transform, then click the blue plus button, then select "R code".
1.  Click the gray plus button (above the code), and click the observation transform.
1.  Change the new transform's name from "unnamed" to `g_calc_age_covid`.
1.  Toggle the "Save as dataset" on.
1.  A 2nd name pops up for the transform.
    Keep the pair of names consistent (eg, `g_calc_age_covid` also).
1.  Caution: keep the name *very* unique.
    If it's the same name as a dataset or even a variable,
    you'll get frustratingly unhelpful or non-existent error messages.
    (For example, "Input or upstream dataset must be built before being used in the console: {tableName=calc_age_covid}").
1.  Verify that you have one input: `pt_rds`. The color is orange.
1.  Verify its type is "Transform input" in both places.
1.  Replace the code with

    ```r
    g_calc_age_covid <- function(pt_rds) {
      load_packages()
      assert_transform_object(pt_rds)

      ds <-
        pt_rds |>
        from_rds()

      g1 <-
        ds |>
        ggplot(aes(x = calc_age_covid, y = covid_moderate_plus)) +
        geom_point()

      print(g1)
      return(NULL) # The transform needs to return a dataset (even if it's a null dataset)
    }
    ```


## Improve `g_calc_age_covid`

1. Replace the

    ```r
    g1 <-
      ds |>
      ggplot(aes(
        x = calc_age_covid,
        y = covid_moderate_plus,
        group = data_partner_id,
        color = data_partner_id
        # fill = data_partner_id
      )) +
      geom_smooth(
        mapping = aes(group = NA, color = NULL, fill = NULL),
        method = "loess",
        span = 2,
        color = "gray40",
        linetype = "88",
        na.rm    = TRUE
      ) +
      geom_smooth(
        method = "loess",
        span = 2,
        se = FALSE,
        na.rm    = TRUE
      ) +
      geom_point(
        shape     = 1,
        position  = position_jitter(height = .08),
        na.rm     = TRUE
      ) +
      scale_y_continuous(labels = scales::label_percent()) +
      # scale_y_continuous(labels = scales::percent_format()) +
      coord_cartesian(ylim = c(-.1, 1.1), expand = F) +
      theme_light() +
      theme(axis.ticks = element_blank()) +
      labs(
        y = "Probability of Developing\nModerate COVID or Worse"
      )

      print(g1)
      return(NULL) # The transform needs to return a dataset (even if it's a null dataset)
    ```
