# knitr::stitch_rmd(script="manipulation/mlm-scribe.R", output="stitched-output/manipulation/mlm-scribe.md")
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
base::source("manipulation/common.R")
base::source("manipulation/scribe/global-code.R")

# ---- load-packages -----------------------------------------------------------
# import::from("magrittr", "%>%")
requireNamespace("tibble")
requireNamespace("readr"                      )  # remotes::install_github("tidyverse/readr")
requireNamespace("dplyr"                      )
requireNamespace("checkmate"                  )
requireNamespace("testit"                     )
requireNamespace("config"                     )
# requireNamespace("OuhscMunge"                 )   # remotes::install_github("OuhscBbmc/OuhscMunge")
# requireNamespace("RcppRoll")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config  <- config::get()
sql     <- readr::read_file("manipulation/scribe/pt-1.sql")

# ---- load-data ---------------------------------------------------------------
ds <- retrieve_duckdb(sql)
# ds <- retrieve_sqlite(sql)

checkmate::assert_data_frame(ds           , min.rows = 10)
rm(sql)

# ---- tweak-data --------------------------------------------------------------
dim(ds)
ds <-
  ds |>
  prepare_dataset()

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# ---- save-to-disk ------------------------------------------------------------
fs::dir_create(fs::path_dir(config$path_analysis_pt_1_csv     ))  # Ensure containing directory exists
fs::dir_create(fs::path_dir(config$path_analysis_pt_1_parquet ))  # Ensure containing directory exists

readr::write_csv(     ds  , config$path_analysis_pt_1_csv)
arrow::write_parquet( ds  , config$path_analysis_pt_1_parquet)
