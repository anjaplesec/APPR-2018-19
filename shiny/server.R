library(shiny)

function(input, output) {
  
   output$brezposelnost <- renderPlot({
     tabela1 <- zadnja_faza %>% filter(obcina == input$obcina)
     print(ggplot(tabela1, aes(x = leta, y = stevilo)) + geom_line() + 
      ylab("Brezposelnost") + xlab("Leto") +
      ggtitle("Brezposelnost po občinah"))
  })
}
    
