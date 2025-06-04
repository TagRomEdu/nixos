import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:/Data" as Data

Rectangle {
    
    
    color: Qt.lighter(Data.Colors.bgColor, 1.2)
    radius: 20

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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // Location header
        Label {
            text: weatherLoading ? "Loading weather..." : "Weather"
            color: Data.Colors.accentColor
            font {
                pixelSize: 18
                bold: true
                family: "FiraCode Nerd Font"
            }
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        // Current weather
        ColumnLayout {
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                spacing: 16
                Layout.alignment: Qt.AlignHCenter

                Label {
                    text: weatherLoading ? "⏳" : getWeatherEmoji((weatherData && weatherData.currentCondition) || "?")
                    font.pixelSize: 48
                    color: Data.Colors.fgColor
                }

                Label {
                    text: weatherLoading ? "..." : ((weatherData && weatherData.currentTemp) || "?")
                    font {
                        pixelSize: 24
                        bold: true
                        family: "FiraCode Nerd Font"
                    }
                    color: Data.Colors.fgColor
                }
            }

            // Current weather details
            GridLayout {
                columns: 2
                columnSpacing: 16
                rowSpacing: 8
                Layout.alignment: Qt.AlignHCenter

                Repeater {
                    model: weatherLoading ? [] : (weatherData && weatherData.details ? weatherData.details : [])
                    delegate: RowLayout {
                        spacing: 8
                        Label {
                            text: modelData ? modelData.split(":")[0] + ":" : ""
                            color: Qt.lighter(Data.Colors.fgColor, 1.2)
                            font {
                                pixelSize: 12
                                bold: true
                            }
                        }
                        Label {
                            text: modelData ? modelData.split(":")[1] : ""
                            color: Data.Colors.fgColor
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }

        // 3-Day Forecast
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
     
            Label {
                text: "3-Day Forecast"
                color: Data.Colors.accentColor
                font {
                    pixelSize: 14
                    bold: true
                    family: "FiraCode Nerd Font"
                }
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
     
            // Forecast days
            GridLayout {
                columns: 3
                columnSpacing: 70
                Layout.alignment: Qt.AlignHCenter
     
                Repeater {
                    model: weatherLoading ? [] : (weatherData && weatherData.forecast ? weatherData.forecast.slice(0, 3) : [])
                    delegate: ColumnLayout {
                        spacing: 4
                        Layout.alignment: Qt.AlignHCenter
     
                        // Day name
                        Label {
                            text: modelData?.dayName || "?"
                            color: Data.Colors.fgColor
                            font.pixelSize: 12
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
     
                        // Weather emoji - now use the local function
                        Label {
                            text: weatherLoading ? "?" : getWeatherEmoji(modelData?.condition || "?")
                            font.pixelSize: 32
                            color: Data.Colors.fgColor
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
     
                        // Temperature
                        Label {
                            text: {
                                if (weatherLoading) return "-"
                                if (!modelData) return "?"
                                if (modelData.temp) return modelData.temp + "°C"
                                if (modelData.minTemp && modelData.maxTemp)
                                    return modelData.minTemp + "°C / " + modelData.maxTemp + "°C"
                                return "?"
                            }
                            font.pixelSize: 12
                            color: Data.Colors.fgColor
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}