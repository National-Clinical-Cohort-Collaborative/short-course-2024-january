# knitr::stitch_rmd(script="manipulation/simulation/simulate-mlm-1.R", output="stitched-output/manipulation/simulation/simulate-mlm-1.md") # dir.create("stitched-output/manipulation/simulation", recursive=T)
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------

# ---- load-packages -----------------------------------------------------------
requireNamespace("fs"        )

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()

# ---- load-data ---------------------------------------------------------------
files_to_delete <-
  "data-public/derived" |>
  fs::dir_ls(
    recurse = TRUE,
    type    = "file",
    regexp  = "(?:csv|duckdb|parquet|rds|sqlite)$"
  )

# ---- tweak-data --------------------------------------------------------------

# ---- delete-derived-data -----------------------------------------------------
message(
  "Preparing to delete the following derived files:\n- ",
  paste(files_to_delete, collapse = "\n- ")
)

files_to_delete |>
  fs::file_delete()

