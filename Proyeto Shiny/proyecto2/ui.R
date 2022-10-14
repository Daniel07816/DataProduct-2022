#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Informacion de Series"),

    # Sidebar with a slider input for number of bins
    tabsetPanel(
      tabPanel("Filtros", icon = icon("table"), value = "table", 
               mainPanel(
                 width = 12, style="margin-left:0.5%; margin-right:0.5%",
                 fluidRow(
                   br(),
                   p("Filtros", 
                     style = "font-weight: bold; color: black;"),
                   p("Seleccione al menos un filtro para mostrar la tabla. "),
                   br()
                 ),
                 fluidRow(
                   column(3,
                          selectInput("inHostName","Select host name: ",c("Todos",unique(df$`host name`))),
                          selectInput("inNeighbourHood","Select neighbourhood group: ",c("Todos",unique(df$`neighbourhood group`)))
                   ),
                   column(4,
                          checkboxGroupInput('chkbox_group_input',
                                             'Select room type:',
                                             choices = unique(df$`room type`),
                                             selected = NULL,inline = TRUE),
                          br(),
                          sliderInput('inPrice','Select price:',
                                      value = c(min(df$price),max(df$price)),
                                      min = min(df$price), 
                                      max=max(df$price),
                                      step = 1,
                                      pre = '$',
                                      sep = ',' )
                          
                   ),
                   column(2,
                          numericInput("inAvil","Availability 365:",
                                       value = 0, step = 1 )
                          
                   ),
                 ),
                 fluidRow(
                   div(DT::dataTableOutput("tabla")),
                   style = "font-size: 98%; width: 100%"
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
               h1('Vista Basica'),
               fluidRow(
                 column(12,DT::dataTableOutput("tabla_1"))
               ),
               h1("Agregar filtros"),
               fluidRow( column(12, DT::dataTableOutput("tabla_2")))
      )
    )
))
