ui <- fluidPage(
  titlePanel("OMOP CDM v5.3.1 Ineractive E-R Diagram and Terminology Demo"),
  
  tabsetPanel(
    tabPanel("ER Diagram", 
             fluidRow(
               column(width = 3, 
                      selectInput("tableType", "Table Type:",
                                  choices = c("All", unique(omop_data$`Table.Type`)),
                                  selected = "All")
               ),
               column(width = 9,
                      visNetworkOutput("networkPlot", height = "800px")
               )
             )
    ),
    tabPanel("SQL Testing",
             sidebarLayout(
               sidebarPanel(
                 textAreaInput("sqlInput", "Enter SQL query:", 
                               "-- Put your code here
SELECT name, type, sql
FROM sqlite_master
WHERE type IN ('table', 'index')
ORDER BY name;", rows = 5),
                 actionButton("runQuery", "Run Query")
               ),
               mainPanel(
                 tableOutput("queryResult")
               )
             )
    )
  )
)
