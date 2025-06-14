import QtQuick

Item {
    id: service
    
    property var shell
    
    // Request management
    property int activeRequests: 0
    property int maxConcurrentRequests: 2
    
    // Weather data caching
    property var cachedWeatherData: null
    property var lastFetchTime: 0
    property int cacheTimeoutMs: 600000
    
    Timer {
        id: requestCleanupTimer
        interval: 30000
        repeat: true
        running: activeRequests > 0
        onTriggered: {
            if (activeRequests > 0) {
                activeRequests = 0
                shell.weatherLoading = false
            }
        }
    }
    
    // XHR object pool for request reuse
    property var xhrPool: []
    property int maxPoolSize: 3
    
    function getXHR() {
        if (xhrPool.length > 0) {
            return xhrPool.pop()
        }
        return new XMLHttpRequest()
    }
    
    function releaseXHR(xhr) {
        xhr.abort()
        if (xhrPool.length < maxPoolSize) {
            xhr.onreadystatechange = null
            xhr.ontimeout = null
            xhr.onerror = null
            xhrPool.push(xhr)
        }
    }

    function mapWeatherCode(code) {
        const weatherCodes = {
            0: "Clear sky",
            1: "Mainly clear", 
            2: "Partly cloudy",
            3: "Overcast",
            45: "Fog", 
            48: "Depositing rime fog",
            51: "Light drizzle",
            53: "Moderate drizzle",
            55: "Dense drizzle",
            56: "Light freezing drizzle",
            57: "Dense freezing drizzle",
            61: "Slight rain",
            63: "Moderate rain",
            65: "Heavy rain",
            66: "Light freezing rain",
            67: "Heavy freezing rain",
            71: "Slight snow fall",
            73: "Moderate snow fall",
            75: "Heavy snow fall",
            77: "Snow grains",
            80: "Slight rain showers",
            81: "Moderate rain showers",
            82: "Violent rain showers",
            85: "Slight snow showers",
            86: "Heavy snow showers",
            95: "Thunderstorm",
            96: "Thunderstorm with slight hail",
            99: "Thunderstorm with heavy hail"
        }
        return weatherCodes[code] || "Unknown"
    }

    function loadWeather() {
        const now = Date.now()

        if (cachedWeatherData && (now - lastFetchTime) < cacheTimeoutMs) {
            shell.weatherData = cachedWeatherData
            shell.weatherLoading = false
            return
        }
        
        if (activeRequests >= maxConcurrentRequests) {
            return
        }
        
        shell.weatherLoading = true
        activeRequests++

        // Get location coordinates
        const geocodeXhr = getXHR()
        const geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&limit=1&q=" + encodeURIComponent(shell.weatherLocation)

        geocodeXhr.timeout = 10000

        geocodeXhr.onreadystatechange = function() {
            if (geocodeXhr.readyState === XMLHttpRequest.DONE) {
                activeRequests--
                if (geocodeXhr.status === 200) {
                    try {
                        const geoData = JSON.parse(geocodeXhr.responseText)
                        if (geoData.length > 0) {
                            const latitude = parseFloat(geoData[0].lat)
                            const longitude = parseFloat(geoData[0].lon)
                            fetchWeather(latitude, longitude)
                        } else {
                            fallbackWeatherData("City not found")
                        }
                    } catch (e) {
                        fallbackWeatherData("Geocode parse error")
                    }
                } else {
                    fallbackWeatherData("Geocode service unavailable")
                }
                releaseXHR(geocodeXhr)
            }
        }

        geocodeXhr.ontimeout = function() {
            activeRequests--
            fallbackWeatherData("Request timeout")
            releaseXHR(geocodeXhr)
        }

        geocodeXhr.onerror = function() {
            activeRequests--
            fallbackWeatherData("Network error")
            releaseXHR(geocodeXhr)
        }

        geocodeXhr.open("GET", geocodeUrl)
        geocodeXhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0")
        geocodeXhr.send()
    }

    function fetchWeather(latitude, longitude) {
        if (activeRequests >= maxConcurrentRequests) {
            fallbackWeatherData("Too many requests")
            return
        }
        
        activeRequests++
        
        const xhr = getXHR()
        const url = "https://api.open-meteo.com/v1/forecast?" +
                  "latitude=" + latitude +
                  "&longitude=" + longitude +
                  "&current_weather=true" +
                  "&daily=temperature_2m_max,temperature_2m_min,weathercode" +
                  "&forecast_days=3" +
                  "&timezone=auto"

        xhr.timeout = 15000

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                activeRequests--
                shell.weatherLoading = false
                
                if (xhr.status === 200) {
                    try {
                        const data = JSON.parse(xhr.responseText)
                        processWeatherData(data)
                    } catch (e) {
                        fallbackWeatherData("Weather data error")
                    }
                } else {
                    fallbackWeatherData("Weather service unavailable")
                }
                releaseXHR(xhr)
            }
        }

        xhr.ontimeout = function() {
            activeRequests--
            shell.weatherLoading = false
            fallbackWeatherData("Request timeout")
            releaseXHR(xhr)
        }

        xhr.onerror = function() {
            activeRequests--
            shell.weatherLoading = false
            fallbackWeatherData("Network error")
            releaseXHR(xhr)
        }

        xhr.open("GET", url)
        xhr.setRequestHeader("User-Agent", "StatusBar_Ly-sec/1.0")
        xhr.send()
    }

    function processWeatherData(data) {
        const current = data.current_weather
        const daily = data.daily
        const currentTempFormatted = Math.round(parseFloat(current.temperature)) + "°C"

        // Format 3-day forecast
        const forecast = new Array(3)
        const today = new Date()
        
        for (let i = 0; i < 3; i++) {
            let dayName
            if (i === 0) {
                dayName = "Today"
            } else if (i === 1) {
                dayName = "Tomorrow"  
            } else {
                const futureDate = new Date(today)
                futureDate.setDate(today.getDate() + i)
                dayName = Qt.formatDate(futureDate, "ddd MMM d")
            }
            
            const weatherCode = daily.weathercode[i]
            const condition = mapWeatherCode(weatherCode)

            
            forecast[i] = {
                dayName: dayName,
                condition: condition,
                minTemp: Math.round(parseFloat(daily.temperature_2m_min[i])),
                maxTemp: Math.round(parseFloat(daily.temperature_2m_max[i]))
            }
        }

        const weatherData = {
            location: shell.weatherLocation || "Current Location",
            currentTemp: currentTempFormatted,
            currentCondition: mapWeatherCode(current.weathercode),
            details: [
                "Wind: " + current.windspeed + " km/h",
                "Direction: " + current.winddirection + "°"
            ],
            forecast: forecast
        }
        
        // Cache and update shell property
        cachedWeatherData = weatherData
        lastFetchTime = Date.now()
        shell.weatherData = weatherData
    }

    // Provide fallback weather data in case of errors
    function fallbackWeatherData(message) {
        shell.weatherLoading = false
        
        const fallbackData = {
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
        
        shell.weatherData = fallbackData
    }
    
    // Clear cache and pool on component destruction
    Component.onDestruction: {
        cachedWeatherData = null
        xhrPool.forEach(xhr => xhr.abort())
        xhrPool = []
    }
}
