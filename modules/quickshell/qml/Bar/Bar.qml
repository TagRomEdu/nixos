import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Shapes
import "../Data" as Data

Item {
    required property var shell
    required property var popup

    required property var bar

    width: 520
    height: 42

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
    }

    Rectangle {
        id: barRect
        anchors.fill: parent
        height: 28
        color: shell.bgColor
        bottomLeftRadius: 20
        bottomRightRadius: 20

        // Subtle entrance animation
        opacity: 0
        Component.onCompleted: {
            opacity = 1
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            RowLayout {
                anchors.fill: parent
                spacing: 12

                Column {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 8

                    Row {
                        spacing: 8
                        anchors.verticalCenter: parent.verticalCenter

                        Repeater {
                            model: shell.workspaces
                            delegate: Rectangle {
                                id: workspaceRect
                                radius: 20
                                width: 24
                                height: 24
                                color: modelData && modelData.id === shell.focusedWorkspace?.id
                                    ? shell.accentColor : Qt.darker(shell.fgColor, 2.5)
                                
                                property bool isActive: modelData && modelData.id === shell.focusedWorkspace?.id
                                property bool isHovered: workspaceMouseArea.containsMouse

                                // Smooth color transitions
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 200
                                        easing.type: Easing.OutCubic
                                    }
                                }

                                // Scale animation for active workspace
                                scale: isActive ? 1.1 : (isHovered ? 1.05 : 1.0)
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutCubic
                                    }
                                }

                                // Subtle glow effect for active workspace
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: parent.width + 4
                                    height: parent.height + 4
                                    radius: parent.radius + 2
                                    color: "transparent"
                                    border.color: shell.accentColor
                                    border.width: isActive ? 1 : 0
                                    opacity: isActive ? 0.3 : 0
                                    
                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                    
                                    Behavior on border.width {
                                        NumberAnimation {
                                            duration: 200
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                Label {
                                    text: modelData?.id || "?"
                                    anchors.centerIn: parent
                                    color: shell.bgColor
                                    font.pixelSize: 12
                                    font.bold: true
                                    
                                    // Subtle text animation
                                    scale: parent.isActive ? 1.05 : 1.0
                                    Behavior on scale {
                                        NumberAnimation {
                                            duration: 150
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                MouseArea {
                                    id: workspaceMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        if (modelData?.id && Hyprland.dispatch) {
                                            Hyprland.dispatch("workspace " + modelData.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    id: volumeRect
                    width: 48
                    height: 24
                    radius: 20
                    color: shell.accentColor
                    Layout.alignment: Qt.AlignVCenter
                    
                    property bool isHovered: volumeMouseArea.containsMouse

                    // Hover animation
                    scale: isHovered ? 1.05 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }

                    // Color animation on hover
                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }

                    Label {
                        id: volumeLabel
                        anchors.centerIn: parent
                        text: shell.volume + "%"
                        verticalAlignment: Text.AlignVCenter
                        color: shell.bgColor
                        font.pixelSize: 12
                        font.bold: true
                        font.family: "FiraCode Nerd Font"
                        
                        // Animate volume changes
                        Behavior on text {
                            SequentialAnimation {
                                NumberAnimation {
                                    target: volumeLabel
                                    property: "scale"
                                    to: 1.1
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }
                                NumberAnimation {
                                    target: volumeLabel
                                    property: "scale"
                                    to: 1.0
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: volumeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: pavucontrol.running = true
                    }
                }

                Row {
                    spacing: 8
                    Layout.alignment: Qt.AlignVCenter

                    Repeater {
                        model: shell.trayItems
                        delegate: Item {
                            width: 24
                            height: 24
                            visible: modelData && modelData.appName !== "spotify"
                            
                            property bool isHovered: trayMouseArea.containsMouse

                            // Hover scale animation
                            scale: isHovered ? 1.15 : 1.0
                            Behavior on scale {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutCubic
                                }
                            }

                            // Subtle rotation on hover
                            rotation: isHovered ? 5 : 0
                            Behavior on rotation {
                                NumberAnimation {
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }
                            }

                            Image {
                                anchors.centerIn: parent
                                width: 18
                                height: 18
                                source: {
                                    let icon = modelData?.icon || "";
                                    if (icon.includes("?path=")) {
                                        const [name, path] = icon.split("?path=");
                                        const fileName = name.substring(name.lastIndexOf("/") + 1);
                                         return `file://${path}/${fileName}`;
                                    }
                                    return icon;
                                }

                                // Smooth opacity animation on load
                                opacity: 0
                                Component.onCompleted: opacity = 1
                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 300
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }

                            MouseArea {
                                id: trayMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                                onClicked: (mouse) => {
                                    if (!modelData) return;
                                    if (mouse.button === Qt.LeftButton) modelData.activate()
                                    else if (mouse.button === Qt.RightButton && modelData.hasMenu)
                                        modelData.display(bar, mouse.x, mouse.y)
                                    else if (mouse.button === Qt.MiddleButton) modelData.secondaryActivate()
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton
                                onClicked: (mouse) => {
                                    if (!modelData || !modelData.hasMenu) return;

                                    const window = bar.QsWindow.window;
                                    if (!window) return;

                                    const globalPos = mapToItem(window.contentItem, 0, height);
                                    menuAnchor.anchor.rect = Qt.rect(globalPos.x, globalPos.y, width, height);
                                    menuAnchor.open();
                                }
                            }

                            QsMenuAnchor {
                                id: menuAnchor
                                menu: modelData.menu
                                anchor.window: bar.QsWindow.window ?? null
                                anchor.adjustment: PopupAdjustment.Flip
                            }
                        }
                    }
                }

                Column {
                    width: 80
                    spacing: 2
                    Layout.alignment: Qt.AlignVCenter

                    Label {
                        id: timeLabel
                        width: parent.width
                        text: shell.time
                        color: shell.accentColor
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        
                        // Subtle pulse animation every minute
                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            NumberAnimation {
                                to: 1.02
                                duration: 60000 // 1 minute
                                easing.type: Easing.InOutSine
                            }
                            NumberAnimation {
                                to: 1.0
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                            PauseAnimation { duration: 59800 }
                        }
                    }

                    Label {
                        width: parent.width
                        text: shell.date
                        color: Qt.lighter(shell.fgColor, 1.2)
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        
                        // Fade in animation
                        opacity: 0
                        Component.onCompleted: opacity = 1
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 800
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }

    // Right Corner Shape - Now controls cliphistWindow
    Shape {
        id: rightCornerShape
        width: 60
        height: barRect.height
        y: barRect.y
        x: barRect.x + barRect.width - 5
        preferredRendererType: Shape.CurveRenderer

        // Entrance animation
        opacity: 0
        Component.onCompleted: opacity = 1
        Behavior on opacity {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutCubic
            }
        }

        ShapePath {
            strokeWidth: 0
            fillColor: shell.accentColor
            strokeColor: "transparent"

            startX: rightCornerShape.width
            startY: 0

            PathLine { x: 15; y: 0 }
            PathLine { x: 15; y: 20 }

            PathArc {
                x: 5; y: 40
                radiusX: 20; radiusY: 20
                useLargeArc: false
                direction: PathArc.Clockwise
            }

            PathLine { x: 0; y: 42 }
            PathLine { x: rightCornerShape.width - 20; y: rightCornerShape.height }

            PathArc {
                x: rightCornerShape.width; y: rightCornerShape.height - 20
                radiusX: 20; radiusY: 20
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }

            PathLine { x: rightCornerShape.width; y: 0 }
        }

        Rectangle {
            id: popupButtons
            width: 24
            height: 24
            radius: 20
            color: (shell.cliphistWindow && shell.cliphistWindow.visible) ? Qt.darker(shell.accentColor, 1.3) : shell.bgColor
            anchors.verticalCenter: parent.verticalCenter
            x: 23
            
            property bool isHovered: rightPopupMouseArea.containsMouse
            property bool isCliphistActive: shell.cliphistWindow && shell.cliphistWindow.visible

            // Smooth color transitions
            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            // Hover and active state animations
            scale: isCliphistActive ? 1.1 : (isHovered ? 1.05 : 1.0)
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Label {
                anchors.centerIn: parent
                text: ""
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 14
                color: shell.fgColor
                
                // Clipboard icon bounce animation
                scale: parent.isHovered ? 1.1 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutBack
                    }
                }
            }

            MouseArea {
                id: rightPopupMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    console.log("Right button clicked - toggling cliphistWindow")
                    if (shell.cliphistWindow) {
                        // Close the main popup if it's open
                        if (popup.visible) {
                            popup.visible = false
                        }
                        
                        // Toggle clipboard window
                        if (shell.cliphistWindow.visible) {
                            shell.cliphistWindow.visible = false
                        } else {
                            shell.cliphistWindow.visible = true
                        }
                    } else {
                        console.log("cliphistWindow not found")
                    }
                }
            }
        }
    }

    // Left Corner Shape - Now controls popupWindow
    Shape {
        id: leftCornerShape
        width: 60
        height: barRect.height
        y: barRect.y
        x: barRect.x - width + 5
        preferredRendererType: Shape.CurveRenderer

        // Entrance animation with slight delay
        opacity: 0
        Component.onCompleted: {
            leftAnimationTimer.start()
        }
        
        Timer {
            id: leftAnimationTimer
            interval: 100
            onTriggered: leftCornerShape.opacity = 1
        }
        
        Behavior on opacity {
            NumberAnimation {
                duration: 600
                easing.type: Easing.OutCubic
            }
        }

        ShapePath {
            strokeWidth: 0
            fillColor: shell.accentColor
            strokeColor: "transparent"

            startX: 0
            startY: 0

            PathLine { x: leftCornerShape.width - 15; y: 0 }
            PathLine { x: leftCornerShape.width - 15; y: 20 }

            PathArc {
                x: leftCornerShape.width - 5; y: 40
                radiusX: 20; radiusY: 20
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }

            PathLine { x: leftCornerShape.width; y: 42 }
            PathLine { x: 20; y: leftCornerShape.height }

            PathArc {
                x: 0; y: leftCornerShape.height - 20
                radiusX: 20; radiusY: 20
                useLargeArc: false
                direction: PathArc.Clockwise
            }

            PathLine { x: 0; y: 0 }
        }

        Rectangle {
            id: popupButtonsLeft
            width: 24
            height: 24
            radius: 20
            color: popup.visible ? Qt.darker(shell.accentColor, 1.3) : shell.bgColor
            anchors.verticalCenter: parent.verticalCenter
            x: width - 13
            
            property bool isHovered: leftPopupMouseArea.containsMouse

            // Smooth color transitions
            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            // Hover and active state animations
            scale: popup.visible ? 1.1 : (isHovered ? 1.05 : 1.0)
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Label {
                anchors.centerIn: parent
                text: "󰘖"
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 14
                color: shell.fgColor
                
                // Icon pulse animation
                scale: parent.isHovered ? 1.1 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutBack
                    }
                }
            }

            MouseArea {
                id: leftPopupMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    // Close the clipboard window if it's open
                    if (shell.cliphistWindow && shell.cliphistWindow.visible) {
                        shell.cliphistWindow.visible = false
                    }
                    
                    // Toggle main popup
                    popup.visible = !popup.visible
                }
            }
        }
    }
}