library(shiny)
load("emaildatacleaned.RData")


shinyServer(function(input, output) {
  
  emailData <- reactive({
    s <- input$sender
    d1 <- input$dateRange[1]
    d2 <- input$dateRange[2]
    o <- dfEmails[dfEmails$Category==s,]
    o <- subset(o, Date > as.Date(d1))
    o <- subset(o, Date < as.Date(d2))
    t <- table(o$Date)
    t
    })

  output$distPlot <- renderPlot({
    number <- emailData()
    # draw the barplot 
    plot(number)

  })
  
  output$dateRangeText  <- renderText({
    paste("Input date range is", 
          paste(as.character(input$dateRange), collapse = " to ")
    )
  })
  

})
