import QtQuick
import Quickshell

import "root:/Bar" as Bar
import "root:/Core" as Core
import "root:/Widgets" as Widgets
import "root:/Data" as Data
import "root:/TopPanel" as TopPanel

// Main shell window container
PanelWindow {
    id: shellWindow

    property var shell
    property var modelData
    property var notificationService

    property alias notificationWindow: notificationWindow
    readonly property alias topPanelWindow: topPanelWindow

    implicitWidth: Screen.width
    implicitHeight: Screen.height
    color: "transparent"

    exclusiveZone: bar.width

    mask: Region {
        item: bar
    }

    anchors {
        top: true
        left: true
        bottom: true
    }

    Item {
        id: layout
        anchors.fill: parent

        // Screen border with rounded corners (bottom layer)
        Core.ScreenBorder {
            id: screenBorder
            anchors {
                left: bar.right
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            z: 0
        }

        // Main sidebar
        Bar.Bar {
            id: bar
            shell: shellWindow.shell
            implicitWidth: 42
            implicitHeight: layout.implicitHeight
            z: 1
        }

        // UI Layer for panels and overlays
        Item {
            id: uiLayer
            anchors.fill: parent
            z: 2

            // Top panel with slide-out functionality
            PanelWindow {
                id: topPanelWindow
                anchors.top: true

                margins.top: 0
                implicitWidth: slideBarVisible ? 670 : 360
                implicitHeight: slideBarVisible ? 600 : 1
                color: "transparent"
                exclusiveZone: 0

                property bool slideBarVisible: false

                TopPanel.TopPanel {
                    id: topPanelContent
                    shell: shellWindow.shell
                    anchors.fill: parent
                    onSlideBarVisibilityChanged: function(visible) {
                        topPanelWindow.slideBarVisible = visible
                    }
                }
            }

            // Notification overlay
            PanelWindow {
                id: notificationWindow
                anchors.top: true
                anchors.right: true
                margins.right: 0
                margins.top: 0
                implicitWidth: 420
                implicitHeight: notificationPopup.calculatedHeight
                color: "transparent"
                visible: false

                Widgets.Notification {
                    id: notificationPopup
                    anchors.fill: parent
                    shell: shellWindow.shell
                    notificationServer: shellWindow.notificationService.notificationServer
                }

                Connections {
                    target: notificationPopup
                    function onNotificationQueueChanged() {
                        if (notificationPopup.notificationQueue.length === 0) {
                            notificationWindow.visible = false
                        }
                    }
                }
            }

            // System overlays
            Widgets.VolumeOSD {
                shell: shellWindows.shell
            }

            Core.Version {}
        }
    }
}
