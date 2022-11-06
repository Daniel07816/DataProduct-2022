#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(readr)
library(dplyr)
library(ggplot2)

#Dataset
dataset <- readRDS("data.rds")

shinyUI(fluidPage(

    # Application title
    titlePanel("Series Information"),

    # Sidebar with a slider input for number of bins
    tabsetPanel(
      tabPanel("Filtros", icon = icon("table"), value = "table", 
               mainPanel(
                 width = 12, style="margin-left:0.5%; margin-right:0.5%",
                 fluidRow(
                   br(),
                   p("Filtros", 
                     style = "font-weight: bold; color: black;"),
                   p("Select at least one filter to deploy the table"),
                   br()
                 ),
                 fluidRow(
                   column(3,
                          selectInput("inCountry","Select country of production: ",c("All",unique(dataset$Country))),
                          selectInput("inStyle","Type style of production: ",c("All",unique(dataset$Technique)))
                   ),
                   column(4,
                          br(),
                          sliderInput('inYearS','Select premiere year range:',
                                      value = c(min(dataset$`Premiere Year`),max(dataset$`Premiere Year`)),
                                      min = min(dataset$`Premiere Year`), 
                                      max=max(dataset$`Premiere Year`),
                                      step = 1,
                                      sep = ',' ),
                          br(),
                          sliderInput('inYearE','Select end year range:',
                                      value = c(min(dataset$`Final Year`),max(dataset$`Final Year`)),
                                      min = min(dataset$`Final Year`), 
                                      max=max(dataset$`Final Year`),
                                      step = 1,
                                      sep = ',' )
                          
                   ),
                   column(2,
                          numericInput("Seasons","Amount of Seasons:",
                                       value = 0, step = 1 ),
                          numericInput("Episodes","Amount of Episodes:",
                                       value = 0, step = 1 )
                          
                   ),
                 ),
                 fluidRow(
                   div(DT::renderDataTable("tabla_1")),
                   # style = "font-size: 98%; width: 100%"
                 )
               )
      ),
      tabPanel("Graficas",
               h1('Vista Basica'),
               fluidRow(
                 column(12,DT::dataTableOutput("tabla_1"))
               ),
               h1("Agregar filtros"),
               fluidRow( column(12, DT::dataTableOutput("tabla_2")))
      ),
      tabPanel("Adicionales",

                 column(12,tableOutput('table1'))

      )
    )
))
