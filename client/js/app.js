// Selecciono container de series
let seriesList = document.getElementById('series-container');

// Request contra el Apirestful Get series
fetch("http://localhost:5001/series", {method: "GET"})
.then((response) => response.json())
.then((series) => {	
	console.log("Series:", series);

	let seriesCardsDOM = '';

	series.map((serie, index) => {
		seriesCardsDOM = seriesCardsDOM + `
			<div class="col-12 col-sm-6 col-md-4 col-lg-3 d-flex justify-content-center">
				<div class="card" style="width: 13rem;">
					<img src="..." class="card-img-top mt-5 mb-5 text-center" alt="Serie photo">
					<div class="card-body bg-body-tertiary">
						<h5 class="card-title fw-bold text-light">${serie.title}</h5>
						<p class="card-text">${serie.genres[0]} | ${serie.release_year}-${serie.end_year ? serie.end_year : ''}</p>
						<a href="#" class="btn btn-primary">More info</a>
					</div>
				</div>
			</div>
		`;
	});

	seriesList.innerHTML = seriesCardsDOM;
})
.catch((err) => console.log("Error", err))