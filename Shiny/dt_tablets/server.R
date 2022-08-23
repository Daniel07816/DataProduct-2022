library(shiny)
library(DT)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {

  output$tabla_1 = renderDataTable({
    mtcars %>% datatable(rownames = FALSE, selection = 'single', filter = 'top', 
        options = list(scrollX = TRUE))
  })
  
  output$output_1 = renderText({
    input$tabla_1_rows_selected
  })
  
  output$tabla_2 = renderDataTable({
    mtcars %>% datatable(rownames = FALSE, filter = 'top', options = list(scrollX = TRUE))
  })

  output$output_2 = renderText({
    input$tabla_2_rows_selected
  })
  
  output$tabla_3 = renderDataTable({
    diamonds %>% mutate(vol = x*y*z, vol_prom = mean(vol), volp = vol/vol_prom-1) %>% datatable(
    filter = 'top', selection = list(mode = 'single', target = 'column'), 
    options = list(scrollX = TRUE)) %>% formatCurrency(columns = 'price', currency = '$') %>%
    formatPercentage(columns = 'volp', digits = 2)
  })
  
  output$output_3 = renderText({
    input$tabla_3_columns_selected
  })
  
  output$tabla_4 = renderDataTable({
    diamonds %>% mutate(vol = x*y*z, vol_prom = mean(vol), volp = vol/vol_prom-1) %>% datatable(
      filter = 'top', selection = list(target = 'column'), options = list(scrollX = TRUE)) %>% 
      formatCurrency(columns = 'price', currency = '$') %>% formatPercentage(columns = 'volp', digits = 2)
  })
  
  output$output_4 = renderText({
    input$tabla_4_columns_selected
  })
  
})
