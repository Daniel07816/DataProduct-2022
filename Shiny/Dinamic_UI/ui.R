library(shiny)

shinyUI(fluidPage(

    titlePanel("UI Dinamico"),

    tabsetPanel(tabPanel('Ejemplo1', numericInput('lim_inf', label = "Limite Inferior",
    value = 1), numericInput('lim_sup', label = "Limite Superior", value = 1),
    sliderInput('sl1', label = 'Seleccione intervalo', value = 5, min = 0, max = 15)),
    
    tabPanel('Ejemplo2', sliderInput('sl2', 'Seleccione: ', 
    value = 0, min = -10, max = 10), sliderInput('sl3', 'Seleccione: ', 
    value = 0, min = -10, max = 10), sliderInput('sl4', 'Seleccione: ', 
    value = 0, min = -10, max = 10), sliderInput('sl5', 'Seleccione: ', 
    value = 0, min = -10, max = 10), actionButton('limpiar', 'limpiar')),
    
    tabPanel('Ejemplo3', numericInput('runs', 'Cuantas corridas', value = 5),
    actionButton('correr', 'correr')),
    
    tabPanel('Ejemplo4', numericInput('nvalue', 'nvalue', value = 0)),
    
    tabPanel('Ejemplo5', numericInput('celsius', 'Ingrese grado C', value = NULL,
            step = 1), numericInput('farenheit', 'Ingrese grado F', value = NULL,
            step = 1)),
    
    tabPanel('Ejemplo 6',
             selectInput('dist','Distribucion',
                         choices = c('normal','uniforme','exponencial')),
             numericInput('nrandom','Numero de muestras',value = 100),
             tabsetPanel(id='parametros',
                         type = 'hidden',
                         tabPanel('normal',
                                  numericInput('n_media','media',value=0),
                                  numericInput('n_sd','desviacion',value=1)
                         ),
                         tabPanel('uniforme',
                                  numericInput('a','minimo',value=0),
                                  numericInput('b','maximo',value=1),
                         ),
                         tabPanel('exponencial',
                                  numericInput('lambda','razon',value=1,min=0)
                         )
             ),
             plotOutput('plot_dist')
    ))
))
