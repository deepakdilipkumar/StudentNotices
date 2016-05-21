library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("sender", "Sender type:",
                   c("Deans", "DepartmentHeads", "Directors", "Student Reps", "Registrar", "Security", "Misc")),
      br(),
      dateRangeInput('dateRange',
                     label = 'Date range input: yyyy-mm-dd',
                     start = "2014-12-01", end = "2015-01-01"
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("dateRangeText"),
      plotOutput("distPlot")
    )
  )
))
