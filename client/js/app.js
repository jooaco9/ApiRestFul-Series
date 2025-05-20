// Selecciono container de series
let seriesList = document.getElementById('series-container');

// Request contra el Apirestful Get series
fetch("http://localhost:8000/series", {method: "GET"})
.then((response) => response.json())
.then((series) => {	
	console.log("Series:", series);
})
.catch((err) => console.log("Error", err))