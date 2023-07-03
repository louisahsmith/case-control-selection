// Render the chart‘s initial state
renderChart([100, 100, 100, 100]);
	
// Add the event listener to the form
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
    });