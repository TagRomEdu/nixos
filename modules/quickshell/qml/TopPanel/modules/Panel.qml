import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Services.SystemTray
import "root:/Data" as Data
import "root:/Widgets" as Widgets
import "root:/Bar" as Bar

Item {
    id: root
    required property var shell
    required property bool isRecording
    width: 600
    height: mainContainer.height
    z: 2

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.topMargin: 8

    // State management
    property bool isShown: false
    visible: opacity > 0
    opacity: 0
    x: width

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    Behavior on x {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    signal recordingRequested()
    signal stopRecordingRequested()
    signal systemActionRequested(string action)
    signal performanceActionRequested(string action)

    // Shadow
    Rectangle {
        id: shadowSource
        anchors.fill: mainContainer
        color: "transparent"
        visible: false
        bottomLeftRadius: 20
        bottomRightRadius: 20
    }

    DropShadow {
        anchors.fill: shadowSource
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: shadowSource
        z: 1
    }

    // Background container with content - now centered
    Rectangle {
        id: mainContainer
        width: parent.width - 40 // Equal 20px margins on both sides
        height: mainColumn.height + (mainColumn.anchors.margins * 2)
        color: Data.Colors.bgColor
        bottomLeftRadius: 20
        bottomRightRadius: 20
        anchors.horizontalCenter: parent.horizontalCenter
        z: 2

        MouseArea {
            id: backgroundMouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
        }

        // Main content column with centered content
        Column {
            id: mainColumn
            width: parent.width - 36 // Equal 18px margins on both sides
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: 18
            spacing: 28

            Row {
                width: parent.width
                spacing: 18

                UserProfile {
                    id: userProfile
                    width: parent.width * 0.75 - parent.spacing * 2
                    height: 80
                    shell: root.shell
                }

                ThemeToggle {
                    id: themeToggle
                    width: 40
                    height: userProfile.height
                }

                WeatherDisplay {
                    id: weatherDisplay
                    width: parent.width * 0.18
                    height: userProfile.height
                    shell: root.shell
                    onEntered: hideTimer.stop()
                    onExited: hideTimer.restart()
                    visible: root.visible
                    enabled: visible
                }
            }

            Row {
                width: parent.width
                spacing: 18

                Column {
                    width: parent.width - notificationBar.width - parent.spacing
                    spacing: 28

                    RecordingButton {
                        id: recordingButton
                        width: parent.width
                        height: 48
                        shell: root.shell
                        isRecording: root.isRecording

                        onRecordingRequested: root.recordingRequested()
                        onStopRecordingRequested: root.stopRecordingRequested()
                    }

                    Controls {
                        id: controls
                        width: parent.width
                        isRecording: root.isRecording
                        shell: root.shell
                        visible: !root.isRecording
                        enabled: visible
                        onPerformanceActionRequested: function(action) { root.performanceActionRequested(action) }
                        onSystemActionRequested: function(action) { root.systemActionRequested(action) }
                        onMouseChanged: function(containsMouse) {
                            if (containsMouse) {
                                hideTimer.stop()
                            } else if (!root.isHovered) {
                                hideTimer.restart()
                            }
                        }
                    }
                }

                NotificationBar {
                    id: notificationBar
                    height: Math.max(recordingButton.height + (controls.height + 28), 80)
                    notificationHistoryVisible: notificationHistoryLoader.item ? notificationHistoryLoader.item.visible : false
                    clipboardHistoryVisible: clipboardHistoryLoader.item ? clipboardHistoryLoader.item.visible : false
                    notificationHistory: root.shell.notificationHistory
                    onNotificationToggleRequested: {
                        if (!notificationHistoryLoader.active) {
                            notificationHistoryLoader.pendingToggle = true
                            notificationHistoryLoader.active = true
                        } else if (notificationHistoryLoader.item) {
                            notificationHistoryLoader.item.toggle()
                        }
                    }
                    onClipboardToggleRequested: {
                        if (!clipboardHistoryLoader.active) {
                            clipboardHistoryLoader.pendingToggle = true
                            clipboardHistoryLoader.active = true
                        } else if (clipboardHistoryLoader.item) {
                            clipboardHistoryLoader.item.toggle()
                        }
                    }
                }
            }

            Column {
                id: systemTraySection
                width: parent.width
                spacing: 8
                visible: !root.isRecording
                height: visible ? implicitHeight : 0
                enabled: visible

                property bool containsMouse: trayMouseArea.containsMouse || systemTrayModule.containsMouse

                Rectangle {
                    id: trayBackground
                    width: parent.width
                    height: 40
                    radius: 20
                    color: Qt.darker(Data.Colors.bgColor, 1.15)

                    property bool isActive: false

                    MouseArea {
                        id: trayMouseArea
                        anchors.fill: parent
                        anchors.margins: -10
                        hoverEnabled: true
                        propagateComposedEvents: true
                        preventStealing: false
                        onEntered: trayBackground.isActive = true
                        onExited: {
                            if (!inlineTrayMenu.visible) {
                                Qt.callLater(function() {
                                    if (!systemTrayModule.containsMouse) {
                                        trayBackground.isActive = false
                                    }
                                })
                            }
                        }
                    }

                    Widgets.SystemTray {
                        id: systemTrayModule
                        anchors.centerIn: parent
                        shell: root.shell
                        bar: parent
                        trayMenu: inlineTrayMenu
                    }
                }
            }

            TrayMenu {
                id: inlineTrayMenu
                parent: mainContainer
                width: parent.width
                menu: null
                systemTrayY: systemTraySection.y
                systemTrayHeight: systemTraySection.height
                onHideRequested: trayBackground.isActive = false
            }
        }

        // Notification History View
        Loader {
            id: notificationHistoryLoader
            parent: mainContainer
            active: false
            asynchronous: true
            property bool pendingToggle: false

            onStatusChanged: {
                if (status === Loader.Ready && pendingToggle) {
                    item.toggle()
                    pendingToggle = false
                }
            }

            sourceComponent: Rectangle {
                id: notificationHistoryView
                width: mainContainer.width
                height: Screen.height - 24
                visible: false
                enabled: visible
                clip: true
                color: Data.Colors.bgColor
                radius: 20
                x: 0
                y: -mainContainer.y + 8
                z: 0

                property bool containsMouse: notifHistoryMouseArea.containsMouse
                property bool menuJustOpened: false

                MouseArea {
                    id: notifHistoryMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: false
                    propagateComposedEvents: true
                }

                onVisibleChanged: {
                    if (visible) {
                        menuJustOpened = true
                        hideTimer.stop()
                        Qt.callLater(function() {
                            menuJustOpened = false
                        })
                        if (clipboardHistoryLoader.item) clipboardHistoryLoader.item.visible = false
                    }
                }

                function toggle() {
                    if (!visible && !notificationHistoryLoader.active) {
                        notificationHistoryLoader.active = true
                        notificationHistoryLoader.item.visible = true
                    } else {
                        visible = !visible
                    }
                    if (visible) {
                        menuJustOpened = true
                        Qt.callLater(function() {
                            menuJustOpened = false
                        })
                    }
                }

                function hide() {
                    visible = false
                    menuJustOpened = false
                    unloadTimer.restart()
                }

                Timer {
                    id: unloadTimer
                    interval: 2000
                    onTriggered: {
                        if (!parent.visible) {
                            notificationHistoryLoader.active = false
                        }
                    }
                }

                Widgets.NotificationHistory {
                    anchors.fill: parent
                    anchors.margins: 20
                    shell: root.shell
                    clip: true
                }
            }
        }

        // Clipboard History View
        Loader {
            id: clipboardHistoryLoader
            parent: mainContainer
            active: false
            asynchronous: true
            property bool pendingToggle: false

            onStatusChanged: {
                if (status === Loader.Ready && pendingToggle) {
                    item.toggle()
                    pendingToggle = false
                }
            }

            sourceComponent: Rectangle {
                id: clipboardHistoryView
                width: mainContainer.width
                height: Screen.height - 24
                visible: false
                enabled: visible
                clip: true
                color: Data.Colors.bgColor
                radius: 20
                x: 0
                y: -mainContainer.y + 8
                z: 0

                property bool containsMouse: clipHistoryMouseArea.containsMouse
                property bool menuJustOpened: false

                MouseArea {
                    id: clipHistoryMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    preventStealing: true
                    propagateComposedEvents: false
                }

                onVisibleChanged: {
                    if (visible) {
                        menuJustOpened = true
                        hideTimer.stop()
                        Qt.callLater(function() {
                            menuJustOpened = false
                        })
                        if (notificationHistoryLoader.item) notificationHistoryLoader.item.visible = false
                    }
                }

                function toggle() {
                    if (!visible && !clipboardHistoryLoader.active) {
                        clipboardHistoryLoader.active = true
                        clipboardHistoryLoader.item.visible = true
                    } else {
                        visible = !visible
                    }
                    if (visible) {
                        menuJustOpened = true
                        Qt.callLater(function() {
                            menuJustOpened = false
                        })
                    }
                }

                function hide() {
                    visible = false
                    menuJustOpened = false
                    unloadTimer.restart()
                }

                Timer {
                    id: unloadTimer
                    interval: 2000
                    onTriggered: {
                        if (!parent.visible) {
                            clipboardHistoryLoader.active = false
                        }
                    }
                }

                Widgets.Cliphist {
                    anchors.fill: parent
                    anchors.margins: 20
                    shell: root.shell
                    onCloseRequested: parent.hide()
                }
            }
        }
    }

    property bool isHovered: {
        const menuStates = {
            inlineMenuActive: inlineTrayMenu.menuJustOpened || inlineTrayMenu.visible,
            trayActive: trayBackground.isActive,
            notifActive: notificationHistoryLoader.item && 
                        (notificationHistoryLoader.item.menuJustOpened || notificationHistoryLoader.item.visible),
            clipboardActive: clipboardHistoryLoader.item && 
                           (clipboardHistoryLoader.item.menuJustOpened || clipboardHistoryLoader.item.visible),
            weatherActive: weatherDisplay.menuJustOpened || weatherDisplay.containsMouse
        }
        
        if (menuStates.inlineMenuActive || menuStates.trayActive || 
            menuStates.notifActive || menuStates.clipboardActive ||
            menuStates.weatherActive) return true

        const mouseStates = {
            backgroundHovered: backgroundMouseArea.containsMouse,
            recordingHovered: recordingButton.containsMouse,
            controlsHovered: controls.containsMouse,
            profileHovered: userProfile.isHovered,
            themeToggleHovered: themeToggle.containsMouse,
            systemTrayHovered: systemTraySection.containsMouse || 
                             trayMouseArea.containsMouse || 
                             systemTrayModule.containsMouse,
            menuHovered: inlineTrayMenu.containsMouse,
            notifHovered: notificationHistoryLoader.item && notificationHistoryLoader.item.containsMouse,
            clipboardHovered: clipboardHistoryLoader.item && clipboardHistoryLoader.item.containsMouse,
            notificationBarHovered: notificationBar.containsMouse,
            weatherHovered: weatherDisplay.containsMouse
        }

        return Object.values(mouseStates).some(state => state)
    }

    Timer {
        id: hideTimer
        interval: 500
        repeat: false
        onTriggered: hide()
    }

    onIsHoveredChanged: {
        if (isHovered) {
            hideTimer.stop()
        } else if (!inlineTrayMenu.visible && !trayBackground.isActive) {
            hideTimer.restart()
        }
    }

    function show() {
        if (isShown) return
        isShown = true
        hideTimer.stop()
        opacity = 1
        x: 0
    }

    function hide() {
        if (!isShown || inlineTrayMenu.menuJustOpened || inlineTrayMenu.visible) return
        isShown = false
        x = width
        opacity = 0
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            mainColumn.visible = true
            root.height = mainContainer.height
        })
    }

    Timer {
        id: notificationUnloadTimer
        interval: 2000
        onTriggered: {
            if (notificationHistoryLoader.item && !notificationHistoryLoader.item.visible) {
                notificationHistoryLoader.active = false
            }
        }
    }

    Timer {
        id: clipboardUnloadTimer
        interval: 2000
        onTriggered: {
            if (clipboardHistoryLoader.item && !clipboardHistoryLoader.item.visible) {
                clipboardHistoryLoader.active = false
            }
        }
    }

    Connections {
        target: notificationHistoryLoader.item
        function onVisibleChanged() {
            if (!notificationHistoryLoader.item.visible) {
                notificationUnloadTimer.restart()
            }
        }
    }

    Connections {
        target: clipboardHistoryLoader.item
        function onVisibleChanged() {
            if (!clipboardHistoryLoader.item.visible) {
                clipboardUnloadTimer.restart()
            }
        }
    }
}