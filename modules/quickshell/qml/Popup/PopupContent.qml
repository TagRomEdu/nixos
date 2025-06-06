import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import "./modules" as PopupModules

Item {
    required property var shell
    property string selectedWidget: "calendar"

    signal contentHeightChanged(int newHeight)

    // Tracks current height of the system view
    property int systemViewHeight: 280

    // Calculates the appropriate content height for each view
    property int calculatedContentHeight: {
        switch(selectedWidget) {
        case "calendar": return 200
        case "weather": return 200
        case "system": {
            var base = 200
            var tray = systemView.trayMenu?.visible ? (systemView.trayMenu.calculatedHeight + 40) : 0
            var total = base + tray
            if (tray > 300) total += 40
            else if (tray > 150) total += 20
            return total
        }
        default: return 280
        }
    }

    // Notify parent when content height changes
    onCalculatedContentHeightChanged: {
        var height = calculatedContentHeight + 100
        if (selectedWidget === "system") height += 40
        contentHeightChanged(height)
    }

    // Notify parent when view changes
    onSelectedWidgetChanged: {
        contentHeightChanged(calculatedContentHeight + 60)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            StackLayout {
                anchors.fill: parent

                // Select visible view
                currentIndex: {
                    switch(selectedWidget) {
                    case "calendar": return 0
                    case "weather": return 1
                    case "system": return 2
                    default: return 0
                    }
                }

                // Calendar
                PopupModules.CalendarView {
                    readonly property var shell: parent.shell
                }

                // Weather
                PopupModules.WeatherView {
                    readonly property var shell: parent.shell
                }

                // System monitor
                PopupModules.SystemView {
                    id: systemView
                    readonly property var shell: parent.shell

                    // Track height changes
                    onHeightChanged: systemViewHeight = height
                    onContentHeightChanged: systemViewHeight = contentHeight

                    // Set initial height
                    Component.onCompleted: {
                        systemViewHeight = contentHeight !== undefined ? contentHeight : height
                    }
                }
            }
        }

        // Bottom navigation
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: ["calendar", "weather", "system"]
                delegate: Button {
                    checkable: true
                    checked: selectedWidget === modelData
                    onClicked: selectedWidget = modelData

                    implicitWidth: 30
                    implicitHeight: 30

                    background: Rectangle {
                        radius: 20
                        color: parent.down ? Qt.darker(shell.accentColor, 1.2) :
                               parent.hovered ? Qt.lighter(shell.highlightBg, 1.1) : shell.highlightBg
                    }

                    contentItem: Label {
                        text: parent.checked ? "●" : "○"
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: parent.checked ? 14 : 18
                        color: parent.checked ? shell.accentColor : shell.fgColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
