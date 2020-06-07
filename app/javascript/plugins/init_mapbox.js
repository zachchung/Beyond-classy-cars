// Pick up from node_modules:
import mapboxgl from 'mapbox-gl'; // For displaying map, markers, info window
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder'; // For search function on map

const createCustomMarker = (marker) => {
  // Custom marker: Create a HTML element for your custom marker
  const element = document.createElement('div');
  element.className = 'marker';
  element.style.backgroundImage = `url('${marker.image_url}')`; // pass from controller
  element.style.backgroundSize = 'contain';
  element.style.width = '25px';
  element.style.height = '25px';
  return element;
}

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => { // expect markers to be an array []
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow); // pass from controller -- info window

    // Create a new marker instance with the custom marker
    new mapboxgl.Marker(createCustomMarker(marker)) // new marker instance
      .setLngLat([marker.lng, marker.lat])
      .addTo(map) // display map
      .setPopup(popup);  // info window
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds(); // bounds- fit all markers into the map
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 3000 }); // change zoom duration (max: 5000 milliseconds) FUN!!!!!!!
};

const initMapbox = () => {
  const mapElement = document.getElementById('map'); // place to display map

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey; // get data-mapbox-api-key from index.html

    // new map instance:
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers); // get data-markers from index.html
    addMarkersToMap(map, markers); // add markers

    fitMapToMarkers(map, markers); // fit all markers into the map

    map.addControl(new MapboxGeocoder({ accessToken: mapboxgl.accessToken,
                                      mapboxgl: mapboxgl })); // Search function on map
  }
};

export { initMapbox };



// if (Object.keys(markers).length > 0) {
//   addMarkersToMap(map, markers);
//   fitMapToMarkers(map, markers);
// }
