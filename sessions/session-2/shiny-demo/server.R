server <- function(input, output) {
  
  # Reactive expression to filter data based on user input
  filteredData <- reactive({
    if(is.null(input$tableType) || input$tableType == "All") {
      return(omop_data)
    }
    
    # Filter the data based on the selected table type by the user
    omop_data %>%
      filter(`Table.Type` == input$tableType, Exclude != "Y")
  })
  
  
  # ER Diagram Code
  output$networkPlot <- renderVisNetwork({
    # Use filtered data
    data <- filteredData()
    
    # Group data by table and concatenate fields into a single string
    table_info <- data %>%
      group_by(Table) %>%
      summarise(Fields = paste(Field, collapse = "\n"), .groups = 'drop')
    
    nodes <- data.frame(
        id = 1:nrow(table_info),
        label = paste(table_info$Table, "\n", table_info$Fields),
        group = data$`Table.Type`[match(table_info$Table, data$Table)],
        borderWidth = 2,  # Set border width
        shape = "box",    # Set shape of nodes
        font = list(bold = TRUE)  # Make the font bold
    )
    
    # Create a list of edges based on foreign key relationships
    edges <- data %>%
      filter(`Foreign.Key` == "Yes") %>%
      select(Table, `FK.Table`) %>%
      mutate(from = match(Table, table_info$Table),
             to = match(`FK.Table`, table_info$Table)) %>%
      select(from, to) %>%
      unique()
    
    # Convert edges to a data frame
    edges <- data.frame(edges)
    
    # Determine unique table types for grouping
    unique_table_types <- unique(data$`Table.Type`)
    colors <- c("lightblue", "lightgreen", "lightcoral")  # Define a color for each group
    
    # Create the visNetwork diagram 
    network <- visNetwork(nodes, edges, width = "100%", height = "100vh") %>%
      visEdges(arrows = 'to') %>%
      visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) %>%
      visPhysics(solver = "forceAtlas2Based")  # Physics-based layout
    
    # Apply visGroups for each type with different colors
    for(i in seq_along(unique_table_types)) {
      network <- network %>% visGroups(groupname = unique_table_types[i], color = colors[i])
    }
    
    # Add a legend to the network
    network <- network %>%
      visLegend(width = 0.1, position = "right") 
    
    network
  })
  
  # SQL Testing Code
  output$queryResult <- renderTable({
    input$runQuery
    isolate({
      query <- input$sqlInput
      tryCatch({
        dbGetQuery(con, query)
      }, error = function(e) {
        data.frame(Error = e$message)
      })
    })
  }, rownames = TRUE)
}