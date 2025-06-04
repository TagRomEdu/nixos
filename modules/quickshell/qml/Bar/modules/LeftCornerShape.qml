import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Shape {
    id: leftCornerShape
    required property var shell
    required property var popup
    required property var barRect
    
    width: 60
    height: barRect.height
    y: barRect.y
    //x: barRect.x - width + 5
    x: barRect.x - width + 16
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