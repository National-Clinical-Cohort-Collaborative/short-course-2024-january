# knitr::stitch_rmd(script="manipulation/car-ellis.R", output="stitched-output/manipulation/car-ellis.md")
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# library("ggplot2")

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("readr"        )
requireNamespace("tidyr"        )
requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("rlang"        ) # Language constructs, like quosures
requireNamespace("testit"       ) # For asserting conditions meet expected patterns/conditions.
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
requireNamespace("DBI"          ) # Database-agnostic interface
requireNamespace("RSQLite"      ) # Lightweight database for non-PHI data.
# requireNamespace("odbc"         ) # For communicating with SQL Server over a locally-configured DSN.  Uncomment if you use 'upload-to-db' chunk.
requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                  <- config::get()

# OuhscMunge::readr_spec_aligned(config$path_metadata_concept)
col_types <- readr::cols_only(
  `concept_id`          = readr::col_integer(),
  `concept_name`        = readr::col_character(),
  `domain_id`           = readr::col_character(),
  `vocabulary_id`       = readr::col_character(),
  `concept_class_id`    = readr::col_character(),
  `standard_concept`    = readr::col_character(),
  `concept_code`        = readr::col_character(),
  `valid_start_date`    = readr::col_date(format = ""),
  `valid_end_date`      = readr::col_date(format = ""),
  `invalid_reason`      = readr::col_character()
)

# ---- load-data ---------------------------------------------------------------
ds <- readr::read_csv(config$path_metadata_concept, col_types = col_types)

rm(col_types)

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.

# Dataset description can be found at: http://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html
# Populate the rename entries with OuhscMunge::column_rename_headstart(ds_county) # remotes::install_github("OuhscBbmc/OuhscMunge")
ds <-
  ds |>
  dplyr::select(    # `dplyr::select()` drops columns not included.
    concept_id,
    concept_name,
    domain_id,
    vocabulary_id,
    concept_class_id,
    standard_concept,
    concept_code,
    valid_start_date,
    valid_end_date,
    invalid_reason,
  ) |>
  dplyr::mutate(
    standard_concept  = dplyr::na_if(standard_concept, "NULL"),
    invalid_reason    = dplyr::na_if(invalid_reason  , "NULL"),
  )

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds) # Run this to line to start the checkmate asserts.
checkmate::assert_integer(  ds$concept_id       , any.missing=F , lower=1, upper=2^31                               , unique=T)
checkmate::assert_character(ds$concept_name     , any.missing=F , pattern="^.{2,255}$"                                      , unique=T)
checkmate::assert_character(ds$domain_id        , any.missing=F , pattern="^.{2,20}$"                                      )
checkmate::assert_character(ds$vocabulary_id    , any.missing=F , pattern="^.{2,20}$"                                       )
checkmate::assert_character(ds$concept_class_id , any.missing=F , pattern="^.{2,20}$"                                      )
checkmate::assert_character(ds$standard_concept , any.missing=T , pattern="^.{1}$"                                       )
checkmate::assert_character(ds$concept_code     , any.missing=F , pattern="^.{1,50}$"                                       , unique=T)
checkmate::assert_date(     ds$valid_start_date , any.missing=F , lower=as.Date("1970-01-01"), upper=as.Date("2099-12-31") )
checkmate::assert_date(     ds$valid_end_date   , any.missing=F , lower=as.Date("1970-01-01"), upper=as.Date("2099-12-31") )
checkmate::assert_character(ds$invalid_reason   , any.missing=T , pattern="^.{1}$"                                       )

# ---- specify-columns-to-write ------------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

ds_slim <-
  ds |>
  # dplyr::slice(1:100) |>
  dplyr::select(
    concept_id,
    concept_name,
    domain_id,
    vocabulary_id,
    concept_class_id,
    standard_concept,
    concept_code,
    valid_start_date,
    valid_end_date,
    invalid_reason,
  ) |>
  dplyr::mutate_if(lubridate::is.Date, as.character)       # Some databases & drivers need 0/1 instead of FALSE/TRUE.
ds_slim

# ---- save-to-disk ------------------------------------------------------------
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
# readr::write_rds(ds_slim, path_output, compress="gz")

# ---- save-to-db --------------------------------------------------------------
# If there's *NO* PHI, a local database like SQLite fits a nice niche if
#   * the data is relational and
#   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
# SQLite data types work differently than most databases: https://www.sqlite.org/datatype3.html#type_affinity

cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database)
ds_slim |>
  DBI::dbWriteTable(
    conn      = cnn,
    name      = "concept",
    append    = TRUE,
    row.names = FALSE
  )

# Allow database to optimize its internal arrangement
DBI::dbExecute(cnn, "VACUUM;")

# Close connection
DBI::dbDisconnect(cnn)
