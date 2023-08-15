truncate_and_load_table <- function(d, table_name) {
  # If there's *NO* PHI, a local database like SQLite fits a nice niche if
  #   * the data is relational and
  #   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
  # SQLite data types work differently than most databases: https://www.sqlite.org/datatype3.html#type_affinity

  cnn <- DBI::dbConnect(RSQLite::SQLite(), dbname = config$path_database)
  sql_delete <- sprintf("DELETE FROM %s;", table_name)
  DBI::dbExecute(cnn, sql_delete)

  d |>
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
