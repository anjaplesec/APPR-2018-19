library(shiny)
library("readr")

if(grepl("shiny",getwd())){setwd("..")}
source("uvoz/uvoz.r")
source("lib/libraries.r")


function(input, output) {
  output$izborTabPanel = renderUI({
    tabPanel("Graf",
             sidebarPanel(
               selectInput("obcina", label = "Izberite občino:",
                           choices= (sort(unique(obcine$obcina))))),
             mainPanel(plotOutput("brezposelnost")))
  })
  
  output$brezposelnost <- renderPlot({
    tabela1 <- obcine %>% filter(obcina == input$obcina)
    print(ggplot(tabela1) + geom_line(aes(x = leta, y = stevilo), group=1) + 
            ylab("Brezposelnost") + xlab("Leto") +
            ggtitle("Brezposelnost po občinah"))
  }) 
}