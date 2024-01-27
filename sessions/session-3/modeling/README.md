Data Modeling with Synthetic Data
================

This is part of the [Analysis with Synthetic Data](../) session.

## Open the "modeling-1" Code Workbook in the Foundry

That you created already in the [assignments leading into Session 3](../homework#create-the-graphs-1-code-workbook).

## Select `pt_parquet` as Input Dataset

1.  Click the blue "Import dataset" button.
1.  Go to the directory for this class's L0 DUR: "All \> All projects \>
    N3C Training Area \> Group Exercises \> Introduction to Real World
    Data Analysis for COVID-19 Research, Spring 2024"
1.  Go to the "Users" directory.
1.  Go to your personal directory.
1.  Go to "workbook-output/manipulation-1/" directory.
1.  Select `pt_parquet`.


## Global Code

1.  See the Global Code explanation in the
    [data extraction](../extraction#readme) part of today's session.

1.  Paste following into the R tab of the Global Code panel.

    ``` r
    load_packages <- function () {
      # library(magrittr) # If R <4.1
      requireNamespace("arrow")
      requireNamespace("dplyr")
      requireNamespace("tidyr")
    }

    # ---- Asserts -----------
    assert_r_data_frame <- function(x) {
      if (!inherits(x, "data.frame")) {
        stop("The dataset is not an 'R data.frame`; convert it.")
      }
    }
    assert_spark_data_frame <- function(x) {
      if (!inherits(x, "SparkDataFrame")) {
        stop("The dataset is not a 'SparkDataFrame`; convert it.")
      }
    }
    assert_transform_object <- function(x) {
      if (!inherits(x, "FoundryTransformInput")) {
        stop("The dataset is not a 'FoundryTransformInput`; convert it.")
      }
    }

    # ---- IO --------------
    to_parquet <- function(d, assert_data_frame = TRUE) {
      if (assert_data_frame) assert_r_data_frame(d)
      output    <- new.output()
      output_fs <- output$fileSystem()
      arrow::write_parquet(
        x    = d,
        sink = output_fs$get_path("parquet", 'w')
      )

      stat <-
        sprintf(
          "%i_cols-by-%.1f_krows",
          ncol(d),
          nrow(d) / 1000
        )
      # Write a dummy dataset with a meaningful file name.
      write.csv(mtcars, output_fs$get_path(stat, 'w'))
    }
    from_parquet <- function(node) {
      fs   <- node$fileSystem()
      path <- fs$get_path("parquet", 'r')
      arrow::read_parquet(path)
    }
    ```

## Create R Transform: `m_covid_moderate_1`

1.  Click the `pt_parquet` transform, then click the blue plus button, then select "R code".
1.  Click the gray plus button (above the code), and click the observation transform.
1.  Change the new transform's name from "unnamed" to `m_covid_moderate_1`.
1.  Toggle the "Save as dataset" on.
1.  A 2nd name pops up for the transform.
    Keep the pair of names consistent (eg, `m_covid_moderate_1` also).
1.  Caution: keep the name *very* unique.
1.  Verify that you have one input: `pt_parquet`. The color is orange.
1.  Verify its type is "Transform input" in both places.
1.  Replace the code in the "<i class="fa-solid fa-code"></i> Logic" panel with

    ```r
    m_covid_moderate_1 <- function(pt_parquet) {
      load_packages()
      assert_transform_object(pt_parquet)

      eq <- "covid_moderate_plus ~ 1 + event_animal"

      ds <-
        pt_parquet |>
        from_parquet()

      m <-
        glm(
          eq,
          data   = ds,
          family = "binomial"
        )

      m |>
        summary() |>
        print()

      m |>
        broom::tidy()
    }
    ```


## Create R Transform: `m_covid_moderate_3`

1.  This transform uses the [emmeans](https://github.com/rvlenth/emmeans) package
    to produce the predicted values and errors, then graphs them.

1.  Create a new transform and follow the same steps as `m_covid_moderate_1`,
    but use the following code:

    ```r
    m_covid_moderate_3 <- function(pt_parquet) {
      load_packages()
      assert_transform_object(pt_parquet)

      outcome_label <- "COVID Moderate or Worse"
      outcome_name <- "covid_moderate_plus"
      eq_m  <- "covid_moderate_plus ~ 1 + event_animal + age_cut5" # + period_first_covid_dx"
      eq_em <- "~ event_animal | age_cut5"

      glm_link      <- "quasibinomial"
      hat_name      <- "prob" # Logistic regression produces "prob" by emmeans

      ds <-
        pt_parquet |>
        from_parquet()

      m <-
        glm(
          eq_m,
          data   = ds,
          family = glm_link
        )

      m |>
        summary() |>
        print()

      m |>
        broom::tidy() |>
        print()

      e <-
        emmeans::emmeans(
          m,
          as.formula(eq_em),
          data = ds,
          type = "response"
        )

      d_predict <-
        seq_len(nrow(e@linfct)) |>
        purrr::map_dfr(function(i) as.data.frame(e[i])) |>
        dplyr::mutate(
          outcome = outcome_name,
        ) |>
        dplyr::select(
          outcome,
          event_animal,
          age_cut5,
          y_hat       = !!rlang::ensym(hat_name),
          se          = SE,
          ci_lower    = asymp.LCL,
          ci_upper    = asymp.UCL
        )
      print(d_predict)

      glyph <- "label"
      g <-
        d_predict |>
        ggplot(
          aes(x = age_cut5, y = y_hat, group = event_animal, color = event_animal, fill = event_animal)
        ) +
        geom_line(size = 1, key_glyph = glyph) +
        geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), color = NA, key_glyph = glyph, alpha = .15) +
        geom_point(size = 3, shape = 21, key_glyph = glyph) +
        # guides(color = guide_legend(nrow = 1, override.aes = list(size = 6))) +
        # guides(fill  = guide_legend(nrow = 1, override.aes = list(alpha = 1))) +
        theme_minimal(base_size = 20) +
        # theme(legend.position = "none") +
        theme(legend.position = c(0, 1), legend.justification = c(0, 1)) +
        # theme(legend.title     = element_text(color = palette_asthma_dark[["title"]])) +
        # theme(strip.background = element_rect(fill  = palette_asthma_dark[["title"]], color = NA)) +
        # theme(strip.text       = element_text(color = "gray97"                  , face = "bold")) +
        # theme(axis.title       = element_text(color = palette_asthma_dark[["title"]], face = "bold")) +
        # theme(plot.title = element_text(color = palette_asthma_dark[["title"]], face = "bold")) +
        theme(panel.grid.major.x = element_blank()) +
        theme(panel.grid.major.y = element_line(color = "gray97")) +
        theme(panel.grid.minor.y = element_blank()) +
        labs(
          x     = NULL, #"Tx Category",
          y     = NULL, #outcome_label,
          color = "Asthma Category",
          fill  = "Asthma Category",
          title = outcome_label #main_title
        )

      print(g)

      d_predict
    }


    ```