import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "root:/settings" as Settings

Rectangle {
    id: root
    width: 42
    color: Qt.darker(Settings.Colors.bgColor, 1.15)
    radius: 12
    z: 2  // Keep it above notification history

    required property bool notificationHistoryVisible
    required property bool clipboardHistoryVisible
    required property var notificationHistory
    signal notificationToggleRequested()
    signal clipboardToggleRequested()

    // Add containsMouse property for panel hover tracking
    property bool containsMouse: notifButtonMouseArea.containsMouse || clipButtonMouseArea.containsMouse

    // Ensure minimum height for buttons even when recording
    property real buttonHeight: 38
    height: buttonHeight * 2 + 4  // 4px spacing between buttons

    Item {
        anchors.fill: parent
        anchors.margins: 2

        // Top pill (Notifications)
        Rectangle {
            id: notificationPill
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.verticalCenter
                bottomMargin: 2  // Half of the spacing
            }
            radius: 12
            color: notifButtonMouseArea.containsMouse || root.notificationHistoryVisible ? 
                   Qt.rgba(Settings.Colors.accentColor.r, Settings.Colors.accentColor.g, Settings.Colors.accentColor.b, 0.2) : 
                   Qt.rgba(Settings.Colors.fgColor.r, Settings.Colors.fgColor.g, Settings.Colors.fgColor.b, 0.05)
            border.color: notifButtonMouseArea.containsMouse || root.notificationHistoryVisible ? Settings.Colors.accentColor : "transparent"
            border.width: 1

            MouseArea {
                id: notifButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.notificationToggleRequested()
            }

            Label {
                anchors.centerIn: parent
                text: "notifications"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16
                color: notifButtonMouseArea.containsMouse || root.notificationHistoryVisible ? 
                       Settings.Colors.accentColor : Settings.Colors.fgColor
            }
        }

        // Bottom pill (Clipboard)
        Rectangle {
            id: clipboardPill
            anchors {
                top: parent.verticalCenter
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 2  // Half of the spacing
            }
            radius: 12
            color: clipButtonMouseArea.containsMouse || root.clipboardHistoryVisible ? 
                   Qt.rgba(Settings.Colors.accentColor.r, Settings.Colors.accentColor.g, Settings.Colors.accentColor.b, 0.2) : 
                   Qt.rgba(Settings.Colors.fgColor.r, Settings.Colors.fgColor.g, Settings.Colors.fgColor.b, 0.05)
            border.color: clipButtonMouseArea.containsMouse || root.clipboardHistoryVisible ? Settings.Colors.accentColor : "transparent"
            border.width: 1

            MouseArea {
                id: clipButtonMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.clipboardToggleRequested()
            }

            Label {
                anchors.centerIn: parent
                text: "content_paste"
                font.family: "Material Symbols Outlined"
                font.pixelSize: 16
                color: clipButtonMouseArea.containsMouse || root.clipboardHistoryVisible ? 
                       Settings.Colors.accentColor : Settings.Colors.fgColor
            }
        }
    }
} 