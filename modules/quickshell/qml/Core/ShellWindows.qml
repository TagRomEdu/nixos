import QtQuick
import Quickshell
import "root:/Bar" as Bar
import "root:/HotCorner" as HotCorner
import "root:/Popup" as Popup

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
    
    // Hot corner window - only covers the trigger area when SlideBar is hidden
    PanelWindow {
        id: hotCornerWindow
        anchors {
            top: true
            right: true
        }
        margins.top: -36
        implicitWidth: slideBarVisible ? 260 : 48
        implicitHeight: slideBarVisible ? 248 : 48
        color: "transparent"
        exclusiveZone: 0
        
        // Track SlideBar visibility
        property bool slideBarVisible: false
        
        // This makes the window ignore all mouse events
        Item {
            anchors.fill: parent
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                propagateComposedEvents: true
                onPressed: mouse.accepted = false
                onPositionChanged: mouse.accepted = false
                onReleased: mouse.accepted = false
            }
        }
        
        HotCorner.HotCornerBar {
            id: hotCornerContent
            shell: shellWindows.shell
            anchors.fill: parent
            
            // Connect SlideBar visibility changes
            onSlideBarVisibilityChanged: function(visible) {
                hotCornerWindow.slideBarVisible = visible
            }
        }
    }
    
    // Main status bar
    PanelWindow {
        id: mainWindow
        implicitWidth: 640
        implicitHeight: 42
        anchors.top: true
        color: "transparent"
        exclusiveZone: 36
        Bar.Bar {
            shell: shellWindows.shell
            popup: popupWindow
            bar: mainWindow
            anchors.horizontalCenter: parent.horizontalCenter
            width: 520
        }
    }
    
    // Notification window
    PanelWindow {
        id: notificationWindow
        anchors {
            top: true
            right: true
        }
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
            function onNotificationQueueChanged() {
                if (notificationPopup.notificationQueue.length === 0) {
                    notificationWindow.visible = false
                }
            }
        }
    }
    
    // Main popup window
    PopupWindow {
        id: popupWindow
        anchor {
            window: mainWindow
            rect.x: mainWindow.implicitWidth / 2 - implicitWidth / 2
            rect.y: mainWindow.implicitHeight + 8
        }
        implicitWidth: 500
        implicitHeight: 320
        visible: false
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            border.color: shellWindows.shell.accentColor
            border.width: 3
            color: shellWindows.shell.bgColor
            radius: 20
            Popup.PopupContent {
                shell: shellWindows.shell
                anchors.fill: parent
                anchors.margins: 12
            }
        }
    }
    
    // Clipboard history window
    PopupWindow {
        id: cliphistWindow
        anchor {
            window: mainWindow
            rect.x: mainWindow.implicitWidth / 2 - implicitWidth / 2
            rect.y: mainWindow.implicitHeight + 8
        }
        implicitWidth: 500
        implicitHeight: 320
        visible: false
        color: "transparent"
        function toggle() {
            if (visible) {
                hide()
            } else {
                show()
            }
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
}