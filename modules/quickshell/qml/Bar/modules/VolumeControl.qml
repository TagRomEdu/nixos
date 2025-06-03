import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "root:/Data" as Data

Rectangle {
    id: volumeRect
    required property var shell
    required property var pavucontrol
    
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
        onClicked: Data.ProcessManager.openPavuControl()
    }
}