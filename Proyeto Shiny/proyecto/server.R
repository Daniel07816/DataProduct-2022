library(shiny)
library(dplyr)
# library(ggplot2)
library(plotly)


data <- readRDS("data.rds")


shinyServer(function(input, output, session) {
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    inCountry <- query[["inCountry"]]
    inStyle <- query[["inStyle"]]
    Seasons  <- query[["Seasons"]]
    Episodes  <- query[["Episodes"]]
    
    if(!is.null(inCountry)){
      updateSelectInput(session, "inCountry", selected = inCountry)
    }
    if(!is.null(inStyle)){
      updateSelectInput(session, "inStyle", selected = inStyle)
    }
    if(!is.null(Seasons)){
      updateNumericInput(session, "Seasons", value=as.numeric(Seasons))
    }
    if(!is.null(Episodes)){
      updateNumericInput(session, "Episodes", value=as.numeric(Episodes))
    }
  })
  
  
  observe({
    inCountry <- input$inCountry
    inStyle <- input$inStyle
    Seasons  <- input$Seasons
    Episodes  <- input$Episodes
    
    if(session$clientData$url_port==''){
      x <- NULL
    } else {
      x <- paste0(":",
                  session$clientData$url_port)
    }
    
    marcador<-paste0("http://",
                     session$clientData$url_hostname,
                     x,
                     session$clientData$url_pathname,
                     "?",
                     "inCountry=",inCountry,
                     '&',
                     "inStyle=",inStyle,
                     '&',
                     "Seasons=",Seasons,
                     '&',
                     "Episodes=",Episodes
                     )
    updateTextInput(session,"url_param",value = marcador)
    
  })
  
  
  output$tabla_1 <- DT::renderDataTable({
    tabla <- data 
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
    
    ifelse(input$inYearS != 0,tabla <- tabla %>% filter(between(`Premiere_Year`,input$inYearS[1],input$inYearS[2])),tabla)
    ifelse(input$inYearE != 0,tabla <- tabla %>% filter(between(`Final_Year`,input$inYearE[1],input$inYearE[2])),tabla)
    
    tabla <- tabla %>% select(Title, Seasons, Episodes, Country, `Premiere_Year`,`Final_Year`,`Original_Channel`, Technique)
    
    tabla %>% DT::datatable(rownames = FALSE)
  })
  
  
  output$plot_1 <- renderPlotly({
    info <- data %>% 
      mutate(tiempo = Final_Year - Premiere_Year) %>% 
      arrange(desc(tiempo)) %>% 
      head(5)
    
    
    plot_ly(info, x=~Title, y=~tiempo, type="bar", color=~Episodes) %>% 
          layout(title = 'Series con mayor tiempo al aire', 
                 yaxis = list(title = 'Airtime '), 
                 xaxis = list(title = 'Serie Title'))
                 #width=1200, height=250)
  })
  
  output$plot_2 <- renderPlotly({
    info <- data %>% 
      arrange(desc(Episodes)) %>%
      head(3)
    
    plot_ly(info, x=~Title, y=~Episodes, type="bar") %>% 
      layout(title = 'Series con más episodios', 
             yaxis = list(title = 'Episodes '), 
             xaxis = list(title = 'Serie Title'))
  })
  
  
  output$plot_3 <- renderPlotly({
    
    series = c(nrow(data %>% select(Technique) %>% filter(grepl("TRADITIONAL",Technique))),  
               nrow(data %>% select(Technique) %>% filter(grepl("FLASH",Technique))),  
               nrow(data %>% select(Technique) %>% filter(grepl("CGI",Technique))),
               nrow(data %>% select(Technique) %>% filter(grepl("STOP-MOTION",Technique))), 
               nrow(data %>% select(Technique) %>% filter(grepl("STOP-MOTION",Technique))),
               nrow(data %>% select(Technique) %>% filter(grepl("LIVE-ACTION",Technique))), 
               nrow(data %>% select(Technique) %>% filter(grepl("SYNCRO-VOX",Technique))),
               nrow(data %>% select(Technique) %>% filter(grepl("TOON-BOOM",Technique))),
               nrow(data %>% select(Technique) %>% filter(grepl("CLAYMATION",Technique)))
    )
    
    Technique = c("TRADITIONAL","FLASH","CGI","STOP-MOTION","TOON-BOOM-HARMONY",
                  "LIVE-ACTION","SYNCRO-VOX","TOON-BOOM","CLAYMATION")
    
    info <- data.frame(techniques = Technique, 
                       Seriess = series)
    
    
    
    plot_ly(info, x=~Technique, y=~series, type="bar") %>% 
      layout(title = 'Series por Tecnica de Animacion',
             yaxis = list(title = 'Series amount '), 
             xaxis = list(title = 'Tecnica'))
    
  })
  

  
  
})
