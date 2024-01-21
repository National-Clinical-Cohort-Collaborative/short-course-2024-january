Data Visualization with Synthetic Data
==================

This is part of the [Analysis with Synthetic Data](../) session.


## Open the "graphs-1" Code Workbook in the Foundry Enclave

That you created already in the [assignments leading into Session 3](../homework#readme).

## Code

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
```
