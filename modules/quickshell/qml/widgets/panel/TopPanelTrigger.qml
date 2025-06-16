import QtQuick

// Trigger area for showing top panel on hover
Rectangle {
    id: root
    width: 360
    height: 1
    color: "transparent"
    anchors.top: parent.top

    signal triggered()

    // Hover detection area
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

    // Delayed show/hide timers
    Timer {
        id: showTimer
        interval: 200
        onTriggered: root.triggered()
    }

    Timer {
        id: hideTimer
        interval: 500
    }

    readonly property alias containsMouse: mouseArea.containsMouse
    function stopHideTimer() { hideTimer.stop() }
    function startHideTimer() { hideTimer.start() }
}