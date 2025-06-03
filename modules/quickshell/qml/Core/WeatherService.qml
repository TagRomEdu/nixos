import QtQuick

Item {
    id: service
    
    property var shell

    function mapWeatherCode(code) {
        switch(code) {
            case 0: return "Clear sky"
            case 1: return "Mainly clear"
            case 2: return "Partly cloudy"
            case 3: return "Overcast"
            case 45: return "Fog"
            case 48: return "Depositing rime fog"
            case 51: return "Light drizzle"
            case 53: return "Moderate drizzle"
            case 55: return "Dense drizzle"
            case 56: return "Light freezing drizzle"
            case 57: return "Dense freezing drizzle"
            case 61: return "Slight rain"
            case 63: return "Moderate rain"
            case 65: return "Heavy rain"
            case 66: return "Light freezing rain"
            case 67: return "Heavy freezing rain"
            case 71: return "Slight snow fall"
            case 73: return "Moderate snow fall"
            case 75: return "Heavy snow fall"
            case 77: return "Snow grains"
            case 80: return "Slight rain showers"
            case 81: return "Moderate rain showers"
            case 82: return "Violent rain showers"
            case 85: return "Slight snow showers"
            case 86: return "Heavy snow showers"
            case 95: return "Thunderstorm"
            case 96: return "Thunderstorm with slight hail"
            case 99: return "Thunderstorm with heavy hail"
            default: return "Unknown"
        }
    }

    function loadWeather() {
        shell.weatherLoading = true

        const geocodeXhr = new XMLHttpRequest()
        const geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(shell.weatherLocation)

        console.log("Starting geocoding for city:", shell.weatherLocation)

        geocodeXhr.onreadystatechange = function() {
            if (geocodeXhr.readyState === XMLHttpRequest.DONE) {
                if (geocodeXhr.status === 200) {
                    try {
                        const geoData = JSON.parse(geocodeXhr.responseText)
                        console.log("Geocode results:", geoData.length, "entries")
                        
                        if (geoData.length > 0) {
                            const latitude = parseFloat(geoData[0].lat)
                            const longitude = parseFloat(geoData[0].lon)
                            console.log("Using coordinates:", latitude, longitude)
                            fetchWeather(latitude, longitude)
                        } else {
                            console.error("Geocoding error: No results for city")
                            fallbackWeatherData("City not found")
                        }
                    } catch (e) {
                        console.error("Geocoding JSON parse error:", e)
                        fallbackWeatherData("Geocode parse error")
                    }
                } else {
                    console.error("Geocoding API error:", geocodeXhr.status, geocodeXhr.statusText)
                    fallbackWeatherData("Geocode service unavailable")
                }
            }
        }

        geocodeXhr.open("GET", geocodeUrl)
        geocodeXhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0")
        geocodeXhr.send()
    }

    function fetchWeather(latitude, longitude) {
        const xhr = new XMLHttpRequest()
        const url = "https://api.open-meteo.com/v1/forecast?" +
                  "latitude=" + latitude +
                  "&longitude=" + longitude +
                  "&current_weather=true" +
                  "&daily=temperature_2m_max,temperature_2m_min,weathercode" +
                  "&timezone=auto"

        console.log("Fetching weather for lat:", latitude, "lon:", longitude)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                shell.weatherLoading = false
                
                if (xhr.status === 200) {
                    try {
                        const data = JSON.parse(xhr.responseText)
                        const current = data.current_weather
                        const daily = data.daily

                        const currentTempFormatted = Math.round(parseFloat(current.temperature)) + "°C"

                        const forecast = []
                        for (let i = 0; i < 3; i++) {
                            const dayName = (i === 0) ? "Today" : 
                                          (i === 1) ? "Tomorrow" : 
                                          Qt.formatDate(new Date(new Date().setDate(new Date().getDate() + i)), "ddd MMM d")
                            
                            const condition = mapWeatherCode(daily.weathercode[i])
                            const minTemp = Math.round(parseFloat(daily.temperature_2m_min[i]))
                            const maxTemp = Math.round(parseFloat(daily.temperature_2m_max[i]))

                            forecast.push({
                                dayName: dayName,
                                condition: condition,
                                minTemp: minTemp,
                                maxTemp: maxTemp
                            })
                        }

                        shell.weatherData = {
                            location: shell.weatherLocation || "Current Location",
                            currentTemp: currentTempFormatted,
                            currentCondition: mapWeatherCode(current.weathercode),
                            details: [
                                "Wind: " + current.windspeed + " km/h",
                                "Direction: " + current.winddirection + "°"
                            ],
                            forecast: forecast
                        }
                    } catch (e) {
                        console.error("Weather JSON parse error:", e)
                        fallbackWeatherData("Weather data error")
                    }
                } else {
                    console.error("Weather API error:", xhr.status, xhr.statusText)
                    fallbackWeatherData("Weather service unavailable")
                }
            }
        }

        xhr.open("GET", url)
        xhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0")
        xhr.send()
    }

    function fallbackWeatherData(message) {
        shell.weatherLoading = false
        shell.weatherData = {
            location: message,
            currentTemp: "?",
            currentCondition: "?",
            details: [],
            forecast: [
                {dayName: "Today", condition: "?", minTemp: "?", maxTemp: "?"},
                {dayName: "Tomorrow", condition: "?", minTemp: "?", maxTemp: "?"},
                {dayName: "?", condition: "?", minTemp: "?", maxTemp: "?"}
            ]
        }
    }
}