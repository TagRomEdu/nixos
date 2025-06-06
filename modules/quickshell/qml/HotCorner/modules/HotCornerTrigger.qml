import QtQuick

Rectangle {
    id: root
    width: 48
    height: 48
    color: "transparent"
    anchors.right: parent.right
    anchors.top: parent.top
    z: 999

    signal triggered()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -8
        hoverEnabled: true

        property bool isHovered: containsMouse

        onIsHoveredChanged: {
            if (isHovered) {
                showTimer.start()  // Start the show delay timer when hovered
                hideTimer.stop()   // Stop any hide delay timer to keep visible
            } else {
                hideTimer.start()  // Start the hide delay timer when no longer hovered
                showTimer.stop()   // Stop the show timer to prevent duplicate triggers
            }
        }

        onEntered: hideTimer.stop()  // Cancel hide timer immediately on re-entry
    }

    // Timer to delay the triggering of the action after hover
    Timer {
        id: showTimer
        interval: 200
        onTriggered: root.triggered()
    }

    // Timer to delay hiding, controlled externally
    Timer {
        id: hideTimer
        interval: 500
    }

    // Expose useful properties and control functions to parent
    readonly property alias containsMouse: mouseArea.containsMouse
    function stopHideTimer() { hideTimer.stop() }
    function startHideTimer() { hideTimer.start() }
}
