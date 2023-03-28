library(shiny)

ui <- fluidPage(
   "Hello, world!"
)

server <- function(input, 
                   output, 
                   session) {}


shinyApp(ui, server)

############


ui <- fluidPage(
   selectInput("dataset", 
               label = "Dataset",
               choices = 
                  ls("package:datasets")),
   verbatimTextOutput("summary"),
   tableOutput("table")
)

server <- function(input, 
                   output, 
                   session) {}

shinyApp(ui, server)



############

ui <- fluidPage(
   selectInput("dataset", 
               label = "Dataset",
               choices = 
                  ls("package:datasets")),
   verbatimTextOutput("summary"),
   tableOutput("table")
)

server <- function(input, output, session){
   output$summary <- 
      renderPrint({
         dataset <- get(input$dataset, "package:datasets")
         summary(dataset)})
   
   output$table <- 
      renderTable({
         dataset <- get(input$dataset, "package:datasets")
         dataset})
}


shinyApp(ui, server)

############

ui <- fluidPage(
   selectInput("dataset", 
               label = "Dataset",
               choices = 
                  ls("package:datasets")),
   verbatimTextOutput("summary"),
   tableOutput("table")
)

server <- function(input, output, session){
   # Create a reactive expression
   dataset <- reactive({
      get(input$dataset, "package:datasets")
   })
   
   output$summary <-renderPrint({
      # Use a reactive expression by calling it like a function
      summary(dataset())
   })
   
   output$table <- 
      renderTable({
         dataset()
      })
}

shinyApp(ui, server)

############

ui <- fluidPage(
   numericInput(inputId = "n",
                "Sample size", value = 25),
   plotOutput(outputId = "hist")
)

server <- function(input, output, session){
   output$hist <- renderPlot({
      hist(rnorm(input$n))
   })
}

shinyApp(ui, server)

##########

runExample("01_hello")
