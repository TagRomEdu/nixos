import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/settings" as Settings

Item {
    id: clockRoot
    width: 42
    height: 60

    property bool hovered: false
    signal showCalendar(int xPos, int yPos)
    signal hideCalendar()

    Text {
        id: clockText
        anchors.centerIn: parent
        font.family: "JetBrains Mono"
        font.pixelSize: 16
        font.bold: true
        color: hovered ? Qt.lighter(Settings.Colors.accentColor, 1.5) : Settings.Colors.accentColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: Qt.formatTime(new Date(), "HH\nmm")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatTime(new Date(), "HH\nmm")
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            hovered = true
            var globalPos = mapToItem(null, width, 0)
            showCalendar(globalPos.x, globalPos.y)
        }
        onExited: {
            hovered = false
            hideCalendar()
        }
        cursorShape: Qt.PointingHandCursor
    }
} 