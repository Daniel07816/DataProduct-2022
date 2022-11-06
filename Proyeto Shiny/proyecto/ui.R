
library(shiny)
library(DT)
library(plotly)


dataset <- readRDS("data.rds")

shinyUI(fluidPage(
  
  titlePanel("SERIES INFORMATION"),
  
  mainPanel(width = 12,
    tabsetPanel(
      tabPanel("Data con filtros",
               fluidRow(
                 column(4,
                        selectInput("inCountry","Select country of production: ",
                                    c("All",unique(dataset$Country)), 
                                    width = "100%"),
                        selectInput("inStyle","Type style of production: ",
                                    c("All",unique(dataset$Technique)),
                                    width = "100%")
                 ),
                 column(4,
                        br(),
                        sliderInput('inYearS','Select premiere year range:',
                                    value = c(min(dataset$`Premiere_Year`),max(dataset$`Premiere_Year`)),
                                    min = min(dataset$`Premiere_Year`), 
                                    max=max(dataset$`Premiere_Year`),
                                    step = 1,
                                    sep = ',', 
                                    width = "100%"),
                        br(),
                        sliderInput('inYearE','Select end year range:',
                                    value = c(min(dataset$`Final_Year`),max(dataset$`Final_Year`)),
                                    min = min(dataset$`Final_Year`), 
                                    max=max(dataset$`Final_Year`),
                                    step = 1,
                                    sep = ',', 
                                    width = "100%")
                        
                 ),
                 column(4,
                        numericInput("Seasons","Amount of Seasons:",
                                     value = 0, step = 1, 
                                     width = "100%"),
                        numericInput("Episodes","Amount of Episodes:",
                                     value = 0, step = 1, 
                                     width = "100%")
                 ),
               ),
               fluidRow(
                 column(12,textInput("url_param","Marcador: ",value = "", width = "75%"))
               ),
               fluidRow(
                 column(12,DT::dataTableOutput("tabla_1"))
               )
      ), # Fin de Filtros
      
      tabPanel("Graficas",
               fluidRow(
                 column(4,plotly::plotlyOutput("plot_1")), 
                 column(4,plotly::plotlyOutput("plot_2")), 
                 column(4,plotly::plotlyOutput("plot_3"))
               )
               
      ), # Fin de Graficas
      
      tabPanel("a",
               fluidRow(

               )
               
      ) # Fin de Graficas
      
      
      
      
      
      
      
      
      
      
      
      
      
      
    ) ## fin de tabsetPanel
    
    
    
    
  ) ## fin del mainPanel 
  
  
))