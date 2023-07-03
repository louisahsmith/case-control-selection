function renderChart(filledIcons) {
	// Function to generate a tooltip message based on the quadrant and fill status
	function getTooltipMessage(d) {
		const quadrant = d.quadrant;
		const fillStatus = d.fill ? "Filled" : "Outline";
		// Return the tooltip message based on the quadrant and fill status
		return `Quadrant ${quadrant} - ${fillStatus} Icon`;
	}
	// Create the tooltip div
	const tooltip = d3.select("#chart-container")
		.append("div")
		.attr("class", "tooltip")
		.style("opacity", 0)
		.style("position", "absolute");

	// Event handlers for the tooltip
	function mouseover(event, d) {
		tooltip.transition()
			.duration(200)
			.style("opacity", 1);
		tooltip.html(getTooltipMessage(d))
			.style("left", (event.clientX + 10) + "px")
			.style("top", (event.clientY - 10) + "px");
	}

	function mousemove(event) {
		tooltip.style("left", (event.clientX + 10) + "px")
			.style("top", (event.clientY - 10) + "px");
	}

	function mouseout(event) {
		tooltip.transition()
			.duration(500)
			.style("opacity", 0);
	}

	// Function to determine if an icon should be filled or not
	function shouldFillIcon(x, y, filledCount) {
		// Determine the length of the filled square
		const squareSize = Math.floor(Math.sqrt(filledCount));
		// Determine the number of icons that are beyond the square
		const remaining = filledCount - squareSize * squareSize;
		// If the x and y coordinates are within the square, return true
		if (x <= squareSize && y <= squareSize) {
			return true;
		}
		// If an exact square is filled, return false
		if (remaining === 0) {
			return false;
		}
		// If the x coordinate is beyond the square, return true 
		// if the y coordinate is less than the remaining icons
		if (y <= squareSize && x === squareSize + 1) {
			return y < remaining;
		}
		return false;
	}
	
	const colors = ["#E69F00", "#56B4E9", "#009E73", "#CC79A7"];
	
	const data = [];
	
	// Generate the data for the visualization
	// Each quadrant is a separate array of data
	for (let quadrant = 1; quadrant <= 4; quadrant++) {
		// Each quadrant is a 10x10 grid
		for (let y = 1; y <= 10; y++) {
			for (let x = 1; x <= 10; x++) {
				// Adjust the x and y coordinates based on the quadrant
				let xPos = x;
				let yPos = y;
				if (quadrant === 3) {
					xPos = 11 - x;
				} else if (quadrant === 2) {
					yPos = 11 - y;
				} else if (quadrant === 1) {
					xPos = 11 - x;
					yPos = 11 - y;
				}
				// Determine if the icon should be filled
				const fill = shouldFillIcon(xPos, yPos, filledIcons[quadrant - 1]);
				data.push({
					quadrant,
					x,
					y,
					color: colors[quadrant - 1],
					fill,
				});
			}
		}
	}
	
	const width = 440;
	const height = 440;
	const cellSize = 20;
	const quadrantWidth = width / 2;
	const quadrantHeight = height / 2;
	const iconSize = 14; // Adjust icon size as needed
	
	// Create the chart
	const chart = d3.select("#chart")
		.append("div")
		.style("position", "relative")
		.style("width", width + "px")
		.style("height", height + "px")
		.style("background-color", "white");
		
	// Add the icons to the chart
	const icons = chart.selectAll(".fa")
		.data(data)
		.join("i")
		// Use the font awesome user icon
		.attr("class", d => d.fill ? "fa fa-user" : "fa fa-user-o")
		.style("position", "absolute")
		.style("left", d => ((d.quadrant - 1) % 2) * quadrantWidth + d.x * cellSize - iconSize / 2 + "px")
		.style("top", d => (Math.floor((d.quadrant - 1) / 2)) * quadrantHeight + d.y * cellSize - iconSize / 2 + "px")
		.style("font-size", iconSize + "px")
		.style("color", d => d.color)
		.on("mouseover", mouseover) // Add the mouseover event handler
		.on("mousemove", mousemove) // Add the mousemove event handler
		.on("mouseout", mouseout); // Add the mouseout event handler
		
	// Draw black lines for quadrants separation
	const separatorWidth = 2;
	
	// Draw the vertical separator
	chart.append("div")
		.style("position", "absolute")
		.style("left", quadrantWidth - separatorWidth / 2 + "px")
		.style("top", "0px")
		.style("width", separatorWidth + "px")
		.style("height", height + separatorWidth + "px") // Add separatorWidth to the height
		.style("background-color", "black");
		
	// Draw the horizontal separator
	chart.append("div")
		.style("position", "absolute")
		.style("left", "0px")
		.style("top", quadrantHeight - separatorWidth / 2 + "px")
		.style("width", width + "px")
		.style("height", separatorWidth + "px")
		.style("background-color", "black");
		
}