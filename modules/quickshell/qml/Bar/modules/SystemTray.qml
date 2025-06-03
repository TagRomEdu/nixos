import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

Row {
    required property var shell
    required property var bar
    
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
                    
                    if (mouse.button === Qt.LeftButton) {
                        modelData.activate();
                    } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                        // Calculate position with better centering
                        let currentItem = parent;
                        let totalX = width / 2; // Start from center of icon
                        
                        // Walk up to find our position in the RowLayout
                        while (currentItem && currentItem.parent) {
                            if (currentItem.x !== undefined) {
                                totalX += currentItem.x;
                            }
                            currentItem = currentItem.parent;
                            // Stop when we reach the RowLayout or Item with margins
                            if (currentItem.toString().includes("RowLayout") || 
                                currentItem.toString().includes("Item")) {
                                break;
                            }
                        }
                        
                        console.log("Centered X position:", totalX);
                        modelData.display(bar, totalX, height + 19);
                    } else if (mouse.button === Qt.MiddleButton) {
                        modelData.secondaryActivate();
                    }
                }
            }
        }
    }
}