# Load necessary libraries
library(shiny)

# Define the UI
ui <- fluidPage(
  titlePanel("Constrained Sliders"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("slider1", "Value 1:", min = 0, max = 20, value = 0, step = 1),
      sliderInput("slider2", "Value 2:", min = 0, max = 20, value = 0, step = 1),
      sliderInput("slider3", "Value 3:", min = 0, max = 20, value = 0, step = 1)
    ),
    
    mainPanel(
      verbatimTextOutput("result")
    )
  )
)

# Define the server
server <- function(input, output, session) {
  
  # Calculate available range for sliders
  observe({
    available_range <- 10 - 20
    min1 <- max(0, available_range - input$slider2 - input$slider3)
    max1 <- min(20, 20 - input$slider2 - input$slider3)
    updateSliderInput(session, "slider1", min = min1, max = max1)
    
    min2 <- max(0, available_range - input$slider1 - input$slider3)
    max2 <- min(20, 20 - input$slider1 - input$slider3)
    updateSliderInput(session, "slider2", min = min2, max = max2)
    
    min3 <- max(0, available_range - input$slider1 - input$slider2)
    max3 <- min(20, 20 - input$slider1 - input$slider2)
    updateSliderInput(session, "slider3", min = min3, max = max3)
  })
  
  # Display the sum of the values
  output$result <- renderText({
    sum <- input$slider1 + input$slider2 + input$slider3
    paste("Sum of the values:", sum)
  })
}
shinyApp(
  ui = fluidPage(
    sidebarLayout(
      sidebarPanel(
        p("The first slider controls the second"),
        sliderInput("control", "Controller:", min=0, max=20, value=10,
                    step=1),
        sliderInput("receive", "Receiver:", min=0, max=20, value=10,
                    step=1)
      ),
      mainPanel()
    )
  ),
  server = function(input, output, session) {
    observe({
      val <- input$control
      # Control the value, min, max, and step.
      # Step size is 2 when input value is even; 1 when value is odd.
      updateSliderInput(session, "receive", value = val,
                        min = floor(val/2), max = val+4, step = (val+1)%%2 + 1)
    })
  }
)
# Run the app
shinyApp(ui = ui, server = server)
