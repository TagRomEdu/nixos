import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

Row {
    property var bar
    property var shell
    property var trayMenu
    spacing: 8
    Layout.alignment: Qt.AlignVCenter
    
    property var systemTray: SystemTray
    
    Repeater {
        model: systemTray.items
        delegate: Item {
            width: 24
            height: 24
            property bool isHovered: trayMouseArea.containsMouse
            
            scale: isHovered ? 1.15 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            
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
                    
                    if (mouse.button === Qt.LeftButton) {
                        if (trayMenu && trayMenu.visible) {
                            trayMenu.hide()
                        }
                        if (!modelData.onlyMenu) {
                            modelData.activate()
                        }
                    } else if (mouse.button === Qt.MiddleButton) {
                        if (trayMenu && trayMenu.visible) {
                            trayMenu.hide()
                        }
                        modelData.secondaryActivate && modelData.secondaryActivate()
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayMenu && trayMenu.visible) {
                            trayMenu.hide()
                            return
                        }
                        if (modelData.hasMenu && modelData.menu && trayMenu) {
                            trayMenu.menu = modelData.menu
                            if (parent.parent.parent.showTrayMenu) {
                                const iconCenter = Qt.point(width / 2, height)
                                parent.parent.parent.showTrayMenu(iconCenter, this)
                            } else {
                                const iconPos = mapToItem(trayMenu.parent, 0, 0)
                                const menuX = iconPos.x - (trayMenu.width / 2) + (width / 2)
                                const menuY = iconPos.y + height + 15
                                trayMenu.show(Qt.point(menuX, menuY), trayMenu.parent)
                            }
                        }
                    }
                }
            }
        }
    }
}
