import QtQuick
import QtQuick.Controls
import "root:/Data" as Data
import "root:/Widgets" as Widgets

Popup {
    id: calendarPopup
    property bool hovered: false
    property var shell
    property int targetX: 0
    readonly property int targetY: Screen.height - height

    width: 280
    height: 280
    modal: false
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 15

    property bool _visible: false
    property real animX: targetX - 20
    property real animOpacity: 0

    x: animX
    y: targetY
    opacity: animOpacity
    visible: _visible

    Behavior on animX {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }
    Behavior on animOpacity {
        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
    }

    onHoveredChanged: {
        if (hovered) {
            _visible = true
            animX = targetX
            animOpacity = 1
        } else {
            animX = targetX - 20
            animOpacity = 0
        }
    }

    onAnimOpacityChanged: {
        if (animOpacity === 0 && !hovered) {
            _visible = false
        }
    }

    function setHovered(state) {
        hovered = state
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        anchors.margins: 10 // larger area to reduce flicker

        onEntered: {
            setHovered(true)
            if (bar) bar.calendarHovered = true
        }
        onExited: {
            // Delay exit check to avoid flicker
            Qt.callLater(() => {
                if (!hoverArea.containsMouse) {
                    setHovered(false)
                    if (bar) {
                        bar.calendarHovered = false
                        bar.scheduleHide()
                    }
                }
            })
        }
    }

    Widgets.Calendar {
        anchors.fill: parent
        shell: calendarPopup.shell
    }

    background: Rectangle {
        color: Data.Colors.bgColor
        topRightRadius: 20
    }
}
