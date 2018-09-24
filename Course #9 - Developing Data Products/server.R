library(shiny)          ## Library for using Shiny functions
library(dplyr)          ## Library for manupulating the Data
library(plotly)         ## Library for generating the graphs
library(ggplot2movies)  ## Library for loading Movies Dataset
library(DT)             ## Library for generating Datatable

data(movies)            ##Loading Movies Dataset

#Changing the Column names to upper case
names(movies) <- toupper(names(movies))
movies$YEAR <- as.character(movies$YEAR)

##Creating new column named "Genre", and combine the movie genre into one column
movies$GENRE <- NA
movies <- movies %>%
  mutate(GENRE = ifelse (ACTION == 1, ifelse(is.na(GENRE), "Action", paste(GENRE, "Action", sep=",")),GENRE)) %>%
  mutate(GENRE = ifelse (ANIMATION == 1, ifelse(is.na(GENRE), "Animation", paste(GENRE, "Animation", sep=",")),GENRE)) %>%
  mutate(GENRE = ifelse (COMEDY == 1, ifelse(is.na(GENRE), "Comedy", paste(GENRE, "Comedy", sep=",")),GENRE)) %>%
  mutate(GENRE = ifelse (DRAMA == 1, ifelse(is.na(GENRE), "Drama", paste(GENRE, "Drama", sep=",")),GENRE)) %>% 
  mutate(GENRE = ifelse (DOCUMENTARY == 1, ifelse(is.na(GENRE), "Documentary", paste(GENRE, "Documentary", sep=",")),GENRE)) %>%
  mutate(GENRE = ifelse (ROMANCE == 1, ifelse(is.na(GENRE), "Romance", paste(GENRE, "Romance", sep=",")),GENRE)) %>%
  mutate(GENRE = ifelse (SHORT == 1, ifelse(is.na(GENRE), "Short", paste(GENRE, "Short", sep=",")),GENRE))


# Server Function to genrate the datatable and the Histogram
shinyServer(function(input, output) {
  
  ## Reactive function to handle the Click of the sumbit button
  movies_output <- eventReactive(
    eventExpr = input$search,
    valueExpr = movies %>% filter(YEAR >= isolate({input$fromYear}) & YEAR <= isolate({input$toYear}))%>% select(isolate({input$mtColName})),
    ignoreNULL = TRUE
  )
  
  ##Genrating Datatable
  output$movies_table <- renderDataTable({
    req(input$fromYear,input$toYear,input$mtColName)
    datatable(data=movies_output(),options= list(pageLength=10))
  })
  
  ##Generating the Histogram on Movie ratings
  output$hist <- renderPlotly({
    
    den <- density(movies_output()$RATING)
    plot_ly(x= movies_output()$RATING,type="histogram", name="Histogram") %>%
      add_trace(y=den$y, x=den$x, type="scatter", mode="lines", fill="tozeroy", name="Density" , yaxis = "y2")%>%
      layout(title=paste("Distribution Movie Ratings for the movies released", input$fromYear, " - ", input$toYear),
             xaxis = list(title="Ratings"),
             yaxis=list(title="Count of Movies"),
             yaxis2= list(overlaying="y", side = "right")
             )
    
  })
})
