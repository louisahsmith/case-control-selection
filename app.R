
library(shiny)
library(shinyMatrix)

ui <- fluidPage(
    titlePanel("Selection bias"),
    tags$head(
        tags$script(src = "https://d3js.org/d3.v6.min.js"),
        tags$script(src = "chart.js")
    ),
    mainPanel(
            column(3,
            h4("Full data"),
            numericInput("cases", "Cases", value = 0),
            numericInput("controls", "Controls", value = 0)
            ),
            column(3,
                   h4("Probability of exposure"),
                   numericInput("all_cases", "All cases", value = 0),
                   numericInput("all_controls", "All controls", value = 0)
        ),

            column(4,
                   tags$table(style = "width: 100%;",
                              tags$tr(
                                  tags$th(""),
                                  tags$th("Cases", style = "text-align: center;"),
                                  tags$th("Controls", style = "text-align: center;")
                              ),
                              tags$tr(
                                  tags$td("Exposed"),
                                  tags$td(numericInput("exposed_cases", "", value = 0, width = "100%")),
                                  tags$td(numericInput("exposed_controls", "", value = 0, width = "100%"))
                              ),
                              tags$tr(
                                  tags$td("Unexposed"),
                                  tags$td(numericInput("unexposed_cases", "", value = 0, width = "100%")),
                                  tags$td(numericInput("unexposed_controls", "", value = 0, width = "100%"))
                              )
                   )
                   ),
        column(4,
               tags$script('
                           // Render the chart‘s initial state
renderChart([100, 100, 100, 100]);
	
// Add the event listener to the form
// NONE OF THESE ELEMENTS EXIST YET IN THE SHINY DOC!
document.getElementById("input-form")
    .addEventListener("submit", (event) => {
        event.preventDefault();
        
        // Get the values from the form
        const numerators = [
            parseFloat(document.getElementById("q1-numerator")
                .value),
            parseFloat(document.getElementById("q2-numerator")
                .value),
            parseFloat(document.getElementById("q3-numerator")
                .value),
            parseFloat(document.getElementById("q4-numerator")
                .value),
        ];
        
        const denominators = [
            parseFloat(document.getElementById("q1-denominator")
                .value),
            parseFloat(document.getElementById("q2-denominator")
                .value),
            parseFloat(document.getElementById("q3-denominator")
                .value),
            parseFloat(document.getElementById("q4-denominator")
                .value),
        ];
        
        // Calculate the proportion of filled icons for each quadrant
        const filledIcons = numerators.map((numerator, index) => {
            return (numerator / denominators[index]) * 100;
        });
        
        // Clear the chart content only
        d3.select("#chart")
            .html("");
            
        // Render the chart with the new filledIcons values
        renderChart(filledIcons);
    });'),
                div(id = "chart-container",
      div(id = "chart")
  ))
    )
)


server <- function(input, output, session) {
    
    observeEvent(list(input$cases, input$controls, input$matrix, input$all_cases, input$all_controls), {
        updateNumericInput(session, "cases", value = input$cases)
        all_cases_value <- input$matrix[1, 1] / input$cases
        updateNumericInput(session, "all_cases", value = all_cases_value)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
