import QtQuick

Rectangle {
    id: root
    width: 360
    height: 1
    color: "transparent"
    anchors.top: parent.top

    signal triggered()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        property bool isHovered: containsMouse
        
        onIsHoveredChanged: {
            if (isHovered) {
                showTimer.start()
                hideTimer.stop()
            } else {
                hideTimer.start()
                showTimer.stop()
            }
        }
        
        onEntered: hideTimer.stop()
    }

    // Smooth show/hide timers
    Timer {
        id: showTimer
        interval: 200
        onTriggered: root.triggered()
    }

    Timer {
        id: hideTimer
        interval: 500
    }

    // Expose properties and functions for parent components
    readonly property alias containsMouse: mouseArea.containsMouse
    function stopHideTimer() { hideTimer.stop() }
    function startHideTimer() { hideTimer.start() }
}