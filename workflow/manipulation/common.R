# ---- duckdb ------------------------------------------------------------------
truncate_and_load_table_duckdb <- function(d, table_name) {
  checkmate::assert_data_frame(d)
  checkmate::assert_character( table_name, min.chars = 2, any.missing = FALSE)

  # cnn <- DBI::dbConnect(duckdb::duckdb(), dbname = config$path_database_duckdb)
  drv <-
    duckdb::duckdb(
      dbdir     = config$path_database_duckdb,
      read_only = FALSE,
      bigint    = "integer64"
    )

  sql_delete <- sprintf("TRUNCATE TABLE %s;", table_name)

  tryCatch({
    cnn <- DBI::dbConnect(drv)
    # DBI::dbListTables(cnn)
    DBI::dbExecute(cnn, sql_delete) # This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
    d |>
      DBI::dbWriteTable(
        conn      = cnn,
        name      = table_name,
        append    = TRUE,
        row.names = FALSE
      )

  # Allow database to optimize its internal arrangement
  r <- DBI::dbExecute(cnn, "VACUUM ANALYZE;")
  },
  finally = {
    DBI::dbDisconnect(cnn, shutdown = TRUE)
    rm(cnn)
  })
  # base::on.exit(DBI::dbDisconnect(cnn, shutdown = TRUE))

  invisible(r)
}

retrieve_duckdb <- function(sql) {
  checkmate::assert_character(sql, min.chars = 10, any.missing = FALSE)

  drv <-
    duckdb::duckdb(
      dbdir     = config$path_database_duckdb,
      read_only = TRUE,
      bigint    = "integer64"
    )
  # tryCatch({
    cnn <- DBI::dbConnect(drv)
    # DBI::dbListTables(cnn)
    ds <- DBI::dbGetQuery(cnn, sql) # This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
    base::on.exit(DBI::dbDisconnect(cnn, shutdown = TRUE))
  # },
  # finally = {
  #   DBI::dbDisconnect(cnn, shutdown = TRUE)
  #   rm(cnn, sql)
  # })

  ds |>
    tibble::as_tibble()
}



# ---- sqlite ------------------------------------------------------------------
truncate_and_load_table_sqlite <- function(d, table_name) {
  checkmate::assert_data_frame(d)
  checkmate::assert_character( table_name, min.chars = 2, any.missing = FALSE)

  # If there's *NO* PHI, a local database like SQLite fits a nice niche if
  #   * the data is relational and
  #   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
  # SQLite data types work differently than most databases: https://www.sqlite.org/datatype3.html#type_affinity

  cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database_sqlite)
  sql_delete <- sprintf("DELETE FROM %s;", table_name)
  DBI::dbExecute(cnn, sql_delete)

  d |>
    dplyr::mutate_if(lubridate::is.Date, as.character) |>     # SQLite doesn't support dates natively
    DBI::dbWriteTable(
      conn      = cnn,
      name      = table_name,
      append    = TRUE,
      row.names = FALSE
    )

  # Allow database to optimize its internal arrangement
  DBI::dbExecute(cnn, "VACUUM;")

  # Close connection
  DBI::dbDisconnect(cnn)
}

retrieve_sqlite <- function(sql) {
  checkmate::assert_character(sql, min.chars = 10, any.missing = FALSE)

  cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database_sqlite)
  # DBI::dbListTables(cnn)
  ds <- DBI::dbGetQuery(cnn, sql) # This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
  DBI::dbDisconnect(cnn)
  rm(cnn, sql)

  ds |>
    tibble::as_tibble()
}
