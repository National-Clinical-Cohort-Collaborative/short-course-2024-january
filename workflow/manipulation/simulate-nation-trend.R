# knitr::stitch_rmd(script="manipulation/car-ellis.R", output="stitched-output/manipulation/car-ellis.md")
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("manipulation/common.R")

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# library("ggplot2")

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("readr"        )
# requireNamespace("tidyr"        )
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
# requireNamespace("rlang"        ) # Language constructs, like quosures
# requireNamespace("lubridate"    ) # Easier manipulation of dates
# requireNamespace("testit"       ) # For asserting conditions meet expected patterns/conditions.
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
# requireNamespace("DBI"          ) # Database-agnostic interface
# requireNamespace("RSQLite"      ) # Lightweight database for non-PHI data.
# requireNamespace("odbc"         ) # For communicating with SQL Server over a locally-configured DSN.  Uncomment if you use 'upload-to-db' chunk.
# requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                  <- config::get()
set.seed(453)

base_size <- 1000

f <- function(center , amplitude, sd) {
  m <- as.integer(difftime(center, config$covid_start_nation, units = "day"))
  rnorm(n = base_size * amplitude, mean = m, sd = sd) |>
    as.integer()
}

# ---- load-data ---------------------------------------------------------------

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.

# Goal: Mimic national timeline
# https://coronavirus.jhu.edu/region/united-states
# https://www.npr.org/sections/health-shots/2020/09/01/816707182/map-tracking-the-spread-of-the-coronavirus-in-the-u-s
# Day    1: 2020-01-01
# Day  366: 2021-01-01
# Day  731: 2022-01-01
# Day 1096: 2023-01-01


ds <-
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
  tibble::tibble(date = _) |>
  dplyr::count(date, name = "pt_count")

# library(ggplot2)
# ds |>
#   ggplot(aes(x = date, weight = pt_count)) +
#   geom_density(bw = 3)

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds) # Run this to line to start the checkmate asserts.
checkmate::assert_date(    ds$date     , any.missing=F , lower=config$covid_start_nation, upper=as.Date("2023-04-28") , unique=T)
checkmate::assert_integer( ds$pt_count , any.missing=F , lower=1, upper=1000                                       )

# ---- specify-columns-to-write ------------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))
ds_slim <-
  ds |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    date,
    pt_count,
  )

# ---- save-to-db --------------------------------------------------------------
truncate_and_load_table_duckdb(ds_slim, "latent_nation_count")
truncate_and_load_table_sqlite(ds_slim, "latent_nation_count")
