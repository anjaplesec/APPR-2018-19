library(shiny)

fluidPage(
  titlePanel("Brezposelnost po občinah"),
  tabPanel("Graf",
           sidebarPanel(
             selectInput("obcina", label = "Izberite občino:",
                         choices= (sort(unique(zadnja_faza$obcina))))),
           mainPanel(plotOutput("brezposelnost")))
)
