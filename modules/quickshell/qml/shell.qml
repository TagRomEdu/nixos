//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import "Data" as Dat

ShellRoot {
    id: root
    property alias popupWindow: popupWindow
    property alias notificationWindow: notificationWindow
    property alias bar: mainWindow

    
    // Global color scheme
    readonly property color bgColor: Dat.Colors.bgColor
    readonly property color fgColor: Dat.Colors.fgColor
    readonly property color accentColor: Dat.Colors.accentColor
    readonly property color highlightBg: Dat.Colors.highlightBg

    // Time and date
    property string time: Qt.formatDateTime(new Date(), "hh:mm AP")
    property string date: Qt.formatDateTime(new Date(), "ddd MMM d")

    // Workspaces model from Hyprland
    property var workspaces: Hyprland.workspaces || []
    property var focusedWorkspace: Hyprland.focusedWorkspace

    // System tray items
    property var trayItems: SystemTray.items.values || []

    // Weather configuration
    property string weatherLocation: Dat.Settings.weatherLocation
    property var weatherData: Dat.Settings.weatherData
    property bool weatherLoading: false

    // Audio properties
    property var defaultAudioSink: Dat.Settings.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio ? Math.round(defaultAudioSink.audio.volume * 100) : 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Notification server
    NotificationServer {
    id: notificationServer
    actionsSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    keepOnReload: false
    persistenceSupported: true

    Component.onCompleted: {
        console.log("Notification server initialized")
    }

    onNotification: (notification) => {
        console.log("[RAW NOTIFICATION] App:", notification.appName, 
                "Summary:", notification.summary,
                "Body:", notification.body)
        
        // Pass the full notification to the window
        notificationWindow.showNotification(notification)
    }
}

    NotificationPopup {
        id: notificationContainer
        shell: root
        notificationServer: notificationServer
    }

    Component.onCompleted: {
        if (Hyprland.refreshWorkspaces) Hyprland.refreshWorkspaces()
        loadWeather()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            time = Qt.formatDateTime(new Date(), "hh:mm AP")
            date = Qt.formatDateTime(new Date(), "ddd MMM d")
            if (Hyprland.refreshWorkspaces) Hyprland.refreshWorkspaces()
            trayItems = SystemTray.items
        }
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: loadWeather()
    }

    function getWeatherEmoji(condition) {
        if (!condition) return "❓"
        condition = condition.toLowerCase()

        if (condition.includes("clear")) return "☀️"
        if (condition.includes("mainly clear")) return "🌤️"
        if (condition.includes("partly cloudy")) return "⛅"
        if (condition.includes("cloud") || condition.includes("overcast")) return "☁️"

        if (condition.includes("fog") || condition.includes("mist")) return "🌫️"

        if (condition.includes("drizzle")) return "🌦️"
        if (condition.includes("rain") || condition.includes("showers")) return "🌧️"
        if (condition.includes("freezing rain")) return "🌧️❄️"

        if (condition.includes("snow") || condition.includes("snow grains") || condition.includes("snow showers")) return "❄️"

        if (condition.includes("thunderstorm")) return "⛈️"

        if (condition.includes("wind")) return "🌬️"

        return "❓"
    }

    function mapWeatherCode(code) {
        switch(code) {
            case 0: return "Clear sky";
            case 1: return "Mainly clear";
            case 2: return "Partly cloudy";
            case 3: return "Overcast";
            case 45: return "Fog";
            case 48: return "Depositing rime fog";
            case 51: return "Light drizzle";
            case 53: return "Moderate drizzle";
            case 55: return "Dense drizzle";
            case 56: return "Light freezing drizzle";
            case 57: return "Dense freezing drizzle";
            case 61: return "Slight rain";
            case 63: return "Moderate rain";
            case 65: return "Heavy rain";
            case 66: return "Light freezing rain";
            case 67: return "Heavy freezing rain";
            case 71: return "Slight snow fall";
            case 73: return "Moderate snow fall";
            case 75: return "Heavy snow fall";
            case 77: return "Snow grains";
            case 80: return "Slight rain showers";
            case 81: return "Moderate rain showers";
            case 82: return "Violent rain showers";
            case 85: return "Slight snow showers";
            case 86: return "Heavy snow showers";
            case 95: return "Thunderstorm";
            case 96: return "Thunderstorm with slight hail";
            case 99: return "Thunderstorm with heavy hail";
            default: return "Unknown";
        }
    }

    function loadWeather() {
        weatherLoading = true;

        var geocodeXhr = new XMLHttpRequest();
        var geocodeUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(weatherLocation);

        console.log("Starting geocoding for city:", weatherLocation);

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

    function fallbackWeatherData(message) {
        weatherData = {
            location: message,
            currentTemp: "?",
            currentCondition: "?",
            details: [],
            forecast: [
                {dayName: "Today", condition: "?", temp: "?", minTemp: "?", maxTemp: "?"},
                {dayName: "Tomorrow", condition: "?", temp: "?", minTemp: "?", maxTemp: "?"},
                {dayName: "?", condition: "?", temp: "?", minTemp: "?", maxTemp: "?"}
            ]
        };
    }

    PanelWindow {
        id: mainWindow
        implicitWidth: 520
        implicitHeight: 42
        anchors.top: true
        color: "transparent"
        exclusiveZone: 36

        Bar {
            shell: root
            popup: popupWindow
            anchors.fill: parent
            bar: this
        }
    }

    PopupWindow {
        id: notificationWindow
        anchor.window: mainWindow
        anchor.rect.x: screen.availableGeometry.maximumWidth
        anchor.rect.y: screen.availableGeometry.maximumHeight - 200
        implicitWidth: 400
        implicitHeight: 400
        color: "transparent"

         property var currentNotification: null

    function showNotification(notification) {
        currentNotification = notification
        visible = true
        notificationTestTimer.restart()
        updatePosition()
    }

    function updatePosition() {
        if (Quickshell.screens.length > 0) {
            var screen = Quickshell.screens[0]
            x = screen.virtualX + screen.width - width - 20
            y = screen.virtualY + 20
        }
    }

    NotificationPopup {
        id: notificationContent
        anchors.fill: parent
        shell: root
        notification: notificationWindow.currentNotification
    }

    Timer {
        id: notificationTestTimer
        interval: 5000
        onTriggered: notificationWindow.visible = false
    }

    onVisibleChanged: if (visible) updatePosition()
}

    PopupWindow {
        id: popupWindow
        anchor.window: mainWindow
        anchor.rect.x: mainWindow.implicitWidth / 2 - implicitWidth / 2
        anchor.rect.y: mainWindow.implicitHeight - 3
        implicitWidth: 520
        implicitHeight: 320
        visible: false
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            color: root.bgColor
            bottomLeftRadius: 20
            bottomRightRadius: 20
            border.width: 1
            border.color: Qt.darker(root.bgColor, 1.5)

            PopupContent {
                shell: root
                anchors.fill: parent
                anchors.margins: 12
            }
        }
    }
}