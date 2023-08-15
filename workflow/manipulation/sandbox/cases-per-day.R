# Goal: Mimic national timeline
# https://coronavirus.jhu.edu/region/united-states
# https://www.npr.org/sections/health-shots/2020/09/01/816707182/map-tracking-the-spread-of-the-coronavirus-in-the-u-s
# Day    1: 2020-01-01
# Day  366: 2021-01-01
# Day  731: 2022-01-01
# Day 1096: 2023-01-01

base_size <- 1000

w2020_3 <- rnorm(n = base_size * 1, mean = 90, sd = 30)
w2020_6 <- rnorm(n = base_size * 1, mean = 150, sd = 30)


d <-
  c(
    w2020_3,
    w2020_6
  ) |>
  tibble::tibble(day = _)

f <- function(center , amplitude, sd) {
  # browser()
  # tibble::tibble(
  #
  # )
  # as.Date("2020-01-01") +
  rnorm(n = base_size * amplitude, mean = center, sd = sd) |>
    as.integer() #|>
    # lubridate::days()
}
d <-
  {
    tibble::tribble(
      ~center , ~amplitude, ~sd,
      94L ,         1L,   10L,
      186L ,        2L,   10L,
      315L ,        2L,   10L,
      330L ,        2L,   10L,
      345L ,        4L,   10L,
     ) |>
    purrr::pmap(f) |>
    unlist() +
    as.Date("2020-01-01")
  } |>
    tibble::tibble(day = _)


library(ggplot2)
ggplot(d, aes(x = day)) +
  geom_density(bw = 3)
