# knitr::stitch_rmd(script="manipulation/simulation/simulate-mlm-1.R", output="stitched-output/manipulation/simulation/simulate-mlm-1.md") # dir.create("stitched-output/manipulation/simulation", recursive=T)
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# library("ggplot2")

# Import only certain functions of a package into the search path.
# import::from("magrittr", "%>%")

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("readr"        )
# requireNamespace("tidyr"        )
# requireNamespace("dplyr"        ) # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
# requireNamespace("rlang"        ) # Language constructs, like quosures
# requireNamespace("testit"       ) # For asserting conditions meet expected patterns/conditions.
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns/conditions. # remotes::install_github("mllg/checkmate")
# requireNamespace("DBI"          ) # Database-agnostic interface
requireNamespace("duckdb"      ) # Lightweight database for non-PHI data.
# requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
config                         <- config::get()

path_ddl <-
  c(
    "manipulation/db-create-duckdb/create.sql",
    # "manipulation/db-create-sqlite/concept-create.sql",
    "manipulation/db-create-duckdb/latent-nation-count.sql"
    # "manipulation/db-create-sqlite/person-drop.sql",
    # "manipulation/db-create-sqlite/person-create.sql",
    # "manipulation/db-create-sqlite/patient-drop.sql",
    # "manipulation/db-create-sqlite/patient-create.sql",
    # "manipulation/db-create-sqlite/patient-hidden-drop.sql",
    # "manipulation/db-create-sqlite/patient-hidden-create.sql"
  )

execute_sql <- function(path_sql) {
  message("Executing ", path_sql)
  checkmate::assert_file_exists(path_sql)

  path_sql |>
    readr::read_file() |>
    DBI::dbExecute(
      conn        = cnn,
      statement   = _
    )
}

# ---- load-data ---------------------------------------------------------------

# ---- tweak-data --------------------------------------------------------------
# Remove old DB
if( file.exists(config$path_database_duckdb) ) file.remove(config$path_database_duckdb)

cnn <- DBI::dbConnect(duckdb::duckdb(), dbdir = config$path_database_duckdb)
# result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
# DBI::dbClearResult(result)
DBI::dbListTables(cnn)

path_ddl |>
  purrr::walk(~execute_sql(.))

# Allow database to optimize its internal arrangement
DBI::dbExecute(cnn, "VACUUM ANALYZE;")

# Close connection
DBI::dbDisconnect(cnn, shutdown = TRUE)
