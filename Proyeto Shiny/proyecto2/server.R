library(shiny)
library(DT)
library(readr)
library(dplyr)
library(ggplot2)


#Dataset
dataset <- readRDS("data.rds")

shinyServer(function(input, output, session) {
  
  output$tabla <- DT::renderDataTable({
    tabla <- data_pro 
    if(input$inStyle != ""){
      if(input$inStyle == "All"){
        tabla <- tabla 
      }
      else{
        tabla <- tabla %>% filter(Technique %in% input$inStyle) 
      }
    }
    if(input$inCountry != ""){
      if(input$inCountry == "All"){
        tabla <- tabla 
      }
      else{
        tabla <- tabla %>% filter(Country %in% input$inCountry) 
      }
    }
    if(input$Seasons != 0){
      tabla <- tabla %>% filter(Seasons %in% input$Seasons) 
    }
    
    if(input$Episodes != 0){
      tabla <- tabla %>% filter(Episodes %in% input$Episodes) 
    }
    
    ifelse(input$inYearS != 0,tabla <- tabla %>% filter(between(`Premiere Year`,input$inYearS[1],input$inYearS[2])),tabla)
    ifelse(input$inYearE != 0,tabla <- tabla %>% filter(between(`Final Year`,input$inYearE[1],input$inYearE[2])),tabla)
    
    tabla <- tabla %>% select(Title, Seasons, Episodes, Country, `Premiere Year`,`Final Year`,`Original Channel`, Technique) %>%
      DT::datatable(options = list(searching=FALSE,bLengthChange =FALSE))
    
    tabla
  })
  
  
  output$tabla1 <- renderTable({mtcars})

})
