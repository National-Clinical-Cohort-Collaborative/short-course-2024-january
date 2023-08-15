truncate_and_load_table_sqlite <- function(d, table_name) {
  # If there's *NO* PHI, a local database like SQLite fits a nice niche if
  #   * the data is relational and
  #   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
  # SQLite data types work differently than most databases: https://www.sqlite.org/datatype3.html#type_affinity

  cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database)
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
  cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database)
  # DBI::dbListTables(cnn)
  ds <- DBI::dbGetQuery(cnn, sql) # This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
  DBI::dbDisconnect(cnn); rm(cnn, sql)

  ds |>
    tibble::as_tibble()
}
