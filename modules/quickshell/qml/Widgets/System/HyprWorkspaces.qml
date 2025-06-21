import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import "root:/Data" as Data
import "root:/Core" as Core

// Hyprland workspace indicator
Rectangle {
    id: root
    
    color: Data.Colors.bgColor
    width: 32
    height: workspaceColumn.implicitHeight + 24
    
    // Smooth height animation
    Behavior on height {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
    
    // Right-side rounded corners
    topRightRadius: width / 2
    bottomRightRadius: width / 2
    topLeftRadius: 0
    bottomLeftRadius: 0
    
    // Keep workspace list synchronized
    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            Hyprland.refreshWorkspaces()
        }
    }
    
    Component.onCompleted: {
        Hyprland.refreshWorkspaces()
    }
    
    // Vertical workspace indicator pills
    Column {
        id: workspaceColumn
        anchors.centerIn: parent
        spacing: 6
        
        Repeater {
            model: Hyprland.workspaces
            
            Rectangle {
                id: workspacePill
                
                // Dynamic sizing based on focus state
                width: 18  // Same width for both active and inactive
                height: modelData.active ? 36 : 22
                radius: width / 2
                scale: modelData.active ? 1.0 : 0.9
                
                // Material Design 3 inspired colors
                color: {
                    if (modelData.active) {
                        return Data.Colors.accent;
                    }
                    if (modelData.windows && modelData.windows.length > 0) {
                        return Qt.rgba(Data.Colors.accent.r, Data.Colors.accent.g, Data.Colors.accent.b, 0.5);
                    }
                    return Qt.rgba(Data.Colors.primaryText.r, Data.Colors.primaryText.g, Data.Colors.primaryText.b, 0.4);
                }
                
                // Elevation shadow
                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: modelData.active ? 1 : 0
                    anchors.leftMargin: modelData.active ? 0.5 : 0
                    anchors.rightMargin: modelData.active ? -0.5 : 0
                    anchors.bottomMargin: modelData.active ? -1 : 0
                    radius: parent.radius
                    color: Qt.rgba(0, 0, 0, modelData.active ? 0.15 : 0)
                    z: -1
                    visible: modelData.active
                    
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                
                // Smooth Material Design transitions
                Behavior on width { 
                    NumberAnimation { 
                        duration: 300
                        easing.type: Easing.OutCubic 
                    } 
                }
                Behavior on height { 
                    NumberAnimation { 
                        duration: 300
                        easing.type: Easing.OutCubic 
                    } 
                }
                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on color { 
                    ColorAnimation { 
                        duration: 200 
                    } 
                }
                
                // Workspace number text
                Text {
                    anchors.centerIn: parent
                    text: modelData.name || modelData.id.toString()
                    color: modelData.active ? Data.Colors.background : Data.Colors.primaryText
                    font.pixelSize: modelData.active ? 10 : 8
                    font.bold: modelData.active
                    font.family: "Roboto, sans-serif"
                    visible: modelData.active || (modelData.windows && modelData.windows.length > 0)
                    
                    Behavior on font.pixelSize { NumberAnimation { duration: 200 } }
                    Behavior on color { ColorAnimation { duration: 200 } }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // Switch workspace via Hyprland
                        Hyprland.dispatch("workspace " + modelData.id);
                    }
                    
                    // Hover feedback
                    onEntered: {
                        if (!modelData.active) {
                            workspacePill.color = Qt.rgba(Data.Colors.primaryText.r, Data.Colors.primaryText.g, Data.Colors.primaryText.b, 0.6);
                        }
                    }
                    
                    onExited: {
                        // Reset to normal color
                        if (!modelData.active) {
                            if (modelData.windows && modelData.windows.length > 0) {
                                workspacePill.color = Qt.rgba(Data.Colors.accent.r, Data.Colors.accent.g, Data.Colors.accent.b, 0.5);
                            } else {
                                workspacePill.color = Qt.rgba(Data.Colors.primaryText.r, Data.Colors.primaryText.g, Data.Colors.primaryText.b, 0.4);
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Border integration corners
    Core.Corners {
        id: topLeftCorner
        position: "topleft"
        size: 1.3
        fillColor: Data.Colors.bgColor 
        offsetX: -41
        offsetY: -25
    }

    Core.Corners {
        id: bottomLeftCorner
        position: "bottomleft"
        size: 1.3
        fillColor: Data.Colors.bgColor
        offsetX: -41
        offsetY: 78
    }
} 