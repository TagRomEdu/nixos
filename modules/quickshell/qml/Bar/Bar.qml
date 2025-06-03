import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Shapes
import "../Data" as Data
import "./modules" as BarModules

Item {
    id: root
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
        Component.onCompleted: opacity = 1
        
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

                BarModules.WorkspaceIndicator {
                    shell: root.shell
                }

                Item { Layout.fillWidth: true }

                BarModules.VolumeControl {
                    shell: root.shell
                    pavucontrol: root.pavucontrol
                }

                BarModules.SystemTray {
                    shell: root.shell
                    bar: root.bar
                }

                BarModules.DateTimeDisplay {
                    shell: root.shell
                }
            }
        }
    }

    BarModules.RightCornerShape {
        shell: root.shell
        popup: root.popup
        barRect: barRect
    }

    BarModules.LeftCornerShape {
        shell: root.shell
        popup: root.popup
        barRect: barRect
    }
}