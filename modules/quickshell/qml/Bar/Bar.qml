import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Shapes

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
                                radius: 20
                                width: 24
                                height: 24
                                color: modelData && modelData.id === shell.focusedWorkspace?.id
                                    ? shell.accentColor : Qt.darker(shell.fgColor, 2.5)

                                Label {
                                    text: modelData?.id || "?"
                                    anchors.centerIn: parent
                                    color: shell.bgColor
                                    font.pixelSize: 12
                                    font.bold: true
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
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: 48
                    height: 24
                    radius: 20
                    color: shell.accentColor
                    Layout.alignment: Qt.AlignVCenter

                    Label {
                        anchors.centerIn: parent
                        text: shell.volume + "%"
                        verticalAlignment: Text.AlignVCenter
                        color: shell.bgColor
                        font.pixelSize: 12
                        font.bold: true
                        font.family: "FiraCode Nerd Font"
                    }

                    MouseArea {
                        anchors.fill: parent
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

                            Image {
                                anchors.centerIn: parent
                                width: 16
                                height: 16
                                source: {
                                    let icon = modelData?.icon || "";
                                    if (icon.includes("?path=")) {
                                        const [name, path] = icon.split("?path=");
                                        const fileName = name.substring(name.lastIndexOf("/") + 1);
                                        return `file://${path}/${fileName}`;
                                    }
                                    return icon;
                                }
                            }

                            MouseArea {
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
                        width: parent.width
                        text: shell.time
                        color: shell.accentColor
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 14
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Label {
                        width: parent.width
                        text: shell.date
                        color: Qt.lighter(shell.fgColor, 1.2)
                        font.family: "FiraCode Nerd Font"
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

    // Right Corner Shape
    Shape {
        id: rightCornerShape
        width: 60
        height: barRect.height
        y: barRect.y
        x: barRect.x + barRect.width - 5
        preferredRendererType: Shape.CurveRenderer

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
            color: popup.visible ? Qt.darker(shell.accentColor, 1.3) : shell.bgColor
            anchors.verticalCenter: parent.verticalCenter
            x: 22

            Label {
                anchors.centerIn: parent
                text: shell.getWeatherEmoji(shell.weatherData.currentCondition || "?")
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 14
                color: shell.fgColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: popup.visible = !popup.visible
                hoverEnabled: true
            }
        }
    }

    // Left Corner Shape
    Shape {
        id: leftCornerShape
        width: 60
        height: barRect.height
        y: barRect.y
        x: barRect.x - width + 5
        preferredRendererType: Shape.CurveRenderer

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

            Label {
                anchors.centerIn: parent
                text: ""
                font.family: "FiraCode Nerd Font"
                font.pixelSize: 14
                color: shell.fgColor
            }

            MouseArea {
                anchors.fill: parent
                onClicked: popup.visible = !popup.visible
                hoverEnabled: true
            }
        }
    }
}
