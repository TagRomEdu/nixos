import QtQuick
import Quickshell
import "root:/Bar" as Bar
import "root:/HotCorner" as HotCorner
import "root:/Popup" as Popup
import "root:/Core" as Core

Item {
    id: shellWindows

    property var shell
    property var notificationService

    // Expose windows for external access
    readonly property alias hotCornerWindow: hotCornerWindow
    readonly property alias mainWindow: mainWindow
    readonly property alias notificationWindow: notificationWindow
    readonly property alias popupWindow: popupWindow
    readonly property alias cliphistWindow: cliphistWindow

    // Hot corner panel on top-right
    PanelWindow {
        id: hotCornerWindow
        anchors.top: true
        anchors.right: true
        margins.top: -36
        implicitWidth: slideBarVisible ? 264 : 48
        implicitHeight: slideBarVisible ? 252 : 48
        color: "transparent"
        exclusiveZone: 0

        property bool slideBarVisible: false

        Item {
            anchors.fill: parent
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                propagateComposedEvents: true
                // Let events propagate, do not grab mouse
                onPressed: mouse.accepted = false
                onPositionChanged: mouse.accepted = false
                onReleased: mouse.accepted = false
            }
        }

        HotCorner.HotCornerBar {
            id: hotCornerContent
            shell: shellWindows.shell
            anchors.fill: parent
            onSlideBarVisibilityChanged: function(visible) {
                hotCornerWindow.slideBarVisible = visible
            }
        }
    }

    // Main status bar at top-center
    PanelWindow {
        id: mainWindow
        implicitWidth: 390
        implicitHeight: 100
        anchors.top: true
        color: "transparent"
        exclusiveZone: 36

        Bar.Bar {
            id: bar
            shell: shellWindows.shell
            popup: popupWindow
            bar: mainWindow
            anchors.horizontalCenter: parent.horizontalCenter
            implicitWidth: 260
        }
    }

    // Notification popup at top-right
    PanelWindow {
        id: notificationWindow
        anchors.top: true
        anchors.right: true
        margins.right: 12
        margins.top: 14
        implicitWidth: 420
        implicitHeight: notificationPopup.calculatedHeight
        color: "transparent"
        visible: false

        Popup.NotificationPopup {
            id: notificationPopup
            anchors.fill: parent
            shell: shellWindows.shell
            notificationServer: shellWindows.notificationService.notificationServer
        }

        Connections {
            target: notificationPopup
            // Hide window when notification queue is empty
            function onNotificationQueueChanged() {
                if (notificationPopup.notificationQueue.length === 0) {
                    notificationWindow.visible = false
                }
            }
        }
    }

    // Main popup window (centered below main bar)
    PopupWindow {
        id: popupWindow
        anchor.window: mainWindow
        anchor.rect.x: mainWindow.implicitWidth / 2 - implicitWidth / 2
        anchor.rect.y: mainWindow.exclusiveZone + 12  // offset below bar
        implicitWidth: 500
        implicitHeight: dynamicHeight
        visible: false
        color: "transparent"

        property int dynamicHeight: 340
        property int minHeight: 340
        property int maxHeight: 600

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            anchors.fill: parent
            border.color: shellWindows.shell.accentColor
            border.width: 3
            color: shellWindows.shell.bgColor
            radius: 20

            Popup.PopupContent {
                id: popupContent
                shell: shellWindows.shell
                anchors.fill: parent
                anchors.margins: 12
                // Adjust height dynamically, clamped to min/max
                onContentHeightChanged: function(newHeight) {
                    let clampedHeight = Math.max(popupWindow.minHeight, Math.min(popupWindow.maxHeight, newHeight))
                    popupWindow.dynamicHeight = clampedHeight + 30
                }
            }
        }
    }

    // Clipboard history popup (centered below main bar)
    PopupWindow {
        id: cliphistWindow
        anchor.window: mainWindow
        anchor.rect.x: mainWindow.implicitWidth / 2 - implicitWidth / 2
        anchor.rect.y: mainWindow.exclusiveZone + 12
        implicitWidth: 500
        implicitHeight: 320
        visible: false
        color: "transparent"

        function toggle() {
            if (visible) hide()
            else show()
        }

        Rectangle {
            anchors.fill: parent
            border.color: shellWindows.shell.accentColor
            border.width: 3
            color: shellWindows.shell.bgColor
            radius: 20

            Popup.Cliphist {
                shell: shellWindows.shell
                anchors.fill: parent
                anchors.margins: 12
            }
        }
    }

    // Fullscreen screen border
    Core.ScreenBorder {
        id: screenborderWindow
        visible: true
        implicitWidth: Screen.width
        implicitHeight: Screen.height
        anchors.top: true
        margins.top: -36
        exclusiveZone: 0
    }

    // Volume OSD shown on volume changes
    Core.VolumeOSD {
        shell: shellWindows.shell
    }

    // Workspace OSD shown on workspace changes
    Core.WorkspaceOSD {
        shell: shellWindows.shell
    }
}
