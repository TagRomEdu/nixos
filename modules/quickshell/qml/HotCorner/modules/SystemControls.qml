import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    id: root
    required property var shell
    
    spacing: 8
    signal systemActionRequested(string action)
    signal mouseChanged(bool containsMouse)
    
    // True if mouse is over any button
    readonly property bool containsMouse: lockButton.containsMouse || 
                                         rebootButton.containsMouse || 
                                         shutdownButton.containsMouse
    
    // Notify when mouse presence changes
    onContainsMouseChanged: root.mouseChanged(containsMouse)
    
    opacity: visible ? 1 : 0
    Behavior on opacity {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    // Lock button triggers "lock" action
    SystemButton {
        id: lockButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        shell: root.shell
        iconText: "\uf023"
        
        onClicked: root.systemActionRequested("lock")
        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse)
                root.mouseChanged(false)
        }
    }

    // Reboot button triggers "reboot" action
    SystemButton {
        id: rebootButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        shell: root.shell
        iconText: "\uf2f1"
        
        onClicked: root.systemActionRequested("reboot")
        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse)
                root.mouseChanged(false)
        }
    }

    // Shutdown button triggers "shutdown" action
    SystemButton {
        id: shutdownButton
        Layout.fillHeight: true
        Layout.fillWidth: true
        
        shell: root.shell
        iconText: "\uf011"
        
        onClicked: root.systemActionRequested("shutdown")
        onMouseChanged: function(containsMouse) {
            if (!containsMouse && !root.containsMouse)
                root.mouseChanged(false)
        }
    }
}
