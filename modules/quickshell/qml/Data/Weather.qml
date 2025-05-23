pragma Singleton
import QtQuick
import Quickshell
import "Data" as Dat

Singleton {
    id: root
    property string weatherLocation: Dat.Settings.weatherLocation
    property var weatherData: Dat.Settings.weatherData
    property bool weatherLoading: false
function loadWeather() {
    weatherLoading = true;

    var geocodeXhr = new XMLHttpRequest();
    var geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(weatherLocation);

    console.log("Starting geocoding for city:", weatherLocation);  // Log city name

    geocodeXhr.onreadystatechange = function() {
        if (geocodeXhr.readyState === XMLHttpRequest.DONE) {
            if (geocodeXhr.status === 200) {
                try {
                    var geoData = JSON.parse(geocodeXhr.responseText);
                    console.log("Geocode results:", geoData.length, "entries");
                    if (geoData.length > 0) {
                        var latitude = parseFloat(geoData[0].lat);
                        var longitude = parseFloat(geoData[0].lon);

                        console.log("Using coordinates:", latitude, longitude);

                        fetchWeather(latitude, longitude);
                    } else {
                        console.error("Geocoding error: No results for city");
                        fallbackWeatherData("City not found");
                        weatherLoading = false;
                    }
                } catch (e) {
                    console.error("Geocoding JSON parse error:", e);
                    fallbackWeatherData("Geocode parse error");
                    weatherLoading = false;
                }
            } else {
                console.error("Geocoding API error:", geocodeXhr.status, geocodeXhr.statusText);
                fallbackWeatherData("Geocode service unavailable");
                weatherLoading = false;
            }
        }
    };

    geocodeXhr.open("GET", geocodeUrl);
    geocodeXhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0");
    geocodeXhr.send();
}

function fetchWeather(latitude, longitude) {
    var xhr = new XMLHttpRequest();

    var url = "https://api.open-meteo.com/v1/forecast?" +
              "latitude=" + latitude +
              "&longitude=" + longitude +
              "&current_weather=true" +
              "&daily=temperature_2m_max,temperature_2m_min,weathercode" +
              "&timezone=auto";

    console.log("Fetching weather for lat:", latitude, "lon:", longitude);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            weatherLoading = false;
            if (xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);

                    var current = data.current_weather;
                    var daily = data.daily;

                    var currentTempFloat = parseFloat(current.temperature);
                    var currentTempFormatted = Math.round(currentTempFloat) + "°C";

                    var forecast = [];
                    for (var i = 0; i < 3; i++) {
                        var dayName = (i === 0) ? "Today" : (i === 1) ? "Tomorrow" : Qt.formatDate(new Date(new Date().setDate(new Date().getDate() + i)), "ddd MMM d");
                        var condition = mapWeatherCode(daily.weathercode[i]);
                        var emoji = getWeatherEmoji(condition);

                        var minTemp = Math.round(parseFloat(daily.temperature_2m_min[i]));
                        var maxTemp = Math.round(parseFloat(daily.temperature_2m_max[i]));


                        forecast.push({
                            dayName: dayName,
                            condition: condition,
                            emoji: emoji,
                            minTemp: minTemp,
                            maxTemp: maxTemp
                        });
                    }

                    console.log("Weather data loaded for location:", weatherLocation);
                    console.log("Current temperature:", currentTempFormatted);
                    console.log("Current condition:", mapWeatherCode(current.weathercode));

                    weatherData = {
                        location: weatherLocation || "Current Location",
                        currentTemp: currentTempFormatted,
                        currentCondition: mapWeatherCode(current.weathercode),
                        currentEmoji: getWeatherEmoji(mapWeatherCode(current.weathercode)),
                        details: [
                            "Wind: " + current.windspeed + " km/h",
                            "Direction: " + current.winddirection + "°"
                        ],
                        forecast: forecast
                    };
                } catch (e) {
                    console.error("Weather JSON parse error:", e);
                    fallbackWeatherData("Weather data error");
                }
            } else {
                console.error("Weather API error:", xhr.status, xhr.statusText);
                fallbackWeatherData("Weather service unavailable");
            }
        }
    };

    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0");
    xhr.send();
}
}