library(shiny)
library(lubridate)

shinyUI(fluidPage(

    titlePanel("Shiny Inputs Glossary"),

    sidebarLayout(
        sidebarPanel(
           h1("Inputs"),
           numericInput("ninput", "Ingrese un numero:", value = 10),
           
           sliderInput('slinput', "Seleccione un porcentaje: ", min = 0, 
           max = 100, step = 1, value = 0, post = '%'),
          
           sliderInput('slinputmulti', "Seleccione un rango: ", value = c(
           10000,30000), min = 0, max = 150000, step = 1000, pre = "Q",
           sep = ','),
           
           sliderInput('slinputanimate', "Pasos: ", value = 0, min = 0, max = 100,
           step = 10, animate = TRUE),
           
           dateInput('date_input', "Ingrese Fecha: ", value = Sys.Date(), 
           language = 'es', weekstart = 1, format = 'dd-mm-yyyy'),
           
           dateRangeInput('date_range_input', "Seleccione Fechas: ", 
           start = today()-15, end = today(), max = today(), min = today()-365,
           language = 'es', weekstart = 1, separator = 'hasta'),
           
           selectInput('select_input', "Seleccione estado: ", choices = state.name,
           selected = state.name[sample(1:length(state.name), size = 1)]),
           
           selectInput('select_input_2', "Seleccione letras: ", choices = letters,
           selected = 'A', multiple = TRUE),
           
           checkboxInput('chbox_input', "Enviar email", value = FALSE),
           checkboxGroupInput('cchbox_group_input', "Seleccione opciones: ",
           choices = letters[1:4], selected = NULL)
        ),

        mainPanel(
          h1("Outputs"),
          h2("Numeric Input"),
          verbatimTextOutput('out_numeric_input'),
          h2("Slider Input"),
          h3('Slider Input Simple'),
          verbatimTextOutput('out_slider_input'),
          h3('Slider Input Multiple'),
          verbatimTextOutput('out_slider_input_multi'),
          h3('Slider Input Animated'),
          verbatimTextOutput('out_slider_input_ani'),
          h2("Date Input"),
          h3("Normal Date"),
          verbatimTextOutput('out_date_input'),
          h3("Date Range"),
          verbatimTextOutput('out_date_input_range'),
          h2("Select Input"),
          h3("State only one"),
          verbatimTextOutput('select_input'),
          h3("More Letters"),
          verbatimTextOutput('select_input_2'),
          h2("Checkbox"),
          h3("Email"),
          verbatimTextOutput('checkbox_output'),
          h3("Letras"),
          verbatimTextOutput('checkbox_output_2')
        )
    )
))
