library(shiny)
library(DT)

shinyUI(fluidPage(

    titlePanel("Carga de Archivo"),

    sidebarLayout(
        sidebarPanel(
            fileInput("file_input", 'Cargar Archivo', buttonLabel = 'Buscar',
            placeholder = 'No hay nada seleccionado')
        ),

        mainPanel(
          dataTableOutput('contenido_archivo')
        )
    )
))
