import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "root:/settings" as Settings

Column {
    id: root
    property var shell
    spacing: 8
    width: parent.width

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            width: 22
            height: 22
            radius: 6
            anchors.horizontalCenter: parent.horizontalCenter
            color: modelData.active ? Settings.Theme.accent : "transparent"
            border.color: Settings.Theme.accent
            border.width: modelData.active ? 0 : 1
            opacity: modelData.active ? 1 : 0.6

            Text {
                anchors.centerIn: parent
                text: modelData.name || modelData.id
                color: modelData.active ? Settings.Theme.background : Settings.Theme.primaryText
                font.family: "JetBrains Mono"
                font.pixelSize: 12
                font.bold: modelData.active
            }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
                onPressAndHold: {
                    if (modelData.id > 0) { // Only allow moving regular workspaces
                        Hyprland.dispatch(`movetoworkspace ${modelData.id}`)
                    }
                }
            }
        }
    }

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            Hyprland.refreshWorkspaces()
        }
    }

    Component.onCompleted: Hyprland.refreshWorkspaces()
} 