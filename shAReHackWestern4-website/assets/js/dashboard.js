"use strict";

/**
 * Callback upon retriving login status
 * @param {Object} response
 */
function statusChangeCallback(response){
    if (response.status === "connected") {
        connectToCognito(response.authResponse.accessToken)
        var documentClient = new AWS.DynamoDB.DocumentClient();
        retrieveDBData(documentClient);
    }
}

function retrieveDBData(documentClient) {
    var params = {
        TableName : 'share-fakedata',
    };
    documentClient.scan(params, function(err, data) {
        if (err) {
            console.log(err);
        } else {
            updateMarkers(data);
        }
    });
}

function logoutFB(){
  FB.logout(function(response) {
    // User Logged Out
  });
  location.replace("index.html");
}

var map;
function initMap() {
    map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 0, lng:0},
        zoom: 17,
        styles: [
            {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
            {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
            {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
            {
              featureType: 'administrative.locality',
              elementType: 'labels.text.fill',
              stylers: [{color: '#d59563'}]
            },
            {
              featureType: 'poi',
              elementType: 'labels',
              stylers: [{visibility: 'off'}]
            },
            {
              featureType: 'road',
              elementType: 'geometry',
              stylers: [{color: '#38414e'}]
            },
            {
              featureType: 'road',
              elementType: 'geometry.stroke',
              stylers: [{color: '#212a37'}]
            },
            {
              featureType: 'road',
              elementType: 'labels.text.fill',
              stylers: [{color: '#9ca5b3'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'geometry',
              stylers: [{color: '#746855'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'geometry.stroke',
              stylers: [{color: '#1f2835'}]
            },
            {
              featureType: 'road.highway',
              elementType: 'labels.text.fill',
              stylers: [{color: '#f3d19c'}]
            },
            {
              featureType: 'transit',
              elementType: 'geometry',
              stylers: [{color: '#2f3948'}]
            },
            {
              featureType: 'transit.station',
              elementType: 'labels.text.fill',
              stylers: [{color: '#d59563'}]
            },
            {
              featureType: 'water',
              elementType: 'geometry',
              stylers: [{color: '#17263c'}]
            },
            {
              featureType: 'water',
              elementType: 'labels.text.fill',
              stylers: [{color: '#515c6d'}]
            },
            {
              featureType: 'water',
              elementType: 'labels.text.stroke',
              stylers: [{color: '#17263c'}]
            }
          ]
    });

    // Try HTML5 geolocation.
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
            map.setCenter(pos);
        }, function() {
            handleLocationError(true, map.getCenter());
        });
    } else {
        // Browser doesn't support Geolocation
        handleLocationError(false, map.getCenter());
    }

    function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        alert("Browser doesn't support geolocation")
    }
}


function updateMarkers(data) {
    var markers = data.Items.map(function(d) {
        var label = new google.maps.InfoWindow({
            content: "<p style='color:Black'>" + d.comment + "</p>"
        });
        var marker = new google.maps.Marker({
            position: {lat: parseFloat(d.latitude), lng: parseFloat(d.longitude)},
        })
        marker.addListener('click', function() {
            label.open(map, marker);
          });
        return marker;
    })

    var markerCluster = new MarkerClusterer(map, markers,
        {imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m'});
}
