library(shiny)
library(dplyr)
# library(ggplot2)
library(plotly)


data <- readRDS("data.rds")

mi_lista <- data %>% head(1)
mi_lista <- mi_lista[-1,]


shinyServer(function(input, output, session) {
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    inCountry <- query[["inCountry"]]
    inStyle <- query[["inStyle"]]
    Seasons  <- query[["Seasons"]]
    Episodes  <- query[["Episodes"]]
    
    inYearS1  <- query[["inYearS1"]]
    inYearS2  <- query[["inYearS2"]]
    inYearE1  <- query[["inYearE1"]]
    inYearE2  <- query[["inYearE2"]]
    
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
    
    
    
    if(!is.null(inYearS1) && !is.null(inYearS2)){
      updateSliderInput(session, "inYearS", value=c(as.numeric(inYearS1), as.numeric(inYearS2)) )
    }

    if(!is.null(inYearE1) && !is.null(inYearE2)){
      updateSliderInput(session, "inYearE", value=c(as.numeric(inYearE1), as.numeric(inYearE2)) )
    }
    
    
  })
  
  
  observe({
    inCountry <- input$inCountry
    inStyle <- input$inStyle
    Seasons  <- input$Seasons
    Episodes  <- input$Episodes
    
    inYearS1  <- input$inYearS[1]
    inYearS2  <- input$inYearS[2]
    inYearE1  <- input$inYearE[1]
    inYearE2  <- input$inYearE[2]
    
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
                     "Episodes=",Episodes,
                     '&',
                     "inYearS1=",inYearS1,
                     '&',
                     "inYearS2=",inYearS2,
                     '&',
                     "inYearE1=",inYearE1,
                     '&',
                     "inYearE2=",inYearE2
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
  
  
  output$tabla_3 <- DT::renderDataTable({
    mi_lista_reactiva()
    data %>% select(Title,Seasons,Episodes, `Premiere_Year`) %>% DT::datatable(selection = 'single')
  })
  
  
  mi_lista_reactiva <- reactive({
    n_row <- input$tabla_3_rows_selected
    n_row_elim <- input$tabla_4_rows_selected
    
    if(!is.null(n_row_elim)){
      mi_lista <<- mi_lista[-n_row_elim,]
      
    }
    
    if(!is.null(n_row)){
      new <- data[n_row,]
      mi_lista <<- rbind(mi_lista, new)
      mi_lista <<- unique(mi_lista)
    }
    
    
    return(mi_lista)
  })
  
  output$output_1 <- renderPrint({
    input$tabla_3_rows_selected
  })
  
  output$tabla_4 <- DT::renderDataTable({
    mi_lista_reactiva() %>% select(Title) %>% DT::datatable(selection = 'single')
  })
  
  
  output$output_2 <- renderPrint({
    input$tabla_4_rows_selected
  })
  
  
  output$plot_dias <- renderPlotly({
    mis_episodios <- sum(mi_lista_reactiva()$Episodes)
    
    episodios <- input$episodios
    
    
    #mis_episodios <- 30
    
    #episodios <- 2
    
    
    if(mis_episodios > 0 && episodios > 0) {
      dias <- round(mis_episodios / episodios,0)
      
      info <- data.frame(dia = seq(1, dias, 1), 
                         episodios_acumulados = seq(episodios, dias * episodios, episodios))
      
      plot_ly(info, x = ~dia, y=~episodios_acumulados, color=~episodios_acumulados, type = "bar")
    }
    else{
      plot_ly(x = c(1), y=c(1), type = "bar")
    }
  })
  
})
