import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import "root:/settings" as Settings

Row {
    property var bar
    property var shell
    property var trayMenu
    spacing: 8
    Layout.alignment: Qt.AlignVCenter
    
    property bool containsMouse: false
    property var systemTray: SystemTray
    
    // Use a WeakMap-like approach for icon cache
    property var iconCache: ({})
    property var iconCacheCount: ({})
    
    // Clean up icon cache periodically
    Timer {
        interval: 30000  // Every 30 seconds
        repeat: true
        running: true
        onTriggered: {
            // Remove icons that haven't been used in a while
            for (let icon in iconCacheCount) {
                if (iconCacheCount[icon] > 0) {
                    iconCacheCount[icon]--
                } else {
                    delete iconCache[icon]
                    delete iconCacheCount[icon]
                }
            }
        }
    }
    
    Repeater {
        model: systemTray.items
        delegate: Item {
            width: 24
            height: 24
            property bool isHovered: trayMouseArea.containsMouse
            
            onIsHoveredChanged: updateParentHoverState()
            Component.onCompleted: updateParentHoverState()
            
            function updateParentHoverState() {
                let anyHovered = false
                for (let i = 0; i < parent.children.length; i++) {
                    if (parent.children[i].isHovered) {
                        anyHovered = true
                        break
                    }
                }
                parent.containsMouse = anyHovered
            }
            
            // Only animate when actually hovered
            scale: isHovered ? 1.15 : 1.0
            Behavior on scale {
                enabled: isHovered
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
            
            rotation: isHovered ? 5 : 0
            Behavior on rotation {
                enabled: isHovered
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            
            Image {
                id: trayIcon
                anchors.centerIn: parent
                width: 18
                height: 18
                sourceSize.width: 36
                sourceSize.height: 36
                smooth: true
                asynchronous: true
                cache: true
                source: {
                    let icon = modelData?.icon || "";
                    if (!icon) return "";
                    
                    if (iconCache[icon]) {
                        iconCacheCount[icon] = 3  // Reset counter when used
                        return iconCache[icon];
                    }
                    
                    let finalPath = icon;
                    if (icon.includes("?path=")) {
                        const [name, path] = icon.split("?path=");
                        const fileName = name.substring(name.lastIndexOf("/") + 1);
                        finalPath = `file://${path}/${fileName}`;
                    }
                    
                    iconCache[icon] = finalPath;
                    iconCacheCount[icon] = 3;  // Start with 3 uses before cleanup
                    return finalPath;
                }
                opacity: status === Image.Ready ? 1 : 0
                
                Behavior on opacity {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }
            }
            
            Component.onDestruction: {
                let icon = modelData?.icon || "";
                if (icon) {
                    delete iconCache[icon];
                    delete iconCacheCount[icon];
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
                            const iconCenter = Qt.point(width / 2, height)
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