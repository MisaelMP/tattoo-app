document.addEventListener('turbo:load', function () {
	if (!document.getElementById('map')) {
		// There is no map div on this page, so don't run code below
		return;
	}

	const mapElement = document.getElementById('map');
	const latitude = mapElement.dataset.latitude;
	const longitude = mapElement.dataset.longitude;
	const title = mapElement.dataset.title;

	if (typeof google === 'undefined') {
		console.error('Google Maps not loaded');
		return;
	}

	const handler = Gmaps.build('Google');
	handler.buildMap({ provider: {}, internal: { id: 'map' } }, function () {
		markers = handler.addMarkers([
			{
				lat: latitude,
				lng: longitude,
				// "picture": {
				//   "url": "http://fillmurray.com/32/32",
				//   "width":  32,
				//   "height": 32
				// },
				infowindow: app.username,
			},
		]);
		handler.bounds.extendWith(markers);
		handler.fitMapToBounds();
	});
});
