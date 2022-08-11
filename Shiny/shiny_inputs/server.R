library(shiny)

shinyServer(function(input, output) {

  output$out_numeric_input = renderPrint({
    print(input$ninput)
    
  })
  
  output$out_slider_input = renderPrint({
    print(input$slinput)
  })
  
  output$out_slider_input_multi = renderPrint({
    print(input$slinputmulti)
  })
  
  output$out_slider_input_ani = renderPrint({
    print(input$slinputanimate)
  })
  
  output$out_date_input = renderPrint({
    print(input$date_input)
  })
  
  output$out_date_input_range = renderPrint({
    print(input$date_range_input)
  })
  
  output$select_input = renderPrint({
    print(input$select_input)
  })
  
  output$select_input_2 = renderPrint({
    print(input$select_input_2)
  })
  
  output$checkbox_output = renderPrint({
    print(input$chbox_input)
  })
  
  output$checkbox_output_2 = renderPrint({
    print(input$cchbox_group_input)
  })
  
})
