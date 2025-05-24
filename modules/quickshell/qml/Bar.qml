import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Item {
    required property var shell
    required property var popup
    required property var bar
    
    anchors.fill: parent

    Process {
        id: pavucontrol
        command: ["pavucontrol"]
    }

    Rectangle {
        anchors.fill: parent
        color: shell.bgColor
        bottomLeftRadius: popup.visible ? 0 : 20
        bottomRightRadius: popup.visible ? 0 : 20
        
        RowLayout {
            anchors {
                fill: parent
                leftMargin: 16
                rightMargin: 16
                topMargin: 7
                bottomMargin: 5
            }
            spacing: 12

            Row {
                spacing: 8
                Layout.fillHeight: true

                Repeater {
                    model: shell.workspaces
                    delegate: Rectangle {
                        radius: 20
                        width: 24
                        height: 24
                        color: modelData && modelData.id === shell.focusedWorkspace?.id
                            ? shell.accentColor : Qt.darker(shell.fgColor, 2.5)

                        Label {
                            text: modelData?.id || "?"
                            anchors.centerIn: parent
                            color: shell.bgColor
                            font { pixelSize: 12; bold: true }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (modelData?.id && Hyprland.dispatch) {
                                    Hyprland.dispatch("workspace " + modelData.id)
                                }
                            }
                        }
                    }
                }
                
                Rectangle {
                    id: popupButton
                    width: 24
                    height: 24
                    radius: 20
                    color: popup.visible ? shell.accentColor : Qt.darker(shell.fgColor, 2.5)

                    Label {
                        anchors.centerIn: parent
                        text: ""
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 14
                        color: shell.bgColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: popup.visible = !popup.visible
                        hoverEnabled: true
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width: 48
                height: 24
                radius: 20
                color: shell.accentColor
                Label {
                    anchors.centerIn: parent
                    text: shell.volume + "%"
                    color: shell.bgColor
                    font {
                        pixelSize: 12
                        bold: true
                        family: "FiraCode Nerd Font"
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: pavucontrol.running = true
                }
            }

            Row {
                spacing: 8
                Layout.alignment: Qt.AlignRight

                Repeater {
                    model: shell.trayItems
                    delegate: Item {
                        width: 24
                        height: 24
                        visible: modelData && modelData.appName !== "spotify"

                        Image {
                            anchors.centerIn: parent
                        source: {
                            let icon = modelData?.icon || "";
                            if (icon.includes("?path=")) {
                                    const [name, path] = icon.split("?path=");
                                    const fileName = name.substring(name.lastIndexOf("/") + 1);
                                    return `file://${path}/${fileName}`;
                            }
                            return icon;
                        }
                            width: 16
                            height: 16
                            sourceSize: Qt.size(16, 16)
                        }

                        MouseArea {
                            id: root
                            
                            anchors.fill: parent
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

                                const globalPos = mapToItem(window.contentItem, 0, height); // map to below this icon
                                menuAnchor.anchor.rect = Qt.rect(globalPos.x, globalPos.y, width, height);
                                menuAnchor.open();
                            }
                        }

                        QsMenuAnchor {
                          id: menuAnchor
                          menu: modelData.menu
                          anchor.window: bar.QsWindow.window?? null
                          anchor.adjustment: PopupAdjustment.Flip
                        }
                    }
                }
            }

            Column {
                width: 80
                spacing: 2

                Label {
                    width: parent.width
                    text: shell.time
                    color: shell.accentColor
                    font {
                        family: "FiraCode Nerd Font"
                        pixelSize: 14
                        bold: true
                    }
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    width: parent.width
                    text: shell.date
                    color: Qt.lighter(shell.fgColor, 1.2)
                    font {
                        family: "FiraCode Nerd Font"
                        pixelSize: 10
                    }
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
  }
}
