library(shiny)
library(scales)
library(ggplot2)

#Importing file
library(readr)
stocks <- read.csv("stocks.csv")
stocks$Year <- as.Date(stocks$date)
#Setting up the UI
ui <- fluidPage(
  
  titlePanel("Top Tech Companies"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Tech", label = "Company (select multiple to compare)", 
                  choices = unique(stocks$company),
                  multiple = TRUE,
                  selected = 'Google'),
      
      radioButtons("criteria", label = "Comparison Criteria",
                   choices = list("Closing Price" = 'closePrice',
                                  "Volume" = 'volume'), selected = 'closePrice')
      
    ),
    mainPanel('Performance of Top Tech Companies',
              
              
              plotOutput("myplot"),
              textOutput('mytext')),
    
    position = 'left'
  )
)

# Creating Server function
server <- function(input, output) {
  
  output$myplot <- renderPlot(
    ggplot(data = subset(stocks, company == input$Tech), aes_string(x = 'Year', y = input$criteria, color = 'company')) +
      geom_line() +
      scale_y_continuous(labels = comma) +
      labs(color = 'Company')
  )
  
  output$mytext <- renderText(
    
    paste('You chose to visualize the performance of', input$Tech, 'on the basis', input$criteria, 'of shares')
    
  )  
  
}

#Running the server
shinyApp(ui, server)
