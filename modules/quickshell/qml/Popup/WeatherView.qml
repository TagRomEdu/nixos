import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../Data" as Data

Rectangle {
    required property var shell
    
    color: Qt.lighter(Data.Colors.bgColor, 1.2)
    radius: 20

    // Defensive: fallback colors if shell is undefined
    Component.onCompleted: {
        if (!shell) {
            console.warn("WeatherView: shell property is undefined!");
        }
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
                    text: weatherLoading ? "⏳" : getWeatherEmoji(weatherData.currentCondition || "?")
                    font.pixelSize: 48
                    color: Data.Colors.fgColor
                }

                Label {
                    text: weatherLoading ? "..." : (weatherData.currentTemp || "?")
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
                    model: weatherLoading ? [] : weatherData.details
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
        model: weatherLoading ? [] : weatherData.forecast.slice(0, 3)
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
 
            // Weather emoji
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