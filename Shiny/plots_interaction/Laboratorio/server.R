library(shiny)
library(ggplot2)
library(dplyr)
library(DT)


puntos <- reactiveValues()
punto <- reactiveValues()
mmtcars <- mtcars[1,]
mmtcars <- mmtcars[!TRUE,]

shinyServer(function(input, output) {
  
  output$grafica_base_r <- renderPlot({
    plot(mtcars$wt,mtcars$mpg, xlab = "wt", ylab="millas por galon")
  })
  
  output$click_data <- renderPrint({
    clk_msg <- NULL
    dclk_msg<- NULL
    mhover_msg <- NULL
    mbrush_msg <- NULL
    if(!is.null(input$clk$x) ){
      clk_msg<-
        paste0("click cordenada x= ", round(input$clk$x,2),
               " click coordenada y= ", round(input$clk$y,2))
    }
    if(!is.null(input$dclk$x) ){
      dclk_msg<-paste0("doble click cordenada x= ", round(input$dclk$x,2), 
                       " doble click coordenada y= ", round(input$dclk$y,2))
    }
    if(!is.null(input$mhover$x) ){
      mhover_msg<-paste0("hover cordenada x= ", round(input$mhover$x,2), 
                         " hover coordenada y= ", round(input$mhover$y,2))
      punto[["uno"]] <- nearPoints(mtcars,input$mhover,xvar='wt',yvar='mpg')
    }
    
    
    if(!is.null(input$mbrush$xmin)){
      brushx <- paste0(c('(',round(input$mbrush$xmin,2),',',round(input$mbrush$xmax,2),')'),collapse = '')
      brushy <- paste0(c('(',round(input$mbrush$ymin,2),',',round(input$mbrush$ymax,2),')'),collapse = '')
      mbrush_msg <- cat('\t rango en x: ', brushx,'\n','\t rango en y: ', brushy)
      
    }
    
    cat(clk_msg,dclk_msg,mhover_msg,mbrush_msg,sep = '\n')
  })
  
  
  puntos_posibles <- reactive({
    posible = nearPoints(mtcars,input$clk,xvar='wt',yvar='mpg')
    if(nrow(posible) != 0){
      direccion <- toString(posible$wt-posible$mpg)
      puntos[[direccion]] <- posible
    }
    
    posible = nearPoints(mtcars,input$dclk,xvar='wt',yvar='mpg')
    if(nrow(posible) != 0){
      direccion <- toString(posible$wt-posible$mpg)
      puntos[[direccion]] <- mmtcars
    }
    
    posibles = brushedPoints(mtcars,input$mbrush,xvar='wt',yvar='mpg')
    if(nrow(posibles) != 0){
      
      for (i in 1:nrow(posibles)) {
        row <- posibles[i,]
        direccion <- toString(row$wt-row$mpg)
        puntos[[direccion]] <- row
      }
    }
    
    return(puntos)
  })
  
  
  imprimir <- reactive({
    listado <- reactiveValuesToList(puntos_posibles())
    
    dta <- data.frame(NULL)
    
    if(length(listado) != 0){
      
      for (i in 1:length(listado)) {
        row <- listado[[i]]
        dta <- rbind(dta, row)
      }
    }
    
    return(dta)
  })
  
  
  
  output$plot_click_options <- renderPlot({
    lista <<- reactiveValuesToList(puntos_posibles())
    lista2 <<- reactiveValuesToList(punto)
    plot(mtcars$wt,mtcars$mpg, xlab = "wt", ylab="millas por galon")
    lapply(lista2, impresor2)
    lapply(lista, impresor)
  })
  
  output$mtcars_tbl <- renderTable({
    imprimir()
  })
  
  
  impresor <- function(list){
    points(list$wt,list$mpg,col='green',pch=19)
  }
  
  impresor2 <- function(list){
    points(list$wt,list$mpg,col='gray',pch=19)
  }
  
})