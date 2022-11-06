library(shiny)
library(DT)
library(plotly)


dataset <- readRDS("data.rds")

shinyUI(fluidPage(
  
  titlePanel("CARTOON SERIES INFORMATION"),
  
  mainPanel(width = 12,
    tabsetPanel(
      tabPanel("Listado de Series",
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
                 )
               ),
               fluidRow(
                 column(12,textInput("url_param","Marcador: ",value = "", width = "75%"))
               ),
               fluidRow(
                 column(12,DT::dataTableOutput("tabla_1"))
               )
      ), # Fin de Filtros
      
      tabPanel("Metricas generales",
               fluidRow(
                 column(4,plotly::plotlyOutput("plot_1")), 
                 column(4,plotly::plotlyOutput("plot_2")), 
                 column(4,plotly::plotlyOutput("plot_3"))
               )
               
      ), # Fin de Graficas
      
      tabPanel("Mi lista",
               fluidRow(column(8,
                               h2('Series disponibles'),
                               h4('(Has click para añadir a tu lista)'),
                               DT::dataTableOutput('tabla_3'),
                               verbatimTextOutput('output_1')),
                        column(4,
                               h2('Mis series'),
                               h4('(Has click para eliminarla de tu lista)'),
                               DT::dataTableOutput('tabla_4'),
                               verbatimTextOutput('output_2')
                        )
               )

               
      ), # Fin de Mi lista
      
      tabPanel("Simulacion",
               fluidRow(column(6, 
                               numericInput("episodios","¿Cuantos episodios puedes ver al dia?",
                                            value = 1, step = 1, 
                                            width = "100%")
                               )
                        ),
               fluidRow(column(12,
                               plotlyOutput("plot_dias"), 
                               h4('Terminarías las series de tu lista en este tiempo')
                               ) 
                        
                        )
               
               
      ) # Fin de Mi lista
      
      
      
      
    ) ## fin de tabsetPanel
    
    
  ) ## fin del mainPanel 
  
  
))