import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/settings" as Settings

Rectangle {
    id: root
    property var shell: null
    color: Qt.darker(Settings.Colors.bgColor, 1.15)
    radius: 20

    property bool containsMouse: themeMouseArea.containsMouse
    property bool menuJustOpened: false

    signal entered()
    signal exited()

    onContainsMouseChanged: {
        if (containsMouse) {
            entered()
        } else if (!menuJustOpened) {
            exited()
        }
    }

    MouseArea {
        id: themeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            Settings.Colors.toggleTheme()
        }
    }

    Label {
        anchors.centerIn: parent
        text: "contrast"
        font.pixelSize: 24
        font.family: "Material Symbols Outlined"
        color: containsMouse ? Settings.Colors.accentColor : Settings.Colors.fgColor
    }
} 