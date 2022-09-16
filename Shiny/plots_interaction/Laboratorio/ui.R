
library(shiny)
#library(shinydashboard)


shinyUI(fluidPage(

    # Application title
    titlePanel("Laboratorio"),

    # Sidebar with a slider input for number of bins
    shiny::tabsetPanel(
        tabPanel("Plot Interactions",
                 plotOutput("plot_click_options",
                            click = "clk",
                            dblclick = "dclk",
                            hover = 'mhover',
                            brush = 'mbrush' ),
                 verbatimTextOutput("click_data"),
                 textOutput("mtcars_tbl")
        )
    )
))
#dashboardBody(textOutput(outputId = "out"))