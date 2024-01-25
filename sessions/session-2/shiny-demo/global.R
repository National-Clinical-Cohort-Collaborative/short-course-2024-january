library(shiny)
library(DBI)
library(RSQLite)
library(visNetwork)
library(dplyr)

# Load the OMOP data
omop_data <- read.csv("omop_cdm_v531.csv")

# Load slim concept data from concept, concept_ancestor, and concept_relationship, etc.
concept <- read.csv("concept_sample.csv")
concept_ancestor <- read.csv("concept_ancestor_sample.csv")
concept_relationship <- read.csv("concept_relationship_sample.csv")
concept_class <- read.csv("concept_class_sample.csv")
concept_synonym <- read.csv("concept_synonym_sample.csv")
domain <- read.csv("domain_sample.csv")
relationship <- read.csv("relationship_sample.csv")
vocabulary <- read.csv("vocabulary_sample.csv")

# Connect to SQLite database to store data used in this app
con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "concept", concept) 
dbWriteTable(con, "concept_ancestor", concept_ancestor) 
dbWriteTable(con, "concept_relationship", concept_relationship) 
dbWriteTable(con, "concept_class", concept_class) 
dbWriteTable(con, "concept_synonym", concept_synonym) 
dbWriteTable(con, "domain", domain) 
dbWriteTable(con, "relationship", relationship) 
dbWriteTable(con, "vocabulary", vocabulary) 
