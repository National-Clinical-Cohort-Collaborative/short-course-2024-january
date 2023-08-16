# Goal: Mimic national timeline
# https://coronavirus.jhu.edu/region/united-states
# https://www.npr.org/sections/health-shots/2020/09/01/816707182/map-tracking-the-spread-of-the-coronavirus-in-the-u-s
# Day    1: 2020-01-01
# Day  366: 2021-01-01
# Day  731: 2022-01-01
# Day 1096: 2023-01-01

base_size <- 1000

f <- function(center , amplitude, sd) {
  m <- as.integer(difftime(center, as.Date("2020-01-01"), units = "day"))
  rnorm(n = base_size * amplitude, mean = m, sd = sd) |>
    as.integer()
}

d <-
  {
    tibble::tribble(
      ~center     , ~amplitude,   ~sd,
      "2020-04-04",         1L,   20L,
      "2020-07-05",         2L,   20L,
      "2020-09-18",         1L,   40L,
      "2020-11-11",         2L,   10L,
      "2020-11-26",         2L,   10L,
      "2020-12-11",         4L,   10L,
      "2021-02-24",         1L,   30L,
      "2021-04-11",         1L,   30L,
      "2021-08-25",         2L,   15L,
      "2021-09-04",         2L,   25L,
      "2021-11-15",         1L,   25L,
      "2021-11-28",         1L,   25L,
      "2021-12-01",         1L,   15L,
      "2022-01-01",         7L,   10L,
      "2022-01-07",         5L,   10L,
      "2022-03-18",         1L,   40L,
      "2022-05-20",         1L,   20L,
      "2022-06-20",         1L,   20L,
      "2022-07-22",         1L,   20L,
      "2022-12-05",         2L,   40L,
    ) |>
    purrr::pmap(f) |>
    unlist() +
    as.Date("2020-01-01")
  } |>
    tibble::tibble(day = _)


library(ggplot2)
ggplot(d, aes(x = day)) +
  geom_density(bw = 3)
