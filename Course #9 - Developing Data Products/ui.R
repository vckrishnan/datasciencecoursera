library(shiny)            ##Library for building Shiny Web App
library(DT)               ##Library for generating the datatable
library(ggplot2movies)    ##Library for loading Movies Dataset
library(plotly)           ##Library for generating Histogram with Plotly

## Loading the Movies Dataset
data(movies)

##Extract the Years from the Movies dataset for populating the From Year and To Year drop downs
mYears <- as.character(sort(movies$year))


#Shiny UI FluidPage function
shinyUI(fluidPage(
  
 
  #Creating Sibebay Layout
  sidebarLayout(
    sidebarPanel(
      
     #From Year Drop Down List 
      selectInput(inputId = "fromYear",
                  label="From Year",
                  choices= mYears,
                  selected = min(mYears),
                  multiple = FALSE
                  ),
      #To Year Drop down List    
      selectInput(inputId = "toYear",
                  label="To Year",
                  choices= mYears,
                  selected = max(mYears),
                  multiple = FALSE
      ),
      
      #Datatable Tilte Checkbox Group
      checkboxGroupInput(inputId="mtColName",
                           label = "Movie Genre",
                           choices= c("TITLE","YEAR","LENGTH","RATING","GENRE"),
                           selected = c("TITLE","YEAR","LENGTH","RATING","GENRE")),
      
      #Action Button
      actionButton(inputId="search", label="Search Movies")
      ),
    

    # Show a plot of the generated distribution
    mainPanel(
      #Defining Tabset Panel
      tabsetPanel(type="tabs",
                  tabPanel(title="Data Table",   #Tab for displaying Datatable
                           dataTableOutput(outputId="movies_table")
                           ),
                  tabPanel(title="Plot",  #Tabl for display histogram
                           plotlyOutput(outputId="hist")
                           )
      )
    )
  )
))
